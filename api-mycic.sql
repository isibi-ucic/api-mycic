
CREATE TABLE prodi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_prodi VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Sebaiknya disimpan dalam bentuk hash
    role VARCHAR(50) NOT NULL, -- Contoh: 'mahasiswa', 'dosen'
    profile VARCHAR(255) -- Path ke file foto profil
);


CREATE TABLE mata_kuliah (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_mk VARCHAR(20) NOT NULL UNIQUE,
    nama_mk VARCHAR(100) NOT NULL,
    sks INT NOT NULL
);

CREATE TABLE informasi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE dosen (
    nidn VARCHAR(20) PRIMARY KEY, -- Nomor Induk Dosen Nasional sebagai Primary Key
    user_id INT NOT NULL UNIQUE,
    jabatan VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE mahasiswa (
    nim VARCHAR(20) PRIMARY KEY, -- Nomor Induk Mahasiswa sebagai Primary Key
    user_id INT NOT NULL UNIQUE,
    prodi_id INT NOT NULL,
    semester INT NOT NULL,
    angkatan YEAR NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (prodi_id) REFERENCES prodi(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE jadwal_kelas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_mk INT NOT NULL,
    id_dosen VARCHAR(20) NOT NULL,
    hari VARCHAR(10) NOT NULL,
    jam TIME NOT NULL,
    ruang VARCHAR(50),
    semester_berjalan VARCHAR(50) NOT NULL, -- Contoh: 'Ganjil 2024/2025'
    FOREIGN KEY (id_mk) REFERENCES mata_kuliah(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_dosen) REFERENCES dosen(nidn) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE pertemuan_kelas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_jadwal_kelas INT NOT NULL,
    pertemuan_ke INT NOT NULL,
    tanggal DATE NOT NULL,
    qr_presensi VARCHAR(255), -- Bisa berisi kode unik untuk presensi QR
    UNIQUE(id_jadwal_kelas, pertemuan_ke), -- Setiap kelas hanya punya 1 pertemuan ke-N
    FOREIGN KEY (id_jadwal_kelas) REFERENCES jadwal_kelas(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE presensi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pertemuan_kelas INT NOT NULL,
    mahasiswa_nim VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL, -- Contoh: 'Hadir', 'Izin', 'Sakit', 'Alpa'
    waktu_absen DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(id_pertemuan_kelas, mahasiswa_nim), -- Mahasiswa hanya bisa absen sekali per pertemuan
    FOREIGN KEY (id_pertemuan_kelas) REFERENCES pertemuan_kelas(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (mahasiswa_nim) REFERENCES mahasiswa(nim) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE transkrip (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mahasiswa_nim VARCHAR(20) NOT NULL,
    id_mk INT NOT NULL,
    nilai_angka DECIMAL(5,2), -- Contoh: 85.50
    nilai_huruf VARCHAR(2) NOT NULL, -- Contoh: 'A', 'B+', 'C'
    semester INT NOT NULL,
    UNIQUE(mahasiswa_nim, id_mk), -- Mahasiswa hanya punya 1 nilai final per mata kuliah
    FOREIGN KEY (mahasiswa_nim) REFERENCES mahasiswa(nim) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_mk) REFERENCES mata_kuliah(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE kartu_hasil_studi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mahasiswa_nim VARCHAR(20) NOT NULL,
    semester INT NOT NULL,
    ip_semester DECIMAL(3,2), -- Indeks Prestasi Semester
    ipk DECIMAL(3,2), -- Indeks Prestasi Kumulatif
    UNIQUE(mahasiswa_nim, semester), -- Hanya ada satu record KHS per mahasiswa per semester
    FOREIGN KEY (mahasiswa_nim) REFERENCES mahasiswa(nim) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE jadwal_ujian (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_jadwal_kelas INT NOT NULL,
    jenis_ujian VARCHAR(50) NOT NULL, -- Contoh: 'UTS', 'UAS'
    tanggal DATE NOT NULL,
    jam TIME NOT NULL,
    UNIQUE(id_jadwal_kelas, jenis_ujian), -- Setiap kelas hanya punya 1 UTS dan 1 UAS
    FOREIGN KEY (id_jadwal_kelas) REFERENCES jadwal_kelas(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO `prodi` (`id`, `nama_prodi`) VALUES
(1, 'Teknik Informatika'),
(2, 'Sistem Informasi'),
(3, 'Manajemen'),
(4, 'Akuntansi'),
(5, 'Ilmu Komunikasi'),
(6, 'Desain Komunikasi Visual'),
(7, 'Hukum'),
(8, 'Psikologi'),
(9, 'Teknik Sipil'),
(10, 'Arsitektur');

INSERT INTO `users` (`id`, `nama`, `email`, `password`, `role`, `profile`) VALUES
(1, 'Budi Santoso', 'budi.santoso@email.com', 'hashed_password', 'mahasiswa', 'profiles/budi.jpg'),
(2, 'Ani Yuliani', 'ani.yuliani@email.com', 'hashed_password', 'mahasiswa', 'profiles/ani.jpg'),
(3, 'Candra Wijaya', 'candra.wijaya@email.com', 'hashed_password', 'mahasiswa', 'profiles/candra.jpg'),
(4, 'Dewi Lestari', 'dewi.lestari@email.com', 'hashed_password', 'mahasiswa', 'profiles/dewi.jpg'),
(5, 'Eko Prasetyo', 'eko.prasetyo@email.com', 'hashed_password', 'mahasiswa', 'profiles/eko.jpg'),
(6, 'Fitriana', 'fitriana@email.com', 'hashed_password', 'mahasiswa', 'profiles/fitriana.jpg'),
(7, 'Gilang Ramadhan', 'gilang.ramadhan@email.com', 'hashed_password', 'mahasiswa', 'profiles/gilang.jpg'),
(8, 'Hana Pertiwi', 'hana.pertiwi@email.com', 'hashed_password', 'mahasiswa', 'profiles/hana.jpg'),
(9, 'Indra Kusuma', 'indra.kusuma@email.com', 'hashed_password', 'mahasiswa', 'profiles/indra.jpg'),
(10, 'Jasmine Putri', 'jasmine.putri@email.com', 'hashed_password', 'mahasiswa', 'profiles/jasmine.jpg'),
(11, 'Dr. Ahmad Subagyo', 'ahmad.subagyo@email.com', 'hashed_password', 'dosen', 'profiles/ahmad.jpg'),
(12, 'Prof. Dr. Indah Murni', 'indah.murni@email.com', 'hashed_password', 'dosen', 'profiles/indah.jpg'),
(13, 'Dr. Bambang Hartono', 'bambang.hartono@email.com', 'hashed_password', 'dosen', 'profiles/bambang.jpg'),
(14, 'Citra Kirana, M.Kom.', 'citra.kirana@email.com', 'hashed_password', 'dosen', 'profiles/citra.jpg'),
(15, 'Dodi Firmansyah, M.T.', 'dodi.firmansyah@email.com', 'hashed_password', 'dosen', 'profiles/dodi.jpg'),
(16, 'Dr. Endang Wulan', 'endang.wulan@email.com', 'hashed_password', 'dosen', 'profiles/endang.jpg'),
(17, 'Fajar Nugroho, M.H.', 'fajar.nugroho@email.com', 'hashed_password', 'dosen', 'profiles/fajar.jpg'),
(18, 'Gita Puspita, M.Psi.', 'gita.puspita@email.com', 'hashed_password', 'dosen', 'profiles/gita.jpg'),
(19, 'Herman Susanto, M.Ds.', 'herman.susanto@email.com', 'hashed_password', 'dosen', 'profiles/herman.jpg'),
(20, 'Irwan Setiawan, M.Ak.', 'irwan.setiawan@email.com', 'hashed_password', 'dosen', 'profiles/irwan.jpg');

INSERT INTO `mata_kuliah` (`id`, `kode_mk`, `nama_mk`, `sks`) VALUES
(1, 'IF101', 'Algoritma dan Pemrograman', 3),
(2, 'SI102', 'Basis Data', 3),
(3, 'MN201', 'Manajemen Pemasaran', 3),
(4, 'AK202', 'Akuntansi Biaya', 3),
(5, 'IK301', 'Teori Komunikasi', 2),
(6, 'DKV302', 'Tipografi', 3),
(7, 'HK401', 'Hukum Perdata', 4),
(8, 'PS402', 'Psikologi Klinis', 3),
(9, 'TS501', 'Struktur Beton', 4),
(10, 'AR502', 'Studio Perancangan Arsitektur 1', 4);

INSERT INTO `informasi` (`id`, `title`, `deskripsi`) VALUES
(1, 'Jadwal Her-registrasi Semester Ganjil 2024/2025', 'Diumumkan kepada seluruh mahasiswa untuk melakukan her-registrasi pada tanggal 1-15 Agustus 2024.'),
(2, 'Beasiswa Prestasi Akademik Dibuka', 'Pendaftaran beasiswa prestasi akademik untuk mahasiswa semester 3 ke atas telah dibuka.'),
(3, 'Perayaan Dies Natalis Kampus ke-30', 'Ayo hadiri dan ramaikan perayaan Dies Natalis kampus kita yang ke-30!'),
(4, 'Libur Hari Raya Idul Adha', 'Perkuliahan akan diliburkan pada tanggal 10-11 Dzulhijjah.'),
(5, 'Seminar Nasional Teknologi Digital', 'Ikuti seminar nasional dengan tema "Masa Depan Teknologi Digital" pada hari Sabtu.'),
(6, 'Pembaruan Sistem Informasi Akademik', 'Sistem Informasi Akademik (SIA) akan mengalami maintenance pada hari Minggu.'),
(7. 'Lomba Debat Mahasiswa Tingkat Nasional', 'Bagi yang berminat segera daftarkan tim debat Anda.'),
(8, 'Kuliah Umum Kewirausahaan', 'Kuliah umum bersama praktisi wirausaha sukses. Terbuka untuk semua jurusan.'),
(9, 'Penting: Pengisian KRS Online', 'Jangan lupa untuk mengisi Kartu Rencana Studi (KRS) sesuai jadwal yang ditentukan.'),
(10, 'Informasi Wisuda Periode IV', 'Pendaftaran wisuda periode IV tahun 2024 telah dibuka.');


INSERT INTO `dosen` (`nidn`, `user_id`, `jabatan`) VALUES
('0011223344', 11, 'Lektor Kepala'),
('0022334455', 12, 'Guru Besar'),
('0033445566', 13, 'Lektor'),
('0044556677', 14, 'Asisten Ahli'),
('0055667788', 15, 'Lektor'),
('0066778899', 16, 'Lektor Kepala'),
('0077889900', 17, 'Asisten Ahli'),
('0088990011', 18, 'Lektor'),
('0099001122', 19, 'Asisten Ahli'),('0101010101', 20, 'Lektor');


INSERT INTO `mahasiswa` (`nim`, `user_id`, `prodi_id`, `semester`, `angkatan`) VALUES
('11220001', 1, 1, 5, '2022'),
('11220002', 2, 1, 5, '2022'),
('12220003', 3, 2, 5, '2022'),
('21220004', 4, 3, 3, '2023'),
('22220005', 5, 4, 3, '2023'),
('31220006', 6, 5, 7, '2021'),
('32220007', 7, 6, 7, '2021'),
('41230008', 8, 7, 1, '2024'),
('42230009', 9, 8, 1, '2024'),
('51210010', 10, 9, 7, '2021');

INSERT INTO `jadwal_kelas` (`id`, `id_mk`, `id_dosen`, `hari`, `jam`, `ruang`, `semester_berjalan`) VALUES
(1, 1, '0011223344', 'Senin', '08:00:00', 'Lab A', 'Ganjil 2024/2025'),
(2, 2, '0022334455', 'Selasa', '10:00:00', 'R-101', 'Ganjil 2024/2025'),
(3, 3, '0033445566', 'Rabu', '13:00:00', 'R-202', 'Ganjil 2024/2025'),
(4, 4, '0101010101', 'Kamis', '08:00:00', 'R-203', 'Ganjil 2024/2025'),
(5, 5, '0044556677', 'Jumat', '10:00:00', 'R-301', 'Ganjil 2024/2025'),
(6, 6, '0099001122', 'Senin', '13:00:00', 'Studio DKV', 'Ganjil 2024/2025'),
(7, 7, '0077889900', 'Selasa', '08:00:00', 'Auditorium', 'Ganjil 2024/2025'),
(8, 8, '0088990011', 'Rabu', '10:00:00', 'R-401', 'Ganjil 2024/2025'),
(9, 9, '0055667788', 'Kamis', '13:00:00', 'Lab Sipil', 'Ganjil 2024/2025'),
(10, 10, '0066778899', 'Jumat', '08:00:00', 'Studio Arsi', 'Ganjil 2024/2025');


INSERT INTO `pertemuan_kelas` (`id`, `id_jadwal_kelas`, `pertemuan_ke`, `tanggal`) VALUES
(1, 1, 1, '2024-09-02'),
(2, 1, 2, '2024-09-09'),
(3, 2, 1, '2024-09-03'),
(4, 2, 2, '2024-09-10'),
(5, 3, 1, '2024-09-04'),
(6, 4, 1, '2024-09-05'),
(7, 5, 1, '2024-09-06'),
(8, 6, 1, '2024-09-02'),
(9, 7, 1, '2024-09-03'),
(10, 8, 1, '2024-09-04');


INSERT INTO `jadwal_ujian` (`id`, `id_jadwal_kelas`, `jenis_ujian`, `tanggal`, `jam`) VALUES
(1, 1, 'UTS', '2024-10-21', '08:00:00'),
(2, 1, 'UAS', '2024-12-16', '08:00:00'),
(3, 2, 'UTS', '2024-10-22', '10:00:00'),
(4, 2, 'UAS', '2024-12-17', '10:00:00'),
(5, 3, 'UTS', '2024-10-23', '13:00:00'),
(6, 4, 'UTS', '2024-10-24', '08:00:00'),
(7, 5, 'UTS', '2024-10-25', '10:00:00'),
(8, 6, 'UTS', '2024-10-21', '13:00:00'),
(9, 7, 'UTS', '2024-10-22', '08:00:00'),
(10, 8, 'UTS', '2024-10-23', '10:00:00');


INSERT INTO `presensi` (`id`, `id_pertemuan_kelas`, `mahasiswa_nim`, `status`, `waktu_absen`) VALUES
(1, 1, '11220001', 'Hadir', '2024-09-02 08:05:11'),
(2, 1, '11220002', 'Hadir', '2024-09-02 08:02:30'),
(3, 2, '11220001', 'Hadir', '2024-09-09 07:59:55'),
(4, 2, '11220002', 'Izin', '2024-09-09 07:30:00'),
(5, 3, '12220003', 'Hadir', '2024-09-03 10:01:45'),
(6, 4, '12220003', 'Alpa', NULL),
(7, 5, '21220004', 'Hadir', '2024-09-04 13:05:00'),
(8, 6, '22220005', 'Hadir', '2024-09-05 08:10:12'),
(9, 7, '31220006', 'Sakit', '2024-09-06 08:00:00'),
(10, 8, '32220007', 'Hadir', '2024-09-02 13:03:03');

INSERT INTO `transkrip` (`id`, `mahasiswa_nim`, `id_mk`, `nilai_angka`, `nilai_huruf`, `semester`) VALUES
(1, '11220001', 1, 85.50, 'A', 1),
(2, '11220001', 2, 78.00, 'B+', 2),
(3, '11220002', 1, 90.00, 'A', 1),
(4, '11220002', 2, 82.50, 'A-', 2),
(5, '12220003', 2, 65.00, 'B', 1),
(6, '21220004', 3, 88.00, 'A', 1),
(7, '22220005', 4, 72.00, 'B', 1),
(8, '31220006', 5, 81.00, 'A-', 3),
(9, '32220007', 6, 92.50, 'A', 4),
(10, '51210010', 9, 75.00, 'B+', 5);

INSERT INTO `kartu_hasil_studi` (`id`, `mahasiswa_nim`, `semester`, `ip_semester`, `ipk`) VALUES
(1, '11220001', 1, 3.80, 3.80),
(2, '11220001', 2, 3.75, 3.77),
(3, '11220001', 3, 3.85, 3.80),
(4, '11220001', 4, 3.90, 3.82),
(5, '11220002', 1, 4.00, 4.00),
(6, '11220002', 2, 3.85, 3.92),
(7, '11220002', 3, 3.80, 3.89),
(8, '21220004', 1, 3.50, 3.50),
(9, '21220004', 2, 3.60, 3.55),
(10, '31220006', 6, 3.70, 3.65);