import { setGlobalOptions } from "firebase-functions";
import * as admin from "firebase-admin";

import { createUserAccount } from "./createUserAccount";
import { onDeleteUser } from "./deleteUserAccount";
import { seedAdmin } from "./adminSeeder";

// Initialize the Firebase Admin SDK.
admin.initializeApp();

// Set default global region and options
setGlobalOptions({ 
    maxInstances: 10,
    region: "asia-southeast2", // Jakarta region or you can change to us-central1
});

// Export Cloud Functions
export {
    createUserAccount,
    onDeleteUser,
    seedAdmin
};
