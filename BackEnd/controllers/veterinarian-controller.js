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

};

exports.getVeterinarianDataDetails = async (req, res) => {

};

exports.setFarmerVeterinarianRequest = async (req, res) => {

};

exports.setVeterinarianRequestAproved = async (req, res) => {

};

exports.setVeterinarianRequestDiagnosis = async (req, res) => {

};

