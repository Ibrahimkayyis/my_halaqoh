import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

/**
 * Resets the password of a given user (by uid).
 * Only an Admin can call this function.
 * 
 * Payload requirements:
 * - uid: string (The Firebase Auth UID of the user to reset)
 * - newPassword: string (Optional, defaults to 'generasi554')
 */
export const resetUserPassword = onCall(async (request) => {
    // Basic Authentication Check: Only allow logged-in users
    if (!request.auth || !request.auth.uid) {
        throw new HttpsError('unauthenticated', 'Endpoint ini mensyaratkan autentikasi.');
    }
    
    // Check if the caller is an Admin
    const callerMeta = await admin.firestore().collection('users').doc(request.auth.uid).get();
    if (!callerMeta.exists || callerMeta.data()?.role !== 'admin') {
        throw new HttpsError('permission-denied', 'Hanya administrator yang bisa melakukan reset password.');
    }

    const { uid, newPassword } = request.data;

    if (!uid) {
        throw new HttpsError('invalid-argument', 'Data parameter tidak lengkap (uid dibutuhkan).');
    }

    // Default password to 'generasi554' if not provided
    const finalPassword = newPassword || 'generasi554';

    if (finalPassword.length < 6) {
        throw new HttpsError('invalid-argument', 'Password minimal 6 karakter.');
    }

    try {
        // Update User Password in Firebase Auth
        await admin.auth().updateUser(uid, {
            password: finalPassword,
        });

        return {
            success: true,
            uid: uid,
            message: 'Password berhasil di-reset.'
        };

    } catch (error: any) {
        console.error("Error resetting user password:", error);
        
        if (error.code === 'auth/user-not-found') {
            throw new HttpsError('not-found', 'Akun tidak ditemukan di sistem Autentikasi.');
        }

        throw new HttpsError('internal', `Gagal mereset password: ${error.message}`);
    }
});
