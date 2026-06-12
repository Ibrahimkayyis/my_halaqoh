import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

/**
 * Creates multiple Firebase Auth accounts and their corresponding Firestore metadata documents in bulk.
 * This function bypasses the client-side App Check rate limits that occur when calling `createUserAccount` in a tight loop.
 * 
 * Payload requirements:
 * - users: Array of objects containing:
 *   - identifier: string (NIP/NIS)
 *   - name: string (Full name)
 *   - role: string ('guru' | 'santri')
 *   - program: string ('T' | 'R')
 *   - kelas?: string (only for santri)
 *   - phone?: string (only for guru)
 */
export const bulkCreateUserAccounts = onCall(async (request) => {
    if (!request.auth || !request.auth.uid) {
        throw new HttpsError('unauthenticated', 'Endpoint ini mensyaratkan autentikasi.');
    }
    
    // Check if the caller is an Admin
    const callerMeta = await admin.firestore().collection('users').doc(request.auth.uid).get();
    if (!callerMeta.exists || callerMeta.data()?.role !== 'admin') {
        throw new HttpsError('permission-denied', 'Hanya administrator yang bisa membuat akun bulk.');
    }

    const { users } = request.data;

    if (!users || !Array.isArray(users)) {
        throw new HttpsError('invalid-argument', 'Data users tidak valid (harus berupa array).');
    }

    const db = admin.firestore();
    const now = admin.firestore.FieldValue.serverTimestamp();

    // Helper function to process a single user creation task
    const processSingleUser = async (user: any) => {
        const { identifier, name, role, program, kelas, phone } = user;
        
        if (!identifier || !name || !role) {
            return { success: false, reason: "missing_fields" };
        }

        const email = `${identifier}@myhalaqoh.app`;
        const password = "generasi554";

        try {
            // 1. Create or Fetch User in Firebase Auth
            let userRecord;
            let existingDocId = null;
            
            try {
                userRecord = await admin.auth().createUser({
                    email: email,
                    password: password,
                    displayName: name,
                });
            } catch (authErr: any) {
                if (authErr.code === "auth/email-already-exists") {
                    userRecord = await admin.auth().getUserByEmail(email);
                    
                    // Check if they are fully registered in Firestore
                    const existingUserDoc = await db.collection("users").doc(userRecord.uid).get();
                    if (existingUserDoc.exists && existingUserDoc.data()?.linkedDocId) {
                        existingDocId = existingUserDoc.data()?.linkedDocId;
                        // If they already exist fully, we skip to avoid duplicating/overwriting
                        console.log(`User ${identifier} already fully exists, skipping.`);
                        return { success: false, reason: "already_exists" };
                    }
                } else {
                    throw authErr;
                }
            }

            // 2. Prepare Firestore Batch
            const batch = db.batch();
            const docId = existingDocId || db.collection(role === "santri" ? "santri" : "guru").doc().id;
            const docRef = db.collection(role === "santri" ? "santri" : "guru").doc(docId);

            // Write /users metadata
            batch.set(db.collection("users").doc(userRecord.uid), {
                identifier: identifier,
                displayName: name,
                role: role,
                programType: program || null,
                linkedDocId: docRef.id,
                createdAt: now,
            });

            // Write specific collection doc
            if (role === "santri") {
                batch.set(docRef, {
                    nis: identifier,
                    nama: name,
                    kelas: kelas || "7",
                    program: program || "R",
                    profilePicture: null,
                    halaqohId: null,
                    waliSantri: null,
                    authUid: userRecord.uid,
                    isAlumni: false,
                    createdAt: now,
                    updatedAt: now,
                });
            } else if (role === "guru") {
                batch.set(docRef, {
                    nip: identifier,
                    nama: name,
                    phone: phone || null,
                    program: program || "R",
                    profilePicture: null,
                    authUid: userRecord.uid,
                    createdAt: now,
                    updatedAt: now,
                });
            }

            await batch.commit();
            return { success: true };
        } catch (error: any) {
            console.error(`Error creating user ${identifier}:`, error);
            return { success: false, reason: "error", message: error.message || String(error) };
        }
    };

    // Process all users concurrently
    const results = await Promise.all(users.map((user) => processSingleUser(user)));

    let successCount = 0;
    let failCount = 0;

    for (const res of results) {
        if (res.success) {
            successCount++;
        } else {
            failCount++;
        }
    }

    return {
        success: true,
        successCount,
        failCount
    };
});
