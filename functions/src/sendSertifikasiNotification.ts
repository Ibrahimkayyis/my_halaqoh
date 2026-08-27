import { onDocumentWritten } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

/**
 * Firestore-triggered Cloud Function that sends FCM push notifications
 * to Guru Pengampu, Santri/Wali Santri, and Examiner (Penguji) when
 * a Tahfidz Certification document's status transitions:
 *   - pending -> scheduled (Exam Scheduled)
 *   - pending -> rejected  (Request Rejected)
 *   - scheduled -> passed  (Student Passed Certification)
 *   - scheduled -> failed  (Student Needs Retake)
 *
 * Trigger: Any write on /sertifikasi_tahfidz/{docId}
 * Region: asia-southeast2 (Jakarta) — matches all existing project functions
 *
 * Deduplication strategy (per-status):
 *   - scheduledNotifiedAt: set when scheduled notification is sent
 *   - rejectedNotifiedAt:  set when rejected notification is sent
 *   - gradedNotifiedAt:    set when passed/failed notification is sent
 */
export const sendSertifikasiNotification = onDocumentWritten(
  {
    document: "sertifikasi_tahfidz/{docId}",
    region: "asia-southeast2",
  },
  async (event) => {
    // ── Guard: ignore deletions ─────────────────────────────────────────────
    const afterSnap = event.data?.after;
    if (!afterSnap || !afterSnap.exists) {
      console.log("sendSertifikasiNotification: document deleted — skipping.");
      return;
    }

    const afterData = afterSnap.data();
    if (!afterData) return;

    const beforeData = event.data?.before?.exists ? event.data.before.data() : null;
    const beforeStatus = beforeData?.status;
    const afterStatus = afterData.status;

    // ── Guard: ignore if status has not changed ─────────────────────────────
    if (beforeStatus === afterStatus) {
      console.log(
        `sendSertifikasiNotification: docId=${event.params.docId} status unchanged (${afterStatus}) — skipping.`
      );
      return;
    }

    // ── Guard: deduplication check per target status ────────────────────────
    if (afterStatus === "scheduled" && afterData.scheduledNotifiedAt) {
      console.log(`sendSertifikasiNotification: docId=${event.params.docId} scheduled already notified — skipping.`);
      return;
    }
    if (afterStatus === "rejected" && afterData.rejectedNotifiedAt) {
      console.log(`sendSertifikasiNotification: docId=${event.params.docId} rejection already notified — skipping.`);
      return;
    }
    if ((afterStatus === "passed" || afterStatus === "failed") && afterData.gradedNotifiedAt) {
      console.log(`sendSertifikasiNotification: docId=${event.params.docId} grading already notified — skipping.`);
      return;
    }

    // Only process actionable statuses
    if (!["scheduled", "rejected", "passed", "failed"].includes(afterStatus)) {
      console.log(
        `sendSertifikasiNotification: docId=${event.params.docId} status '${afterStatus}' does not require push notification — skipping.`
      );
      return;
    }

    const db = admin.firestore();
    const messaging = admin.messaging();

    // ── Resolve sertifikasi metadata ────────────────────────────────────────
    const santriId: string = afterData.santriId ?? "";
    const santriNama: string = afterData.santriNama ?? "Santri";
    const guruId: string = afterData.guruId ?? "";
    const juz: number = afterData.juz ?? 0;
    const pengujiId: string = afterData.pengujiId ?? "";
    const pengujiNama: string = afterData.pengujiNama ?? "";
    const sesiUjian: string = afterData.sesiUjian ?? "";
    const tanggalUjian: FirebaseFirestore.Timestamp | null = afterData.tanggalUjian ?? null;
    const alasanPenolakan: string = afterData.alasanPenolakan ?? "";
    const nilai: number | null = afterData.nilai ?? null;
    const predikat: string = afterData.predikat ?? "";

    const tanggalStr = tanggalUjian ? _formatDate(tanggalUjian.toDate()) : "";

    // ── Fetch FCM tokens for Guru, Santri/Wali, and Penguji ────────────────
    const [guruToken, waliToken, pengujiToken] = await Promise.all([
      guruId ? _resolveFcmTokenByCollectionAndDocId(db, "guru", guruId) : Promise.resolve(null),
      santriId ? _resolveFcmTokenByCollectionAndDocId(db, "santri", santriId) : Promise.resolve(null),
      pengujiId && pengujiId !== guruId
        ? _resolveFcmTokenByCollectionAndDocId(db, "guru", pengujiId)
        : Promise.resolve(null),
    ]);

    // ── Build Messages based on status transition ───────────────────────────
    const messages: admin.messaging.TokenMessage[] = [];
    const baseData = {
      type: "sertifikasi",
      sertifikasiId: event.params.docId,
      santriId: santriId,
      status: afterStatus,
      juz: String(juz),
    };

    if (afterStatus === "scheduled") {
      const title = `📋 Ujian Sertifikasi Juz ${juz} Dijadwalkan`;
      const timeInfo = tanggalStr ? `${tanggalStr}${sesiUjian ? ` (${sesiUjian})` : ""}` : sesiUjian;

      // 1. Message to Guru Pengampu
      if (guruToken) {
        messages.push(
          _createMessage(
            guruToken,
            title,
            `Ujian sertifikasi Juz ${juz} untuk ${santriNama} dijadwalkan pada ${timeInfo}. Penguji: ${pengujiNama || "Ustadz Penguji"}.`,
            baseData
          )
        );
      }

      // 2. Message to Wali Santri
      if (waliToken) {
        messages.push(
          _createMessage(
            waliToken,
            title,
            `Ujian sertifikasi hafalan Juz ${juz} untuk ananda ${santriNama} dijadwalkan pada ${timeInfo}.`,
            baseData
          )
        );
      }

      // 3. Message to Penguji (if different from guru)
      if (pengujiToken) {
        messages.push(
          _createMessage(
            pengujiToken,
            title,
            `Anda ditugaskan sebagai penguji Ujian Sertifikasi Juz ${juz} untuk ${santriNama} pada ${timeInfo}.`,
            baseData
          )
        );
      }
    } else if (afterStatus === "rejected") {
      const title = `❌ Pengajuan Sertifikasi Juz ${juz} Ditolak`;

      // 1. Message to Guru Pengampu
      if (guruToken) {
        messages.push(
          _createMessage(
            guruToken,
            title,
            `Pengajuan sertifikasi Juz ${juz} untuk ${santriNama} ditolak. Alasan: ${alasanPenolakan || "-"}`,
            baseData
          )
        );
      }

      // 2. Message to Wali Santri
      if (waliToken) {
        messages.push(
          _createMessage(
            waliToken,
            title,
            `Pengajuan ujian sertifikasi Juz ${juz} untuk ananda ${santriNama} belum dapat disetujui. Alasan: ${alasanPenolakan || "-"}`,
            baseData
          )
        );
      }
    } else if (afterStatus === "passed") {
      const title = `🎉 Selamat! Lulus Sertifikasi Juz ${juz}`;
      const scoreStr = nilai !== null ? ` (Nilai: ${nilai})` : "";
      const predikatStr = predikat ? ` dengan predikat ${predikat}` : "";

      // 1. Message to Guru Pengampu
      if (guruToken) {
        messages.push(
          _createMessage(
            guruToken,
            title,
            `${santriNama} dinyatakan LULUS Ujian Sertifikasi Juz ${juz}${predikatStr}${scoreStr}.`,
            baseData
          )
        );
      }

      // 2. Message to Wali Santri
      if (waliToken) {
        messages.push(
          _createMessage(
            waliToken,
            title,
            `Alhamdulillah! Ananda ${santriNama} dinyatakan LULUS Sertifikasi Hafalan Juz ${juz}${predikatStr}${scoreStr}.`,
            baseData
          )
        );
      }
    } else if (afterStatus === "failed") {
      const title = `📋 Hasil Sertifikasi Juz ${juz}`;
      const scoreStr = nilai !== null ? ` (Nilai: ${nilai})` : "";

      // 1. Message to Guru Pengampu
      if (guruToken) {
        messages.push(
          _createMessage(
            guruToken,
            title,
            `${santriNama} perlu mengulang Ujian Sertifikasi Juz ${juz}${scoreStr}. Silakan bimbing kembali.`,
            baseData
          )
        );
      }

      // 2. Message to Wali Santri
      if (waliToken) {
        messages.push(
          _createMessage(
            waliToken,
            title,
            `Ananda ${santriNama} perlu mengulang ujian sertifikasi Juz ${juz}${scoreStr}. Tetap semangat menghafal!`,
            baseData
          )
        );
      }
    }

    // ── Dispatch notifications via FCM ──────────────────────────────────────
    if (messages.length > 0) {
      try {
        const batchResponse = await messaging.sendEach(messages);
        console.log(
          `sendSertifikasiNotification: docId=${event.params.docId} [${afterStatus}] — sent ${batchResponse.successCount}/${messages.length} notifications. Failures: ${batchResponse.failureCount}.`
        );
      } catch (e) {
        console.error(
          `sendSertifikasiNotification: FCM sendEach failed for docId=${event.params.docId}:`,
          e
        );
        return;
      }
    } else {
      console.info(
        `sendSertifikasiNotification: docId=${event.params.docId} [${afterStatus}] — no active FCM tokens found for recipients.`
      );
    }

    // ── Mark deduplication timestamp on document ────────────────────────────
    const updatePayload: Record<string, any> = {};
    if (afterStatus === "scheduled") {
      updatePayload.scheduledNotifiedAt = admin.firestore.FieldValue.serverTimestamp();
    } else if (afterStatus === "rejected") {
      updatePayload.rejectedNotifiedAt = admin.firestore.FieldValue.serverTimestamp();
    } else if (afterStatus === "passed" || afterStatus === "failed") {
      updatePayload.gradedNotifiedAt = admin.firestore.FieldValue.serverTimestamp();
    }

    if (Object.keys(updatePayload).length > 0) {
      try {
        await afterSnap.ref.update(updatePayload);
      } catch (e) {
        console.error(
          `sendSertifikasiNotification: failed to write deduplication timestamp for docId=${event.params.docId}:`,
          e
        );
      }
    }
  }
);

