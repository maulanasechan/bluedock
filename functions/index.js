const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.onNotificationCreated = functions.firestore
  .document("Notifications/{notifId}")
  .onCreate(async (snap, ctx) => {
    const notif = snap.data();
    if (!notif) return;

    const {
      title,
      subTitle,
      receipentIds = [],
      route,
      params,
      type,
      isBroadcast = false,
      topic,
    } = notif;

    // Tanpa ?? — aman di parser lama
    const dataPayload = {
      route: route == null ? "" : String(route),
      params: params == null ? "" : String(params),
      type: JSON.stringify(type || {}),
    };

    // -------- Broadcast --------
    if (isBroadcast === true) {
      if (topic && typeof topic === "string" && topic.trim() !== "") {
        await admin.messaging().send({
          topic: topic.trim(),
          notification: {
            title: title || "Notification",
            body: subTitle || "",
          },
          data: dataPayload,
          android: { priority: "high" },
          apns: { headers: { "apns-priority": "10" } },
        });
        return;
      }

      const allTokensSnap = await admin
        .firestore()
        .collectionGroup("tokens")
        .get();
      const allTokens = Array.from(
        new Set(allTokensSnap.docs.map((d) => d.id))
      ).filter(Boolean);
      if (allTokens.length === 0) return;

      const chunk = function (arr, size) {
        const out = [];
        for (let i = 0; i < arr.length; i += size)
          out.push(arr.slice(i, i + size));
        return out;
      };
      const chunks = chunk(allTokens, 500);

      for (const tokens of chunks) {
        const resp = await admin.messaging().sendMulticast({
          tokens,
          notification: {
            title: title || "Notification",
            body: subTitle || "",
          },
          data: dataPayload,
          android: { priority: "high" },
          apns: { headers: { "apns-priority": "10" } },
        });

        const invalids = [];
        resp.responses.forEach((r, idx) => {
          if (!r.success) {
            const code = (r.error && r.error.code) || "";
            if (
              code.indexOf("registration-token-not-registered") !== -1 ||
              code.indexOf("invalid-argument") !== -1
            ) {
              invalids.push(tokens[idx]);
            }
          }
        });

        // cleanup token invalid
        await Promise.all(
          invalids.map(async (t) => {
            const hits = await admin
              .firestore()
              .collectionGroup("tokens")
              .where(admin.firestore.FieldPath.documentId(), "==", t)
              .get();
            await Promise.all(hits.docs.map((doc) => doc.ref.delete()));
          })
        );
      }
      return;
    }

    // -------- Targeted --------
    let tokens = [];
    for (const uid of receipentIds) {
      const qs = await admin
        .firestore()
        .collection("Users")
        .doc(uid)
        .collection("tokens")
        .get();
      tokens = tokens.concat(qs.docs.map((d) => d.id));
    }
    tokens = Array.from(new Set(tokens)).filter(Boolean);
    if (tokens.length === 0) return;

    const resp = await admin.messaging().sendMulticast({
      tokens,
      notification: { title: title || "Notification", body: subTitle || "" },
      data: dataPayload,
      android: { priority: "high" },
      apns: { headers: { "apns-priority": "10" } },
    });

    const invalids = [];
    resp.responses.forEach((r, idx) => {
      if (!r.success) {
        const code = (r.error && r.error.code) || "";
        if (
          code.indexOf("registration-token-not-registered") !== -1 ||
          code.indexOf("invalid-argument") !== -1
        ) {
          invalids.push(tokens[idx]);
        }
      }
    });

    await Promise.all(
      invalids.map(async (t) => {
        const hits = await admin
          .firestore()
          .collectionGroup("tokens")
          .where(admin.firestore.FieldPath.documentId(), "==", t)
          .get();
        await Promise.all(hits.docs.map((doc) => doc.ref.delete()));
      })
    );
  });
