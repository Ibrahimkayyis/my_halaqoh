import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

/**
 * Creates a new Firebase Auth account and a corresponding Firestore metadata document.
 * This is designed to be called directly from the Flutter app by an Admin.
 * 
 * Payload requirements:
 * - identifier: string (NIP/NIS)
 * - name: string (Full name of Guru/Santri)
 * - role: string ('guru' | 'santri')
 * - program: string ('T' | 'R') -> Optional for admin, but provided by Guru/Santri
 * - linkedDocId: string (ID of the Firestore document mapping to this user)
 */
export const createUserAccount = onCall(async (request) => {
    // Basic Authentication Check: Only allow logged-in users with admin role to invoke this.
    // Uncomment this for production security. Since we are developing, we'll allow it momentarily, 
    // but typically you enforce it:
    if (!request.auth || !request.auth.uid) {
        throw new HttpsError('unauthenticated', 'Endpoint ini mensyaratkan autentikasi.');
    }
    
    // Check if the caller is an Admin
    const callerMeta = await admin.firestore().collection('users').doc(request.auth.uid).get();
    if (!callerMeta.exists || callerMeta.data()?.role !== 'admin') {
        throw new HttpsError('permission-denied', 'Hanya administrator yang bisa membuat akun.');
    }

    const { identifier, name, role, program, linkedDocId } = request.data;

    if (!identifier || !name || !role || !linkedDocId) {
        throw new HttpsError('invalid-argument', 'Data parameter tidak lengkap (identifier, name, role, linkedDocId dibutuhkan).');
    }

    if (!['guru', 'santri'].includes(role)) {
        throw new HttpsError('invalid-argument', 'Role tidak valid. Harus berupa guru atau santri.');
    }

    const email = `${identifier}@myhalaqoh.app`;
    const password = 'generasi554';

    try {
        // 1. Create User in Firebase Auth
        const userRecord = await admin.auth().createUser({
            email: email,
            password: password,
            displayName: name,
        });

        // 2. Create Metadata Record in Firestore
        await admin.firestore().collection('users').doc(userRecord.uid).set({
            identifier: identifier,
            displayName: name,
            role: role,
            programType: program || null,
            linkedDocId: linkedDocId,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        return {
            success: true,
            uid: userRecord.uid,
            message: 'Akun berhasil dibuat.'
        };

    } catch (error: any) {
        console.error("Error creating user account:", error);
        
        // Handle case where email already exists
        if (error.code === 'auth/email-already-exists') {
            throw new HttpsError('already-exists', 'Akun dengan ID tersebut sudah ada di sistem.');
        }

        throw new HttpsError('internal', `Gagal membuat akun: ${error.message}`);
    }
});
