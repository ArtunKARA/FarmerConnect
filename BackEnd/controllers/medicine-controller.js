const { poolPromise } = require("../service/connection.js");

exports.getMedicineType = async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query('SELECT * FROM MedicineTypes');
        if (result.recordset.length === 0) {
          return res.status(404).json({ error: "Medicine type not found." });
        }
        return res.json(result.recordset);
      } catch (error) {
        console.error('Medicine types could not be retrieved:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

exports.getFarmerMedicineData = async (req, res) => {
  const mail = req.params.mail;
  q = `SELECT fr.ID, ft.name, fr.amount, fr.status, fr.requestDate, fr.deliveryDate
  FROM medicineRequests fr
  JOIN Users u ON fr.userID = u.ID
  JOIN MedicineTypes ft ON fr.medicineTypeID = ft.ID
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

exports.getSupplierMedicineData = async (req, res) => {

};

exports.getMedicineDataDetails = async (req, res) => {

};

exports.setFarmerMedicineRequest = async (req, res) => {

};

exports.setFarmerMedicineRequestDelivered = async (req, res) => {
    
};

exports.setFarmerMedicineRequestCanceled = async (req, res) => {

};

exports.setSupplierMedicineRequestSupply = async (req, res) => {

};