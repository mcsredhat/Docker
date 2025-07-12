const express = require('express');
const app = express();
const port = process.env.APP_PORT || 8080;

app.get('/', (req, res) => {
  res.json({
    message: 'Hello from Multi-Stage Docker!',
    app: process.env.APP_NAME || 'nodeapp',
    version: process.env.APP_VERSION || '1.0.0',
    environment: process.env.APP_ENV || 'production'
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
});