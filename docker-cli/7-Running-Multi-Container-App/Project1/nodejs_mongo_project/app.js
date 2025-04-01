const express = require('express');
const { MongoClient } = require('mongodb');

const app = express();
const port = process.env.PORT || 3000;

const url = `mongodb://${process.env.MONGO_INITDB_ROOT_USERNAME}:${process.env.MONGO_INITDB_ROOT_PASSWORD}@mongodb:27017`;
const client = new MongoClient(url);

app.get('/', async (req, res) => {
  try {
    await client.connect();
    const db = client.db('test');
    const collection = db.collection('visits');
    await collection.insertOne({ date: new Date() });
    const count = await collection.countDocuments();
    res.send(`Hello! This page has been visited ${count} times.`);
  } catch (err) {
    console.error(err);
    res.status(500).send('Error connecting to database');
  } finally {
    await client.close();
  }
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});
