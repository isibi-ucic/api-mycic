const model = require("../models/informasi.model");

const getAll = async (req, res) => {
  try {
    const informasi = await model.getAll();
    res.status(200).json(informasi);
  } catch (error) {
    res.status(500).json({ error: "Gagal mendapatkan informasi" });
  }
};

const getById = async (req, res) => {
  try {
    const informasi = await model.getById(req.params.id);
    res.status(200).json(informasi);
  } catch (error) {
    res.status(500).json({ error: "Gagal mendapatkan informasi" });
  }
};

module.exports = {
  getAll,
  getById,
};
