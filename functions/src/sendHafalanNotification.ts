import { onDocumentWritten } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

/**
 * Firestore-triggered Cloud Function that sends FCM push notifications
 * to Wali Santri (parents/guardians) when a hafalan (memorization) session
 * is saved or synced to Firestore by the Guru.
 *
 * Trigger: Any write (create or update) on /hafalan_santri/{docId}
 * Region: asia-southeast2 (Jakarta) — matches all existing project functions
 *
 * Deduplication strategy:
 *   - Checks for the presence of `notifiedAt` field before processing.
 *   - After successfully dispatching the message, writes `notifiedAt` back
 *     to the document so this function is idempotent across multiple writes
 *     (e.g., offline sync re-pushing an already-synced record).
 *
 * FCM Lookup chain:
 *   afterData.santriId
 *     → /santri/{santriId}.authUid
 *       → /users/{authUid}.fcmToken
 *         → FCM push notification to Wali Santri device
 */
export const sendHafalanNotification = onDocumentWritten(
  {
    document: "hafalan_santri/{docId}",
    region: "asia-southeast2",
  },
  async (event) => {
    // ── Guard: ignore deletions ─────────────────────────────────────────────
    const afterSnap = event.data?.after;
    if (!afterSnap || !afterSnap.exists) {
      console.log("sendHafalanNotification: document deleted — skipping.");
      return;
    }

    const afterData = afterSnap.data();
    if (!afterData) return;

    // ── Guard: deduplication — skip if already notified ────────────────────
    if (afterData.notifiedAt) {
      console.log(
        `sendHafalanNotification: docId=${event.params.docId} already notified — skipping.`
      );
      return;
    }

    const db = admin.firestore();
    const messaging = admin.messaging();

    // ── Resolve hafalan metadata ────────────────────────────────────────────
    const santriId: string = afterData.santriId ?? "";
    const jenis: string = afterData.jenis ?? "";
    const surahName: string = afterData.surahName ?? "";
    const ayatMulai: number = afterData.ayatMulai ?? 0;
    const ayatSelesai: number = afterData.ayatSelesai ?? 0;
    const juz: number = afterData.juz ?? 0;
    const tanggalSetoran: FirebaseFirestore.Timestamp = afterData.tanggalSetoran;

    if (!santriId || !jenis || !surahName || !tanggalSetoran) {
      console.error(
        `sendHafalanNotification: docId=${event.params.docId} — missing required fields (santriId, jenis, surahName, tanggalSetoran). Aborting.`
      );
      return;
    }

    const tanggalStr = _formatDate(tanggalSetoran.toDate());

    // ── Step 1: Fetch /santri/{santriId} to get authUid ────────────────────
    let authUid: string | undefined;
    try {
      const santriSnap = await db.collection("santri").doc(santriId).get();
      if (!santriSnap.exists) {
        console.warn(
          `sendHafalanNotification: santriId=${santriId} not found in Firestore.`
        );
        // Still write notifiedAt to prevent infinite retries on a missing santri
        await afterSnap.ref.update({
          notifiedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        return;
      }
      authUid = santriSnap.data()?.authUid;
    } catch (e) {
      console.error(
        `sendHafalanNotification: failed to fetch santri (${santriId}):`,
        e
      );
      return;
    }

    if (!authUid) {
      console.warn(
        `sendHafalanNotification: santriId=${santriId} has no authUid — Wali Santri account not yet created.`
      );
      await afterSnap.ref.update({
        notifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return;
    }

    // ── Step 2: Fetch all FCM tokens for authUid (multi-device support) ────
    const fcmTokens = await _resolveUserFcmTokens(db, authUid);
    if (fcmTokens.length === 0) {
      console.info(
        `sendHafalanNotification: users/${authUid} has no active FCM tokens — notification permission likely denied or no active devices.`
      );
      // Mark notified to prevent retries; no notification can be sent without a token
      await afterSnap.ref.update({
        notifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return;
    }

    // ── Step 3: Build and dispatch FCM message ──────────────────────────────
    const notifTitle = `📖 Hafalan ${jenis} — ${surahName}`;
    const notifBody = `${tanggalStr} · Ayat ${ayatMulai}–${ayatSelesai} · Juz ${juz}`;

    const messages: admin.messaging.TokenMessage[] = fcmTokens.map((token) => ({
      token: token,
      notification: {
        title: notifTitle,
        body: notifBody,
      },
      // Structured data payload for the Flutter app to handle taps
      data: {
        type: "hafalan",
        santriId: santriId,
        jenis: jenis,
        surahName: surahName,
        ayatMulai: String(ayatMulai),
        ayatSelesai: String(ayatSelesai),
        juz: String(juz),
        tanggalSetoran: tanggalSetoran.toDate().toISOString(),
      },
      android: {
        priority: "high",
        notification: {
          channelId: "my_halaqoh_hafalan",
          sound: "default",
          // Color must be in #RRGGBB hex format
          color: "#2E7D32",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
            contentAvailable: true,
          },
        },
        headers: {
          "apns-priority": "10",
        },
      },
    }));

    try {
      const batchResponse = await messaging.sendEach(messages);

      const successCount = batchResponse.successCount;
      const failureCount = batchResponse.failureCount;

      console.log(
        `sendHafalanNotification: docId=${event.params.docId} — sent ${successCount}/${messages.length} notifications successfully. Failures: ${failureCount}.`
      );

      // Log failure detail for debugging (e.g., stale/invalid tokens)
      batchResponse.responses.forEach((resp, idx) => {
        if (!resp.success) {
          const errorCode = resp.error?.code ?? "unknown";
          const token = messages[idx].token;
          console.warn(
            `sendHafalanNotification: failed for token ${token?.substring(0, 20)}... — error: ${errorCode}`
          );
          // Stale tokens are refreshed by the app via FirebaseMessaging.onTokenRefresh
        }
      });
    } catch (e) {
      console.error(
        `sendHafalanNotification: FCM sendEach failed for docId=${event.params.docId}:`,
        e
      );
      // Do NOT write notifiedAt here — allow the function to retry on next trigger
      return;
    }

    // ── Mark as notified — prevents re-dispatch on future writes ───────────
    // This write triggers onDocumentWritten again, but the `notifiedAt`
    // guard at the top immediately exits the next invocation.
    try {
      await afterSnap.ref.update({
        notifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (e) {
      console.error(
        `sendHafalanNotification: failed to write notifiedAt for docId=${event.params.docId}:`,
        e
      );
      // Non-fatal: notification was sent; worst case is one duplicate if the
      // guru edits the same record again before notifiedAt is persisted.
    }
  }
);

// ── Formatting helpers ──────────────────────────────────────────────────────

/**
 * Formats a JS Date object as a long Indonesian date string.
 * Example: "Senin, 28 April 2026"
 */
function _formatDate(date: Date): string {
  return date.toLocaleDateString("id-ID", {
    weekday: "long",
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}

/**
 * Resolves all active FCM tokens for a user.
 * Queries /users/{authUid}/devices for active, non-terminated devices,
 * with fallback to /users/{authUid}.fcmToken.
 */
async function _resolveUserFcmTokens(
  db: FirebaseFirestore.Firestore,
  authUid: string
): Promise<string[]> {
  const tokens = new Set<string>();

  try {
    const devicesSnap = await db
      .collection("users")
      .doc(authUid)
      .collection("devices")
      .get();

    for (const doc of devicesSnap.docs) {
      const data = doc.data();
      if (data.isTerminated === true) continue;
      if (data.fcmToken && typeof data.fcmToken === "string" && data.fcmToken.trim().length > 0) {
        tokens.add(data.fcmToken.trim());
      }
    }
  } catch (err) {
    console.warn(`_resolveUserFcmTokens: error reading devices for ${authUid}:`, err);
  }

  if (tokens.size === 0) {
    try {
      const userSnap = await db.collection("users").doc(authUid).get();
      if (userSnap.exists) {
        const rootToken = userSnap.data()?.fcmToken;
        if (rootToken && typeof rootToken === "string" && rootToken.trim().length > 0) {
          tokens.add(rootToken.trim());
        }
      }
    } catch (err) {
      console.warn(`_resolveUserFcmTokens: error reading user doc for ${authUid}:`, err);
    }
  }

  return Array.from(tokens);
}
