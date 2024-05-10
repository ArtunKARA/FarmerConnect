const { poolPromise } = require("../service/connection.js");

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

exports.getAllVeterinarianRequests = async (req, res) => {
  q = `SELECT fr.ID, fr.status, fr.requestDate, fr.diagnosis, fr.situation, u.farmAdres
  FROM veterinarianRequests fr
  JOIN Users u ON fr.userID = u.ID
  WHERE fr.status = 'a' AND fr.requestResponsible IS NULL;`;
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
  const id = req.params.id;
  q = `SELECT fr.ID, fr.status, fr.requestDate, fr.diagnosis, fr.situation, u.farmAdres
  FROM veterinarianRequests fr
  JOIN Users u ON fr.userID = u.ID
  WHERE fr.ID = '`+id+`';`;
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
  const { id, mail } = req.body;
  q = `UPDATE veterinarianRequests SET requestResponsible = (SELECT ID FROM Users WHERE mail = '`+mail+`'), status = 'a' WHERE ID = '`+id+`';`;
  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    return res.json({ message: "Request approved successfully" });
  } catch (error) {
    console.error('Request could not be approved:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

exports.setVeterinarianRequestDiagnosis = async (req, res) => {
  const { id, diagnosis } = req.body;
  q = `UPDATE veterinarianRequests SET diagnosis = '`+diagnosis+`' , status = 'p' WHERE ID = '`+id+`';`;
  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    return res.json({ message: "Diagnosis set successfully" });
  } catch (error) {
    console.error('Diagnosis could not be set:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

exports.setVeterinarianRequestCanceled = async (req, res) => {
  q = `UPDATE veterinarianRequests SET status = 'p' WHERE ID = '`+req.params.id+`';`;
  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    return res.json({ message: "Request canceled successfully" });
  } catch (error) {
    console.error('Request could not be canceled:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};
