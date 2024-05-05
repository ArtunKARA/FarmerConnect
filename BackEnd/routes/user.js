const express = require("express");
const router = express.Router();

const {
  userType
} = require("../controllers/user-controller.js");


router.get("/type/:mail", userType);

module.exports = router;
