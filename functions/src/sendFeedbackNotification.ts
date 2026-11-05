import { onDocumentWritten } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

/**
 * Firestore-triggered Cloud Function that sends FCM push notifications
 * to the submitting user (Guru or Wali Santri) when their feedback/bug report
 * status is updated to 'resolved' by Admin in Firebase Console.
 *
 * Trigger: Any write on /feedback/{docId}
 * Region: asia-southeast2 (Jakarta) — matches all existing project functions
 *
 * Deduplication strategy:
 *   - Checks for `resolvedNotifiedAt` field before processing.
 *   - After sending notifications, writes `resolvedNotifiedAt` back
 *     to prevent repeated push notifications on subsequent admin edits.
 */
export const sendFeedbackNotification = onDocumentWritten(
  {
    document: "feedback/{docId}",
    region: "asia-southeast2",
  },
  async (event) => {
    // ── Guard: ignore deletions ─────────────────────────────────────────────
    const afterSnap = event.data?.after;
    if (!afterSnap || !afterSnap.exists) {
      console.log("sendFeedbackNotification: document deleted — skipping.");
      return;
    }

    const afterData = afterSnap.data();
    if (!afterData) return;

    const afterStatus = String(afterData.status ?? "").toLowerCase();

    // ── Guard: only process resolved feedback ───────────────────────────────
    if (afterStatus !== "resolved") {
      return;
    }

    // ── Guard: deduplication check ──────────────────────────────────────────
    if (afterData.resolvedNotifiedAt) {
      console.log(
        `sendFeedbackNotification: docId=${event.params.docId} already notified at ${afterData.resolvedNotifiedAt} — skipping.`
      );
      return;
    }

    const userId: string = afterData.userId ?? "";
    if (!userId) {
      console.warn(
        `sendFeedbackNotification: docId=${event.params.docId} has no userId — skipping.`
      );
      return;
    }

    const db = admin.firestore();
    const messaging = admin.messaging();

    // ── Step 1: Resolve user's FCM tokens ───────────────────────────────────
    const fcmTokens = await _resolveUserFcmTokens(db, userId);
    if (fcmTokens.length === 0) {
      console.info(
        `sendFeedbackNotification: users/${userId} has no active FCM tokens — marking notified.`
      );
      await afterSnap.ref.update({
        resolvedNotifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return;
    }

    // ── Step 2: Build push notification payload ─────────────────────────────
    const feedbackTitle = String(afterData.title ?? "Masukan");
    const adminResponse =
      typeof afterData.adminResponse === "string" && afterData.adminResponse.trim().length > 0
        ? afterData.adminResponse.trim()
        : "Masukan Anda telah ditindaklanjuti oleh pengurus halaqoh.";

    const notifTitle = `💬 Masukan Ditindaklanjuti: ${feedbackTitle}`;
    const notifBody = adminResponse;

    const messages: admin.messaging.TokenMessage[] = fcmTokens.map((token) => ({
      token,
      notification: {
        title: notifTitle,
        body: notifBody,
      },
      data: {
        type: "feedback",
        feedbackId: event.params.docId,
        title: feedbackTitle,
        category: String(afterData.category ?? "saran"),
        status: "resolved",
      },
      android: {
        priority: "high",
        notification: {
          channelId: "my_halaqoh_feedback",
          sound: "default",
          color: "#115D69", // Primary Teal brand color
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

    // ── Step 3: Dispatch FCM messages ───────────────────────────────────────
    try {
      const response = await messaging.sendEach(messages);
      console.log(
        `sendFeedbackNotification: sent ${response.successCount}/${messages.length} messages for feedback ${event.params.docId}`
      );

      // Clean up invalid or stale tokens if detected
      if (response.failureCount > 0) {
        response.responses.forEach((resp, idx) => {
          if (!resp.success) {
            const errCode = resp.error?.code;
            if (
              errCode === "messaging/registration-token-not-registered" ||
              errCode === "messaging/invalid-registration-token"
            ) {
              console.warn(
                `sendFeedbackNotification: stale token detected: ${fcmTokens[idx]}`
              );
            }
          }
        });
      }
    } catch (sendErr) {
      console.error(
        `sendFeedbackNotification: failed to send FCM for docId=${event.params.docId}:`,
        sendErr
      );
    }

    // ── Step 4: Write resolvedNotifiedAt timestamp for deduplication ────────
    try {
      await afterSnap.ref.update({
        resolvedNotifiedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } catch (updateErr) {
      console.error(
        `sendFeedbackNotification: failed to write resolvedNotifiedAt on docId=${event.params.docId}:`,
        updateErr
      );
    }
  }
);

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
