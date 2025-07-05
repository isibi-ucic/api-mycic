const express = require("express");
const router = express.Router();
const authController = require("../controllers/auth.controller.js");

// Rute untuk login
// POST /api/auth/login
router.post("/login", authController.login);

module.exports = router;
