const express = require("express");

const router = express.Router();

const informasiController = require("../controllers/informasi.controller");

router.route("/").get(informasiController.getAll);

router.route("/:id").get(informasiController.getById);

module.exports = router;
