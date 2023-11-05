const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.viewPage = functions.https.onRequest(async (req, res) => {
  const id = req.query.id;
  const metadata = await admin.firestore().collection('metadata').doc(id).get().then(doc => doc.data());
  const title = metadata.title;
  const description = metadata.description;
  const imageUrl = metadata.imageUrl;

  const html = `
    <html>
      <head>
        <title>${title}</title>
        <meta property="og:title" content="${title}" />
        <meta property="og:description" content="${description}" />
        <meta property="og:image" content="${imageUrl}" />
      </head>
      <body>
      <style>
  #my-iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border: none;
  }
</style>
        <iframe id="my-iframe" src="https://dialog-manager-9f243.web.app/view?p=${metadata.projectId}&c=${metadata.conversationId}">
      </body>
    </html>
  `;

  res.send(html);
});