// ── Helpers ─────────────────────────────────────────────────────────────────

/**
 * Resolves an FCM token by looking up the document in `collectionName` (guru or santri)
 * to get `authUid`, then looking up `/users/{authUid}` to read `fcmToken`.
 */
async function _resolveFcmTokenByCollectionAndDocId(
  db: FirebaseFirestore.Firestore,
  collectionName: "guru" | "santri",
  docId: string
): Promise<string | null> {
  try {
    const docSnap = await db.collection(collectionName).doc(docId).get();
    if (!docSnap.exists) return null;

    const authUid = docSnap.data()?.authUid;
    if (!authUid) return null;

    const userSnap = await db.collection("users").doc(authUid).get();
    if (!userSnap.exists) return null;

    return userSnap.data()?.fcmToken ?? null;
  } catch (err) {
    console.warn(`_resolveFcmTokenByCollectionAndDocId error for ${collectionName}/${docId}:`, err);
    return null;
  }
}

/**
 * Creates an FCM TokenMessage with Android and APNs configurations.
 */
function _createMessage(
  token: string,
  title: string,
  body: string,
  data: Record<string, string>
): admin.messaging.TokenMessage {
  return {
    token,
    notification: {
      title,
      body,
    },
    data,
    android: {
      priority: "high",
      notification: {
        channelId: "my_halaqoh_sertifikasi",
        sound: "default",
        color: "#10B981", // Emerald green brand color
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
  };
}

/**
 * Formats a Date object to Indonesian locale date string.
 * Example: "Senin, 10 Agustus 2026"
 */
function _formatDate(date: Date): string {
  return date.toLocaleDateString("id-ID", {
    weekday: "long",
    day: "numeric",
    month: "long",
    year: "numeric",
  });
}
