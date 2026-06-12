import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

/**
 * Creates a new Firebase Auth account, a corresponding Firestore /users metadata
 * document, AND (for role=santri) the /santri/{linkedDocId} document.
 *
 * All writes are performed using the Admin SDK, which bypasses Firestore Security
 * Rules — making the operation fully atomic on the server side.
 *
 * Payload requirements:
 * - identifier: string (NIP/NIS)
 * - name: string (Full name of Guru/Santri)
 * - role: string ('guru' | 'santri')
 * - program: string ('T' | 'R') — required for santri
 * - linkedDocId: string (ID of the Firestore document mapping to this user)
 *
 * Additional fields for role=santri:
 * - kelas: string (e.g. '7', '8', ..., '12')
 * - profilePicture: string | null (Firebase Storage URL)
 * - createdAt: number (milliseconds since epoch — client-supplied for consistency)
 */
export const createUserAccount = onCall(async (request) => {
    if (!request.auth || !request.auth.uid) {
        throw new HttpsError('unauthenticated', 'Endpoint ini mensyaratkan autentikasi.');
    }

    // Check if the caller is an Admin
    const callerMeta = await admin.firestore().collection('users').doc(request.auth.uid).get();
    if (!callerMeta.exists || callerMeta.data()?.role !== 'admin') {
        throw new HttpsError('permission-denied', 'Hanya administrator yang bisa membuat akun.');
    }

    const { identifier, name, role, program, linkedDocId, kelas, profilePicture, createdAt } = request.data;

    if (!identifier || !name || !role || !linkedDocId) {
        throw new HttpsError('invalid-argument', 'Data parameter tidak lengkap (identifier, name, role, linkedDocId dibutuhkan).');
    }

    if (!['guru', 'santri'].includes(role)) {
        throw new HttpsError('invalid-argument', 'Role tidak valid. Harus berupa guru atau santri.');
    }

    const email = `${identifier}@myhalaqoh.app`;
    const password = 'generasi554';
    const now = admin.firestore.FieldValue.serverTimestamp();

    try {
        // 1. Create or Fetch User in Firebase Auth
        let userRecord;

        try {
            userRecord = await admin.auth().createUser({
                email: email,
                password: password,
                displayName: name,
            });
        } catch (authErr: any) {
            if (authErr.code === 'auth/email-already-exists') {
                userRecord = await admin.auth().getUserByEmail(email);
            } else {
                throw authErr;
            }
        }

        const db = admin.firestore();
        const batch = db.batch();

        // 2. Write /users metadata document
        batch.set(db.collection('users').doc(userRecord.uid), {
            identifier: identifier,
            displayName: name,
            role: role,
            programType: program || null,
            linkedDocId: linkedDocId,
            createdAt: now,
        });

        // 3. For role=santri, also write the /santri/{linkedDocId} document
        //    This is done server-side to bypass Firestore Security Rules reliably.
        if (role === 'santri') {
            if (!kelas || !program) {
                throw new HttpsError('invalid-argument', 'Field kelas dan program wajib diisi untuk santri.');
            }
            const santriCreatedAt = createdAt
                ? admin.firestore.Timestamp.fromMillis(createdAt)
                : now;

            batch.set(db.collection('santri').doc(linkedDocId), {
                nis: identifier,
                nama: name,
                kelas: kelas,
                program: program,
                profilePicture: profilePicture || null,
                halaqohId: null,
                waliSantri: null,
                authUid: userRecord.uid,
                isAlumni: false,
                createdAt: santriCreatedAt,
                updatedAt: santriCreatedAt,
            });
        }

        // 4. Commit both writes atomically
        await batch.commit();

        return {
            success: true,
            uid: userRecord.uid,
            message: 'Akun berhasil dibuat.',
        };

    } catch (error: any) {
        console.error("Error creating user account:", error);

        // Re-throw HttpsError as-is (our own validation errors)
        if (error instanceof HttpsError) throw error;

        // Handle case where email already exists
        if (error.code === 'auth/email-already-exists') {
            throw new HttpsError('already-exists', 'Akun dengan ID tersebut sudah ada di sistem.');
        }

        throw new HttpsError('internal', `Gagal membuat akun: ${error.message}`);
    }
});
