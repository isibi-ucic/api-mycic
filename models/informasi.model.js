const db = require("../../my-app-express/config/db.config");

module.exports = {
  getAll: async () => {
    const [rows] = await db.query("SELECT * FROM informasi");
    return rows;
  },

  getById: async (id) => {
    const [rows] = await db.query("SELECT * FROM informasi WHERE id = ?", [id]);
    return rows[0];
  },
};
