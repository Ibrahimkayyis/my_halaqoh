import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

/**
 * Cloud Function to delete Firebase Auth account and users collection metadata
 * when a Guru or Santri document is deleted in Firestore.
 */

export const onDeleteUser = onDocumentDeleted({
    document: "{collection}/{docId}"
}, async (event) => {
    // We only care about the 'guru' and 'santri' collections
    const collection = event.params.collection;
    if (collection !== 'guru' && collection !== 'santri') {
        return;
    }

    const snap = event.data;
    if (!snap) {
        return; // No data, nothing to do
    }

    const data = snap.data();
    const authUid = data.authUid;

    if (!authUid) {
        console.log(`Document deleted in /${collection}/${event.params.docId} but it had no authUid.`);
        return;
    }

    console.log(`Deleting Auth and Metadata for UID: ${authUid} as their /${collection} record was removed.`);

    try {
        // 1. Delete user from Firebase Auth
        await admin.auth().deleteUser(authUid);
        console.log(`Successfully deleted Firebase Auth user: ${authUid}`);
        
        // 2. Delete metadata document from users collection
        await admin.firestore().collection('users').doc(authUid).delete();
        console.log(`Successfully deleted metadata for UID: ${authUid}`);
        
    } catch (error: any) {
        console.error(`Error attempting to delete user ${authUid}:`, error);
    }
});
