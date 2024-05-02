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
router.post("/farmer", getFarmerVeterinarianData);
router.post("/veterinarian", getVeterinarianVeterinarianData);
router.get("/details", getVeterinarianDataDetails);
router.post("/farmer/request", setFarmerVeterinarianRequest);
router.post("/veterinarian/request/aproved", setVeterinarianRequestAproved);
router.post("/veterinarian/request/diagnosis", setVeterinarianRequestDiagnosis);


module.exports = router;
