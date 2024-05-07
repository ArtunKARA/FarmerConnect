const { poolPromise } = require("../service/connection.js");

exports.veterinarianRequestsSituation = async (req, res) => {

};

exports.getVeterinarianRequestsStatus = async (req, res) => {

};

exports.getFarmerVeterinarianData = async (req, res) => {
    const mail = req.params.mail;
    q = `SELECT fr.ID, fr.status, fr.requestDate, fr.diagnosis, fr.situation
    FROM veterinarianRequests fr
    JOIN Users u ON fr.userID = u.ID
    WHERE u.mail = '`+mail+`';`;
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
};

exports.getVeterinarianVeterinarianData = async (req, res) => {
  const mail = req.params.mail;
  q = `SELECT fr.ID, fr.status, fr.requestDate, fr.diagnosis, fr.situation, u.farmAdres
  FROM veterinarianRequests fr
  JOIN Users u ON fr.requestResponsible = u.ID
  WHERE u.mail = '`+mail+`';`;
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
};

exports.getVeterinarianDataDetails = async (req, res) => {

};

exports.setFarmerVeterinarianRequest = async (req, res) => {

  const { mail, status } = req.body;
  q = `INSERT INTO veterinarianRequests (userID, situation, status, requestDate)
  SELECT Users.ID, 'a', '`+status+`', GETDATE()
  FROM Users
  WHERE mail = '`+mail+`';`;
  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    return res.json({ message: "Request created successfully" });
  } catch (error) {
    console.error('Request could not be created:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }

};

exports.setVeterinarianRequestAproved = async (req, res) => {

};

exports.setVeterinarianRequestDiagnosis = async (req, res) => {

};

