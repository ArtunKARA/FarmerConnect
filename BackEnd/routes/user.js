const express = require("express");
const router = express.Router();

const {
  userType,
  userDatas,
  updateUserData
} = require("../controllers/user-controller.js");


router.get("/userData/:mail", userDatas);
router.get("/type/:mail", userType);
router.post("/updateUserData/:mail", updateUserData);

module.exports = router;
