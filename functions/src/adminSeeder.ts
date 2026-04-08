import { onRequest } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

/**
 * Temporary HTTP Endpoint to seed the initial Admin account.
 * IMPORTANT: Delete or disable this function after the first run.
 * 
 * Usage: Visit this URL in your browser: 
 * https://<region>-<project>.cloudfunctions.net/seedAdmin
 * (You can pass ?password=YOUR_SECURE_PASSWORD in the query string, defaults to 'admin123' if omitted)
 */
export const seedAdmin = onRequest(async (req, res) => {
    const adminIdentifier = 'admin'; // Static identifier
    const email = `${adminIdentifier}@myhalaqoh.app`;
    
    // Use password from query param or generate a default one
    const password = (req.query.password as string) || 'admin123';
    
    try {
        // 1. Try to fetch if it already exists
        try {
            const existingUser = await admin.auth().getUserByEmail(email);
            // If exists, just return info
            res.status(200).send(`Admin user already exists with UID: ${existingUser.uid}. Please delete it first if you want to recreate.`);
            return;
        } catch(e) {
            // It's fine if it doesn't exist.
        }

        // 2. Create the Auth User
        const userRecord = await admin.auth().createUser({
            email: email,
            password: password,
            displayName: "Administrator",
        });

        // 3. Create the role mapping in Firestore
        await admin.firestore().collection('users').doc(userRecord.uid).set({
            identifier: adminIdentifier,
            displayName: "Administrator",
            role: "admin",
            linkedDocId: "SYSTEM",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        res.status(200).json({
            message: "Successfully seeded admin account!",
            uid: userRecord.uid,
            loginWith: adminIdentifier,
            password: password,
            nextStep: "REMOVE THIS FUNCTION FOR SECURITY PURPOSES."
        });

    } catch (error: any) {
        console.error("Error seeding admin:", error);
        res.status(500).send(`Error seeding admin: ${error.message}`);
    }
});
