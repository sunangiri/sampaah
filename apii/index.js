const express = require("express");
const multer = require("multer");
const path = require("path");
const cors = require("cors");
const mysql = require("mysql2/promise");

const app = express();
const port = 3000;

// Konfigurasi koneksi ke database MySQL
const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "trashtrack",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Multer setup for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  },
});

// Register route
const upload = multer({ storage: storage });

app.use(express.json());
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

app.post("/api/register", upload.single("foto"), async (req, res) => {
  const { username, password, nama, alamat } = req.body;
  const foto = req.file.path; // Path foto yang di-upload

  if (!username || !password || !nama || !alamat || !foto) {
    return res.status(400).json({
      status: false,
      message: "Username, password, nama, alamat, and foto are required",
    });
  }
  //

  try {
    const [userExists] = await pool.query("SELECT * FROM users WHERE username = ?", [username]);
    if (userExists.length > 0) {
      return res.status(400).json({ status: false, message: "Username already exists" });
    }

    await pool.query("INSERT INTO users (username, password, nama, alamat, foto) VALUES (?, ?, ?, ?, ?)", [username, password, nama, alamat, foto]);
    res.status(200).json({ status: true, message: "User registered successfully" });
  } catch (err) {
    console.error("Error during registration:", err);
    res.status(500).json({ status: false, message: err.message });
  }
});

// Login route
app.post("/api/login", async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ status: false, message: "Username and password are required" });
  }

  try {
    const [user] = await pool.query("SELECT * FROM users WHERE username = ? AND password = ?", [username, password]);
    if (user.length > 0) {
      res.status(200).json({ status: true, user: user[0] });
    } else {
      res.status(400).json({ status: false, message: "Invalid username or password" });
    }
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Report trash route
app.post("/api/reportTrash", upload.single("image"), async (req, res) => {
  const { username, location, type, info } = req.body;
  const image = req.file ? req.file.filename : null;
  if (!username || !location || !type || !image) {
    return res.status(400).json({ status: false, message: "All fields are required" });
  }

  try {
    await pool.query("INSERT INTO reports (username, location, type, info, image) VALUES (?, ?, ?, ?, ?)", [username, location, type, info, image]);
    res.status(200).json({ status: true, message: "Laporan Anda Sukses, Tunggu Pengambilan Sampah" });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Get all reports route
app.get("/api/reports", async (req, res) => {
  try {
    const [reports] = await pool.query("SELECT * FROM reports ORDER BY id DESC"); // Query to select reports

    res.status(200).json({ status: true, reports });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Fetch education content
app.get("/api/education", async (req, res) => {
  try {
    const [education] = await pool.query("SELECT * FROM education ORDER BY date DESC");
    res.status(200).json({ status: true, education });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Fetch notifications for a user
app.get("/api/notifications/:username", async (req, res) => {
  const { username } = req.params;
  try {
    const [notifications] = await pool.query("SELECT * FROM notifications WHERE username = ? ORDER BY date DESC", [username]);
    res.status(200).json({ status: true, notifications });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

const aboutInfo = {
  name: "TrashTrack",
  version: "1.0.0",
  description: "TrashTrack adalah aplikasi pelacak limbah yang memberikan informasi tentang pengelolaan sampah secara efektif.",
};

// Endpoint "About"
app.get("/api/about", (req, res) => {
  res.json(aboutInfo);
});

// Serve uploaded images
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Start the server
app.listen(port, "192.168.1.50", () => {
  console.log(`Server running on http://localhost:${port}`);
});
