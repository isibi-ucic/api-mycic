const express = require("express");
const authRoutes = require("./routes/auth.routes.js"); // Impor rute autentikasi
const informasiRoutes = require("./routes/informasi.routes.js");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware untuk membaca body JSON dari request
app.use(express.json());

// Gunakan rute yang sudah didefinisikan
// Semua rute di dalam authRoutes akan memiliki awalan /api/auth
app.use("/auth", authRoutes);
app.use("/informasi", informasiRoutes);

// Rute dasar
app.get("/", (req, res) => {
  res.send("API Sistem Informasi Akademik berjalan!");
});

app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
