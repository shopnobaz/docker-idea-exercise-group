const express = require('express');

// Create a server
const app = express();

// Listen to all urls/routes
app.get('*', (req, res) => {
  res.send(`I'm a Node.js/Express server and I'm ok!`);
});

// Startup the server
app.listen(process.env.PORT);