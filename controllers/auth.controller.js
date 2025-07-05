const authModel = require("../models/auth.model.js");
const bcrypt = require("bcrypt");

const login = async (req, res) => {
  try {
    const { identifier, password } = req.body;

    if (!identifier || !password) {
      return res
        .status(400)
        .json({ message: "NIM/NIDN dan password harus diisi" });
    }

    // Panggil fungsi dari Model untuk mencari user
    const user = await authModel.login(identifier);

    if (!user) {
      return res.status(401).json({ message: "NIM/NIDN atau password salah" });
    }

    // Bandingkan password manual
    if (password != user.password) {
      return res.status(401).json({ message: "NIM/NIDN atau password salah" });
    }

    // Hapus password dari objek user sebelum dikirim ke klien
    delete user.password;

    // Kirim respons sukses (View dalam bentuk JSON)
    res.status(200).json({
      message: "Login berhasil",
      data: user,
      // token: token // Kirim token ke klien
    });
  } catch (error) {
    console.error("Error di controller login:", error);
    res.status(500).json({ message: "Terjadi kesalahan pada server" });
  }
};

module.exports = {
  login,
};
