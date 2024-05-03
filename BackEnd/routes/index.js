const express = require("express");

const user = require("./user.js");
const feed = require("./feed.js");
const medicine = require("./medicine.js");
const veterinarian = require("./veterinarian.js");

const router = express.Router();

router.get("/", (req, res) => {
  res.send("Working FarmerConnect API");
});

router.use("/api/feed", feed);
router.use("/api/medicine", medicine);
router.use("/api/veterinarian", veterinarian);
router.use("/api/user", user);

module.exports = router;
