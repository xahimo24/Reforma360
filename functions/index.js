const functions = require("firebase-functions");
const mysql = require("mysql2");

const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "reforma360",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

exports.getUsers = functions.https.onRequest((req, res) => {
  pool.query("SELECT * FROM usuarios", (error, results) => {
    if (error) {
      res.status(500).send(error);
    } else {
      res.json(results);
    }
  });
});
