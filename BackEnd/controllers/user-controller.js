
const { poolPromise } = require("../service/connection.js");

exports.userType = async (req, res) => {

  const mail = req.params.mail;
  q = "SELECT userType FROM Users WHERE mail = '" + mail + "';";
  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.recordset.length === 0) {
      return res.status(404).json({ error: "User type not found." });
    }
    return res.json(result.recordset);
  } catch (error) {
    console.error('User types could not be retrieved:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

exports.userDatas = async (req, res) => {

  const mail = req.params.mail;
  q = "SELECT * FROM Users WHERE mail = '" + mail + "';";
  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.recordset.length === 0) {
      return res.status(404).json({ error: "User data not found." });
    }
    return res.json(result.recordset);
  } catch (error) {
    console.error('User data could not be retrieved:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}

exports.updateUserData = async (req, res) => {
  
    const qmail = req.params.mail;
    const mail = req.body.mail;
    const name = req.body.name;
    const surname = req.body.surname;
    const password = req.body.password;
    const userType = req.body.userType;
    const q = "UPDATE Users SET name = '" + name + "', surname = '" + surname + ", mail = " + mail + "' WHERE mail = '" + qmail + "';";
  
    try {
      const pool = await poolPromise;
      const result = await pool.request().query(q);
      if (result.rowsAffected[0] === 0) {
        return res.status(404).json({ error: "User data not found." });
      }
      return res.json({ message: "User data updated." });
    } catch (error) {
      console.error('User data could not be updated:', error);
      return res.status(500).json({ error: 'Internal server error' });
    }
  }

