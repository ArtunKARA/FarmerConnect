const { poolPromise } = require("../service/connection.js");

exports.getFeedType = async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request().query('SELECT * FROM FeedTypes');
        if (result.recordset.length === 0) {
          return res.status(404).json({ error: "Feed type not found." });
        }
        return res.json(result.recordset);
      } catch (error) {
        console.error('Feed types could not be retrieved:', error);
        return res.status(500).json({ error: 'Internal server error' });
    }
};

exports.getFarmerFeedData = async (req, res) => {
  const mail = req.params.mail;
  q = `SELECT fr.ID AS TalepID, ft.name AS YemAdı, fr.amount AS Miktar, fr.status AS Durum, fr.requestDate AS IstekTarihi, fr.deliveryDate AS TeslimTarihi
  FROM feedRequests fr
  JOIN Users u ON fr.userID = u.ID
  JOIN FeedTypes ft ON fr.feedTypeID = ft.ID
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

exports.getAllFeedRequests = async (req, res) => {
  q = `SELECT fr.ID AS TalepID, ft.name AS YemAdı, fr.amount AS Miktar, fr.status AS Durum, fr.requestDate AS IstekTarihi, fr.deliveryDate AS TeslimTarihi
  FROM feedRequests fr
  JOIN FeedTypes ft ON fr.feedTypeID = ft.ID
  WHERE fr.status = 'r';`;

  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.recordset.length === 0) {
      return res.status(404).json({ error: "Feed requests not found." });
    }
    return res.json(result.recordset);
  } catch (error) {
    console.error('Feed requests could not be retrieved:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};


exports.getSupplierFeedData = async (req, res) => { 
  const mail = req.params.mail;
  q = `SELECT fr.ID AS TalepID, ft.name AS YemAdı, fr.amount AS Miktar, fr.status AS Durum, fr.requestDate AS IstekTarihi, fr.deliveryDate AS TeslimTarihi
  FROM feedRequests fr
  JOIN Users u ON fr.requestResponsible = u.ID
  JOIN FeedTypes ft ON fr.feedTypeID = ft.ID
  WHERE u.mail = '`+mail+`' AND fr.status ='s';`;

  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.recordset.length === 0) {
      return res.status(404).json({ error: "User data not found." + mail.toString()});
    }
    return res.json(result.recordset);
  } catch (error) {
    console.error('User data could not be retrieved:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

exports.getFeedDataDetails = async (req, res) => {
  const id = req.params.id;
  q = `SELECT fr.ID AS TalepID, ft.name AS YemAdı, fr.amount AS Miktar, fr.status AS Durum, fr.requestDate AS IstekTarihi, fr.deliveryDate AS TeslimTarihi
  FROM feedRequests fr
  JOIN FeedTypes ft ON fr.feedTypeID = ft.ID
  WHERE fr.ID = '`+id+`';`;

  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.recordset.length === 0) {
      return res.status(404).json({ error: "Feed request not found." });
    }
    return res.json(result.recordset);
  } catch (error) {
    console.error('Feed request could not be retrieved:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

exports.setFarmerFeedRequest = async (req, res) => {
  const { mail, feedTypeID, amount, requestDate } = req.body;
  q = `INSERT INTO feedRequests (userID, feedTypeID, amount, status, requestDate)
  VALUES ((SELECT ID FROM Users WHERE mail = '`+mail+`'), `+feedTypeID+`, `+amount+`, 'r', GETDATE());`;

  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: "Feed request could not be added." });
    }
    return res.json({ message: "Feed request added successfully." });
  } catch (error) {
    console.error('Feed request could not be added:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

exports.setFarmerFeedRequestDelivered = async (req, res) => {
  const id  = req.params.id;
  q = `UPDATE feedRequests SET status = 'd' WHERE ID = `+id+`;`;

  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: "Feed request could not be updated." });
    }
    return res.json({ message: "Feed request updated successfully." });
  } catch (error) {
    console.error('Feed request could not be updated:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

exports.setFarmerFeedRequestCanceled = async (req, res) => {
  const  id  = req.params.id;
  q = `UPDATE feedRequests SET status = 'c' WHERE ID = `+id+`;`;

  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: "Feed request could not be updated." });
    }
    return res.json({ message: "Feed request updated successfully." });
  } catch (error) {
    console.error('Feed request could not be updated:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};

exports.setSupplierFeedRequestSupply = async (req, res) => {
  const { id, deliveryDate ,mail} = req.body;
  q = `UPDATE feedRequests SET deliveryDate = '`+deliveryDate+`', status = 's', requestResponsible = (SELECT ID FROM Users WHERE mail = '`+mail+`') WHERE ID = `+id+`;`;

  try {
    const pool = await poolPromise;
    const result = await pool.request().query(q);
    if (result.rowsAffected[0] === 0) {
      return res.status(404).json({ error: "Feed request could not be updated." });
    }
    return res.json({ message: "Feed request updated successfully." });
  } catch (error) {
    console.error('Feed request could not be updated:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
};