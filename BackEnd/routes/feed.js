const express = require("express");
const router = express.Router();

const {
  getFeedType,
  getFarmerFeedData,
  getAllFeedRequests,
  getSupplierFeedData,
  getFeedDataDetails,
  setFarmerFeedRequest,
  setFarmerFeedRequestDelivered,
  setFarmerFeedRequestCanceled,
  setSupplierFeedRequestSupply,
} = require("../controllers/feed-controller.js");

router.get("/type", getFeedType); // Yem türlerini getirir
router.get("/farmer/:mail", getFarmerFeedData); // Çiftçinin veriseine göre yem istekleri getirir  (urlde mail bilgisi olmalı)
router.get("/all", getAllFeedRequests); // Tüm yem isteklerini getirir tadrikçi üstüne alımmamış olanlar
router.get("/supplier/:mail", getSupplierFeedData); // Tedarikçinin gönderdiği tedarikteki yemleri getirir (urlde mail bilgisi olmalı)
router.get("/details/:id", getFeedDataDetails); // Yem isteğinin detaylarını getirir (urlde talep id bilgisi olmalı)
router.post("/farmerRequest", setFarmerFeedRequest); // Çiftçi yem talebi oluşturur (bodyde yem türü id bilgisi olmalı ve miktar bilgisi olmalı ve çiftçi mail bilgisi olmalı)
router.get("/farmerRequestDelivered/:id", setFarmerFeedRequestDelivered); // Çiftçi yem talebini teslim eder yapar(urlde talep id bilgisi olmalı)
router.get("/farmerRequestCanceled/:id", setFarmerFeedRequestCanceled); // Çiftçi yem talebini iptal eder (urlde talep id bilgisi olmalı)
router.post("/supplierRequestSupply", setSupplierFeedRequestSupply); // Tedarikçi yem talebini üstüne alır yapar (bodyde talep id bilgisi olmalı ve tedarikçi mail bilgisi olmalı ve teslim tarihi bilgisi olmalı format : "2024-05-05T00:00:00.000Z)

module.exports = router;
