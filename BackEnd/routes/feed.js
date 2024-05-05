const express = require("express");
const router = express.Router();

const {
  getFeedType,
  getFarmerFeedData,
  getSupplierFeedData,
  getFeedDataDetails,
  setFarmerFeedRequest,
  setFarmerFeedRequestDelivered,
  setFarmerFeedRequestCanceled,
  setSupplierFeedRequestSupply,
} = require("../controllers/feed-controller.js");

router.get("/type", getFeedType);
router.get("/farmer/:mail", getFarmerFeedData);
router.post("/supplier", getSupplierFeedData);
router.get("/details", getFeedDataDetails);
router.post("/farmer/request", setFarmerFeedRequest);
router.post("/farmer/request/delivered", setFarmerFeedRequestDelivered);
router.post("/farmer/request/canceled", setFarmerFeedRequestCanceled);
router.post("/supplier/request/supply", setSupplierFeedRequestSupply);

module.exports = router;
