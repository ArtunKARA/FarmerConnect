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

exports.getAllMedicineRequests = async (req, res) => {
  q = `SELECT fr.ID, ft.name, fr.amount, fr.status, fr.requestDate, fr.deliveryDate
  FROM medicineRequests fr
  JOIN MedicineTypes ft ON fr.medicineTypeID = ft.ID
   WHERE fr.status = 'r';`;
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

exports.getSupplierMedicineData = async (req, res) => {
  const mail = req.params.mail;
  q = `SELECT fr.ID, ft.name, fr.amount, fr.status, fr.requestDate, fr.deliveryDate
  FROM medicineRequests fr
  JOIN Users u ON fr.requestResponsible = u.ID
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

exports.getMedicineDataDetails = async (req, res) => {
  const id = req.params.id;
  q = `SELECT fr.ID, ft.name, fr.amount, fr.status, fr.requestDate, fr.deliveryDate
  FROM medicineRequests fr
  JOIN MedicineTypes ft ON fr.medicineTypeID = ft.ID
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

exports.setFarmerMedicineRequest = async (req, res) => {
    const { medicineTypeID, amount, mail } = req.body;
    q = `INSERT INTO medicineRequests (medicineTypeID, amount, userID, status, requestDate, deliveryDate) VALUES ('`+medicineTypeID+`', '`+amount+`', (SELECT ID FROM Users WHERE mail = '`+mail+`'), 'r', GETDATE(), NULL);`;
    try {
        const pool = await poolPromise;
        const result = await pool.request().query(q);
        return res.json({ message: "Medicine request created." });
    } catch (error) {
        console.error('Medicine request could not be created:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

exports.setFarmerMedicineRequestDelivered = async (req, res) => {
    const id = req.params.id;
    q = `UPDATE medicineRequests SET status = 'd' WHERE ID = '`+id+`';`;
    try {
        const pool = await poolPromise;
        const result = await pool.request().query(q);
        return res.json({ message: "Medicine request delivered." });
    } catch (error) {
        console.error('Medicine request could not be delivered:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

exports.setFarmerMedicineRequestCanceled = async (req, res) => {
    const id = req.params.id;
    q = `UPDATE medicineRequests SET status = 'c' WHERE ID = '`+id+`';`;
    try {
        const pool = await poolPromise;
        const result = await pool.request().query(q);
        return res.json({ message: "Medicine request canceled." });
    } catch (error) {
        console.error('Medicine request could not be canceled:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

exports.setSupplierMedicineRequestSupply = async (req, res) => {
    const { id, mail, deliveryDate } = req.body;
    q = `UPDATE medicineRequests SET status = 's', requestResponsible = (SELECT ID FROM Users WHERE mail = '`+mail+`'), deliveryDate = '`+deliveryDate+`' WHERE ID = '`+id+`';`;
    try {
        const pool = await poolPromise;
        const result = await pool.request().query(q);
        return res.json({ message: "Medicine request supplied." });
    } catch (error) {
        console.error('Medicine request could not be supplied:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};