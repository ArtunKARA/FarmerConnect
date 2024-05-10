const express = require("express");
const router = express.Router();

const {
  getFarmerVeterinarianData,
  getAllVeterinarianRequests,
  getVeterinarianVeterinarianData,
  getVeterinarianDataDetails,
  setFarmerVeterinarianRequest,
  setVeterinarianRequestAproved,
  setVeterinarianRequestDiagnosis,
  setVeterinarianRequestCanceled,
} = require("../controllers/veterinarian-controller.js");


router.get("/farmer/:mail", getFarmerVeterinarianData); // Çiftiçinin veriseine göre seriner istekleri getirir  (urlde mail bilgisi olmalı)
router.get("/all", getAllVeterinarianRequests); // Tüm veteriner isteklerini getirir veteriner üstüne alımmamış olanlar
router.get("/veterinarian/:mail", getVeterinarianVeterinarianData); // Veterinerin veriseine göre seriner istekleri getirir  (urlde mail bilgisi olmalı)
router.get("/details/:id", getVeterinarianDataDetails); // Veteriner isteğinin detaylarını getirir (urlde talep id bilgisi olmalı)
router.post("/farmerRequest", setFarmerVeterinarianRequest); // Çiftçinin veteriner isteği oluşturmasını sağlar (bodyde mail ve status bilgisi olmalı)
router.post("/veterinarianRequestAproved", setVeterinarianRequestAproved); // Veteriner isteğini onaylar (bodyde talep id bilgisi ve onaycı mail bilgisi olmalı)
router.post("/veterinarianRequestDiagnosis", setVeterinarianRequestDiagnosis); // Veteriner isteğine tanı koyar (bodyde talep id ve tanı bilgisi olmalı)
router.get("/veterinarianRequestCanceled/:id", setVeterinarianRequestCanceled); // Veteriner isteğini iptal eder (urlde talep id bilgisi olmalı)


module.exports = router;
