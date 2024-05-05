
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