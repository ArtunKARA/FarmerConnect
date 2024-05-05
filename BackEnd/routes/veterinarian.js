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
router.get("/farmer/:mail", getFarmerVeterinarianData);
router.post("/veterinarian", getVeterinarianVeterinarianData);
router.get("/details", getVeterinarianDataDetails);
router.post("/farmerRequest", setFarmerVeterinarianRequest);
router.post("/veterinarianRequestAproved", setVeterinarianRequestAproved);
router.post("/veterinarianRequestDiagnosis", setVeterinarianRequestDiagnosis);


module.exports = router;
