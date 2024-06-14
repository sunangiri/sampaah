-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 13, 2024 at 09:11 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `trashtrack`
--

-- --------------------------------------------------------

--
-- Table structure for table `education`
--

CREATE TABLE `education` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `location` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `image` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`id`, `username`, `location`, `type`, `image`, `created_at`) VALUES
(26, 'farid', 'bojonegoro', 'plastik', '1718262908740-c967872d-c417-4c60-aa50-c8f59c67934b3767521537421298658.jpg', '2024-06-13 07:15:27'),
(27, 'farid', 'vhv', 'vvv', '1718264377531-5a85e3f4-e0fa-4595-ba80-bc52980bce7d159248723983437205.jpg', '2024-06-13 07:43:45'),
(28, 'yulfi', 'ngumpak', 'plastik', '1718265104801-bah.png', '2024-06-13 07:51:44'),
(29, 'farid', 'ghdb', 'vwhha', '1718265426574-a3a0de58-ec9f-4d1f-bb25-e8b7696e61217464920171328792567.jpg', '2024-06-13 08:01:11'),
(30, 'yulfi', 'ngumpak', 'plastik', '1718266627490-bah.png', '2024-06-13 08:17:07'),
(31, 'farid', 'bdjdj', 'hdjdj', '1718267607952-c74105b1-b73e-43db-b406-dd0c189867403073151013134211440.jpg', '2024-06-13 08:33:41'),
(32, 'farid', 'hsjdh', 'hsjs', '1718267895547-e67c458c-fc1f-436b-9684-c573cefedeb7987723333613138385.jpg', '2024-06-13 08:38:18'),
(33, 'farid', 'bdjdvb', 'bdjjdb', '1718268254650-8abe9c1b-a2c8-4ff7-a626-7f133e2eaac24381721616876793772.jpg', '2024-06-13 08:44:16'),
(34, 'farid', 'hdidh', 'ndkdhj', '1718269067605-2ffad79d-03b7-42e2-ba52-26eec056524d7182591867900648686.jpg', '2024-06-13 08:57:49'),
(35, 'farid', 'hsjsg', 'bdjdg', '1718269624241-873d5043-4aa8-4c26-9202-a25d9539767a8945637291222916342.jpg', '2024-06-13 09:07:07');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `alamat` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `nama`, `alamat`) VALUES
(1, 'yulfi', '123', 'M. Yulvi Aditya P.', 'Pejok, Kepohbaru, Bojonegoro, Jawa Timur'),
(2, 'farid', '123', 'farid Ma\'ruf', 'kedungadem, Bojonegoro, Jawa Timur'),
(3, 'rizky', '123', 'Rizky Ahmad Turiyanto', 'Sugihwaras, Parengan, Tuban, Jawa Timur'),
(4, 'bisri', '123', 'M. Bisri Mustofa', 'Malo, Bojonegoro, Jawa Timur'),
(5, 'farid1', '123', 'farid', 'pcpppdppd'),
(7, 'farid12', '123', 'farid', 'kedungadem');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `education`
--
ALTER TABLE `education`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `education`
--
ALTER TABLE `education`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`);

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
