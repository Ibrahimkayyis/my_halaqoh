import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

/**
 * Callable Cloud Function allowing an authenticated user (Guru or Santri/Wali Santri)
 * to delete their own account.
 *
 * Operations performed:
 * 1. Checks if the caller is authenticated.
 * 2. Fetches user metadata from `/users/{uid}`.
 * 3. Prevents `super_admin` from being deleted via this endpoint.
 * 4. Unlinks `authUid` and removes FCM tokens from `/guru` or `/santri`.
 * 5. Deletes `/users/{uid}` document.
 * 6. Deletes the Firebase Auth user record via Admin SDK (bypassing `requires-recent-login`).
 */
export const deleteOwnAccount = onCall(async (request) => {
    if (!request.auth || !request.auth.uid) {
        throw new HttpsError("unauthenticated", "Endpoint ini mensyaratkan autentikasi.");
    }

    const uid = request.auth.uid;
    const db = admin.firestore();

    try {
        const userDocRef = db.collection("users").doc(uid);
        const userDoc = await userDocRef.get();

        if (userDoc.exists) {
            const userData = userDoc.data();
            const role = userData?.role;
            const linkedDocId = userData?.linkedDocId;

            // Protect super_admin from accidental self-deletion
            if (role === "super_admin") {
                throw new HttpsError("permission-denied", "Akun Super Admin tidak dapat dihapus melalui fitur ini.");
            }

            const batch = db.batch();

            // Unlink from guru if applicable
            if (role === "guru" && linkedDocId) {
                const guruRef = db.collection("guru").doc(linkedDocId);
                const guruDoc = await guruRef.get();
                if (guruDoc.exists) {
                    batch.update(guruRef, {
                        authUid: null,
                        fcmToken: null,
                        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                    });
                }
            }

            // Unlink from santri if applicable (santri or wali_santri)
            if ((role === "santri" || role === "wali_santri") && linkedDocId) {
                const santriRef = db.collection("santri").doc(linkedDocId);
                const santriDoc = await santriRef.get();
                if (santriDoc.exists) {
                    batch.update(santriRef, {
                        authUid: null,
                        fcmToken: null,
                        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                    });
                }
            }

            // Also check for any matching records in guru/santri where authUid == uid
            const guruMatches = await db.collection("guru").where("authUid", "==", uid).get();
            for (const doc of guruMatches.docs) {
                batch.update(doc.ref, {
                    authUid: null,
                    fcmToken: null,
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            }

            const santriMatches = await db.collection("santri").where("authUid", "==", uid).get();
            for (const doc of santriMatches.docs) {
                batch.update(doc.ref, {
                    authUid: null,
                    fcmToken: null,
                    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
                });
            }

            // Delete /users/{uid} document
            batch.delete(userDocRef);

            await batch.commit();
        }

        // Delete from Firebase Auth
        try {
            await admin.auth().deleteUser(uid);
        } catch (authErr: any) {
            // If already deleted or user-not-found, proceed normally
            if (authErr.code !== "auth/user-not-found") {
                console.error(`Error deleting Auth user ${uid}:`, authErr);
                throw new HttpsError(
                    "internal",
                    "Gagal menghapus akun: gagal menghapus kredensial login.",
                );
            }
        }

        return {
            success: true,
            message: "Akun Anda dan kredensial login berhasil dihapus.",
        };
    } catch (error: any) {
        console.error("Error in deleteOwnAccount:", error);
        if (error instanceof HttpsError) {
            throw error;
        }
        throw new HttpsError("internal", `Gagal menghapus akun: ${error.message}`);
    }
});
