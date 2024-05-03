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