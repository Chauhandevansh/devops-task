const express = require('express');
const path = require('path');
const app = express();

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'logoswayatt.png'));
});

/* health check for ALB */
app.get("/health", (req, res) => {
  res.status(200).json({ status: "UP" });
});

app.listen(3000,"0.0.0.0", () => {
  console.log('Server running on http://localhost:3000');
});