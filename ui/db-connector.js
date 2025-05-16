const mysql = require('mysql2/promise');

module.exports = mysql.createPool({
  waitForConnections: true,
  connectionLimit: 10,
  host: 'classmysql.engr.oregonstate.edu',
  user: 'cs340_footetr',
  password: '5639',
  database: 'cs340_footetr'
});