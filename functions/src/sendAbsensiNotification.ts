import { onDocumentWritten } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

/**
 * Firestore-triggered Cloud Function that sends FCM push notifications
 * to Wali Santri (parents/guardians) when an attendance session is saved
 * or updated by the Guru.
 *
 * Trigger: Any write (create or update) on /absensi/{docId}
 * Region: asia-southeast2 (Jakarta) — matches all existing project functions
 *
 * Deduplication strategy:
 *   - Checks for the presence of `notifiedAt` field before processing.
 *   - After successfully dispatching all messages, writes `notifiedAt` back
 *     to the document so this function is idempotent across multiple writes
 *     (e.g., offline sync toggling isSynced: false → true).
 *
 * FCM Lookup chain per attendance record:
 *   AbsensiRecordEntry.santriId
 *     → /santri/{santriId}.authUid
 *       → /users/{authUid}.fcmToken
 *         → FCM push notification to Wali Santri device
 */
export const sendAbsensiNotification = onDocumentWritten(
  {
    document: "absensi/{docId}",
    region: "asia-southeast2",
  },
  async (event) => {
    // ── Guard: ignore deletions ─────────────────────────────────────────────
    const afterSnap = event.data?.after;
    if (!afterSnap || !afterSnap.exists) {
      console.log("sendAbsensiNotification: document deleted — skipping.");
      return;
    }

    const afterData = afterSnap.data();
    if (!afterData) return;

    // ── Guard: deduplication — skip if already notified ────────────────────
    if (afterData.notifiedAt) {
      console.log(
        `sendAbsensiNotification: docId=${event.params.docId} already notified — skipping.`
      );
      return;
    }


    const db = admin.firestore();
    const messaging = admin.messaging();

    // ── Resolve attendance metadata ─────────────────────────────────────────
    const halaqohId: string = afterData.halaqohId ?? "";
    const sesi: string = afterData.sesi ?? "";
    const tanggal: FirebaseFirestore.Timestamp = afterData.tanggal;

    if (!halaqohId || !sesi || !tanggal) {
      console.error(
        `sendAbsensiNotification: docId=${event.params.docId} — missing required fields (halaqohId, sesi, tanggal). Aborting.`
      );
      return;
    }

    // ── Resolve halaqoh name (one read, shared across all records) ──────────
    let halaqohNama = "Halaqoh";
    try {
      const halaqohSnap = await db.collection("halaqoh").doc(halaqohId).get();
      if (halaqohSnap.exists) {
        halaqohNama = halaqohSnap.data()?.nama ?? "Halaqoh";
      }
    } catch (e) {
      console.error(
        `sendAbsensiNotification: failed to fetch halaqoh (${halaqohId}):`,
        e
      );
      // Non-fatal — we still send notifications with fallback name
    }

    const sesiLabel = _sesiLabel(sesi);
    const tanggalStr = _formatDate(tanggal.toDate());

    // ── Build FCM messages for each attendance record ───────────────────────
    type AttendanceRecord = {
      santriId: string;
      nis: string;
      nama: string;
      status: string;
    };

    const records: AttendanceRecord[] = Array.isArray(afterData.records)
      ? afterData.records
      : [];

    if (records.length === 0) {
      console.log(
        `sendAbsensiNotification: docId=${event.params.docId} — no records to notify.`
      );
      return;
    }

    // Resolve all santriId → authUid → fcmToken in parallel
    const messages: admin.messaging.TokenMessage[] = [];

    await Promise.all(
      records.map(async (record) => {
        if (!record.santriId || !record.status || record.status === "belum") {
          // Skip unresolved entries — "belum" means not yet marked
          return;
        }

        try {
          // Step 1: Fetch /santri/{santriId} to get authUid
          const santriSnap = await db
            .collection("santri")
            .doc(record.santriId)
            .get();

          if (!santriSnap.exists) {
            console.warn(
              `sendAbsensiNotification: santriId=${record.santriId} not found in Firestore.`
            );
            return;
          }

          const authUid: string | undefined = santriSnap.data()?.authUid;
          if (!authUid) {
            console.warn(
              `sendAbsensiNotification: santriId=${record.santriId} has no authUid — parent account not yet created.`
            );
            return;
          }

          // Step 2: Fetch /users/{authUid} to get fcmToken
          const userSnap = await db.collection("users").doc(authUid).get();
          if (!userSnap.exists) {
            console.warn(
              `sendAbsensiNotification: users/${authUid} not found.`
            );
            return;
          }

          const fcmToken: string | undefined = userSnap.data()?.fcmToken;
          if (!fcmToken) {
            console.info(
              `sendAbsensiNotification: users/${authUid} has no fcmToken — notification permission likely denied by parent.`
            );
            return;
          }

          // Step 3: Build the FCM message
          const statusLabel = _statusLabel(record.status);
          const notifTitle = `📋 Absensi ${sesiLabel} — ${record.nama}`;
          const notifBody = `${tanggalStr} · ${halaqohNama} · Status: ${statusLabel}`;

          messages.push({
            token: fcmToken,
            notification: {
              title: notifTitle,
              body: notifBody,
            },
            // Structured data payload for the Flutter app to handle taps
            data: {
              type: "absensi",
              santriId: record.santriId,
              santriNama: record.nama,
              santriNis: record.nis,
              halaqohId: halaqohId,
              halaqohNama: halaqohNama,
              tanggal: tanggal.toDate().toISOString(),
              sesi: sesi,
              status: record.status,
            },
            android: {
              priority: "high",
              notification: {
                channelId: "my_halaqoh_absensi",
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
          });
        } catch (e) {
          // Non-fatal: log and continue with other records
          console.error(
            `sendAbsensiNotification: error processing santriId=${record.santriId}:`,
            e
          );
        }
      })
    );

    if (messages.length === 0) {
      console.log(
        `sendAbsensiNotification: docId=${event.params.docId} — no valid FCM tokens found. No notifications sent.`
      );
      // Still mark as notified to prevent infinite retries on the same doc
      await afterSnap.ref.update({
        notifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return;
    }

    // ── Dispatch all messages via FCM sendEach (replaces deprecated sendAll) ─
    try {
      const batchResponse = await messaging.sendEach(messages);

      const successCount = batchResponse.successCount;
      const failureCount = batchResponse.failureCount;

      console.log(
        `sendAbsensiNotification: docId=${event.params.docId} — sent ${successCount}/${messages.length} notifications successfully. Failures: ${failureCount}.`
      );

      // Log individual failures for debugging (e.g., stale tokens)
      batchResponse.responses.forEach((resp, idx) => {
        if (!resp.success) {
          const errorCode = resp.error?.code ?? "unknown";
          const token = messages[idx].token;
          console.warn(
            `sendAbsensiNotification: failed for token ${token?.substring(0, 20)}... — error: ${errorCode}`
          );
          // If the token is invalid/not-registered, the app will refresh it on
          // next launch via FirebaseMessaging.onTokenRefresh. No action needed here.
        }
      });
    } catch (e) {
      console.error(
        `sendAbsensiNotification: FCM sendEach failed for docId=${event.params.docId}:`,
        e
      );
      // Do NOT write notifiedAt here — allow the function to retry on next trigger
      return;
    }

    // ── Mark as notified — prevents re-dispatch on future writes ───────────
    // This write will trigger onDocumentWritten again, but the `notifiedAt`
    // guard at the top will immediately exit the next invocation.
    try {
      await afterSnap.ref.update({
        notifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (e) {
      console.error(
        `sendAbsensiNotification: failed to write notifiedAt for docId=${event.params.docId}:`,
        e
      );
      // Non-fatal: notifications were sent; worst case is a duplicate on the next
      // write to this document (e.g., if the guru edits the session again).
    }
  }
);

// ── Formatting helpers ──────────────────────────────────────────────────────

/**
 * Maps an internal `status` string to a human-readable label in Bahasa Indonesia.
 */
function _statusLabel(status: string): string {
  const map: Record<string, string> = {
    hadir: "✅ Hadir",
    sakit: "🤒 Sakit",
    izin: "📝 Izin",
    alfa: "❌ Alfa",
  };
  return map[status] ?? status;
}

/**
 * Maps an internal `sesi` key to a human-readable session name in Bahasa Indonesia.
 */
function _sesiLabel(sesi: string): string {
  const map: Record<string, string> = {
    shubuh: "Pagi (Shubuh)",
    dhuha: "Dhuha",
    siang: "Siang",
    ashar: "Sore (Ashar)",
    maghrib: "Malam (Maghrib)",
  };
  return map[sesi] ?? sesi;
}

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
