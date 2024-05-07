const express = require("express");
const router = express.Router();

const {
  veterinarianRequestsSituation,
  getVeterinarianRequestsStatus,
  getFarmerVeterinarianData,
  getVeterinarianVeterinarianData,
  getVeterinarianDataDetails,
  setFarmerVeterinarianRequest,
  setVeterinarianRequestAproved,
  setVeterinarianRequestDiagnosis,
} = require("../controllers/veterinarian-controller.js");

router.get("/situation", veterinarianRequestsSituation);
router.get("/status", getVeterinarianRequestsStatus);
router.get("/farmer/:mail", getFarmerVeterinarianData); // Çiftiçinin veriseine göre seriner istekleri getirir  (urlde mail bilgisi olmalı)
// yazılması lazım router.post("/veterinarian", getVeterinarianVeterinarianData); // Veterinerin veriseine göre seriner istekleri getirir  (urlde mail bilgisi olmalı)
router.get("/details", getVeterinarianDataDetails);
router.post("/farmerRequest", setFarmerVeterinarianRequest); // Çiftçinin veteriner isteği oluşturmasını sağlar (bodyde mail ve status bilgisi olmalı)
router.post("/veterinarianRequestAproved", setVeterinarianRequestAproved);
router.post("/veterinarianRequestDiagnosis", setVeterinarianRequestDiagnosis);


module.exports = router;
