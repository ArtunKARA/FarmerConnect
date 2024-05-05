const express = require("express");
const router = express.Router();

const {
  getMedicineType,
  getFarmerMedicineData,
  getSupplierMedicineData,
  getMedicineDataDetails,
  setFarmerMedicineRequest,
  setFarmerMedicineRequestDelivered,
  setFarmerMedicineRequestCanceled,
  setSupplierMedicineRequestSupply,
} = require("../controllers/medicine-controller.js");

router.get("/type", getMedicineType);
router.get("/farmer/:mail", getFarmerMedicineData);
router.post("/supplier", getSupplierMedicineData);
router.get("/details", getMedicineDataDetails);
router.post("/farmer/request", setFarmerMedicineRequest);
router.post("/farmer/request/delivered", setFarmerMedicineRequestDelivered);
router.post("/farmer/request/canceled", setFarmerMedicineRequestCanceled);
router.post("/supplier/request/supply", setSupplierMedicineRequestSupply);


module.exports = router;
