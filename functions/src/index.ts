// IMPORTANT: import setGlobalOptions from the v2 namespace.
// Using "firebase-functions" (v1 namespace) while exporting v2 triggers causes
// the Firebase CLI spec-extractor to timeout during deployment analysis.
import { setGlobalOptions } from "firebase-functions/v2";
import * as admin from "firebase-admin";

import { createUserAccount } from "./createUserAccount";
import { onDeleteUser } from "./deleteUserAccount";
import { seedAdmin } from "./adminSeeder";
import { sendAbsensiNotification } from "./sendAbsensiNotification";
import { sendHafalanNotification } from "./sendHafalanNotification";
import { resetUserPassword } from "./resetUserPassword";
import { bulkCreateUserAccounts } from "./bulkCreateUserAccounts";

// Initialize the Firebase Admin SDK only once.
// The guard prevents "default Firebase app already exists" errors when the
// Firebase CLI loads this module in its introspection / spec-extraction process.
if (!admin.apps.length) {
    admin.initializeApp();
}

// Set default global options for all v2 functions in this codebase.
setGlobalOptions({
    maxInstances: 10,
    region: "asia-southeast2",
});

// Export Cloud Functions
export {
    createUserAccount,
    onDeleteUser,
    seedAdmin,
    sendAbsensiNotification,
    sendHafalanNotification,
    resetUserPassword,
    bulkCreateUserAccounts,
};
