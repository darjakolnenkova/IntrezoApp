/* eslint-disable */
const functions = require("firebase-functions");
const admin     = require("firebase-admin");
admin.initializeApp();

exports.onNewJob = functions.firestore
  .document("jobs/{jobId}")
  .onCreate(async (snap, ctx) => {
    const job = snap.data();
    const payload = {
      notification: {
        title: "Новая вакансия",
        body: job.title || "Появилась новая вакансия, посмотрите сейчас!",
      },
      topic: "jobs",
    };
    await admin.messaging().send(payload);
  });

