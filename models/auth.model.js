const db = require("../config/db.config"); // Impor koneksi database

// Fungsi untuk mencari user berdasarkan NIM atau NIDN
const login = async (identifier) => {
  const sqlQuery = `
			WITH all_logins AS (
					SELECT m.nim AS identifier, u.password, u.nama, u.role, u.id AS user_id
					FROM mahasiswa m
					JOIN users u ON m.user_id = u.id
					UNION ALL
					SELECT d.nidn AS identifier, u.password, u.nama, u.role, u.id AS user_id
					FROM dosen d
					JOIN users u ON d.user_id = u.id
			)
			SELECT * FROM all_logins WHERE identifier = ?;
	`;

  const [users] = await db.query(sqlQuery, [identifier]);
  return users[0]; // Kembalikan user pertama yang ditemukan atau undefined
};

module.exports = {
  login,
};
