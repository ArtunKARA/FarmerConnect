const express = require("express");
const router = express.Router();

const {
  getMedicineType,
  getFarmerMedicineData,
  getAllMedicineRequests,
  getSupplierMedicineData,
  getMedicineDataDetails,
  setFarmerMedicineRequest,
  setFarmerMedicineRequestDelivered,
  setFarmerMedicineRequestCanceled,
  setSupplierMedicineRequestSupply,
} = require("../controllers/medicine-controller.js");

router.get("/type", getMedicineType); // İlaç türlerini getirir
router.get("/farmer/:mail", getFarmerMedicineData);  // Çiftçinin veriseine göre ilaç istekleri getirir  (urlde mail bilgisi olmalı)
router.get("/all", getAllMedicineRequests); // Tüm ilaç isteklerini getirir tadrikçi üstüne alımmamış olanlar
router.get("/supplier/:mail", getSupplierMedicineData); // Tedarikçinin veriseine göre ilaç istekleri getirir  (urlde mail bilgisi olmalı)
router.get("/details/:id", getMedicineDataDetails); // İlaç isteğinin detaylarını getirir (urlde talep id bilgisi olmalı)
router.post("/farmerRequest", setFarmerMedicineRequest); // Çiftçi ilaç talebi oluşturur (bodyde ilaç türü id bilgisi olmalı ve miktar bilgisi olmalı ve çiftçi mail bilgisi olmalı)
router.get("/farmerRequestDelivered/:id", setFarmerMedicineRequestDelivered); // Çiftçi ilaç talebini teslim eder yapar(urlde talep id bilgisi olmalı)
router.get("/farmerRequestCanceled/:id", setFarmerMedicineRequestCanceled);  // Çiftçi ilaç talebini iptal eder (urlde talep id bilgisi olmalı)
router.post("/supplierRequestSupply", setSupplierMedicineRequestSupply); // Tedarikçi ilaç talebini üstüne alır yapar (bodyde talep id bilgisi olmalı ve tedarikçi mail bilgisi olmalı ve teslim tarihi bilgisi olmalı format : "2024-05-05T00:00:00.000Z")


module.exports = router;
