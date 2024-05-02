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

};

exports.getSupplierFeedData = async (req, res) => { 

};

exports.getFeedDataDetails = async (req, res) => {

};

exports.setFarmerFeedRequest = async (req, res) => {

};

exports.setFarmerFeedRequestDelivered = async (req, res) => {

};

exports.setFarmerFeedRequestCanceled = async (req, res) => {

};

exports.setSupplierFeedRequestSupply = async (req, res) => {

};