-- phpMyAdmin SQL Dump
-- version 4.0.10.14
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Oct 01, 2016 at 02:04 AM
-- Server version: 5.6.30-cll-lve
-- PHP Version: 5.6.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `aftersdb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`christamakloe`@`localhost` PROCEDURE `getHostedPartyList`(
IN requestedLat float, 
IN requestedLong float)
BEGIN
declare maxDistance int;

SELECT 
ConfigValue
INTO maxDistance FROM
    Configuration
WHERE
    ConfigKey = "RediusInKm";

SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeRange,
    Interest,
    Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    Active = 1
HAVING Distance < maxDistance
ORDER BY PartyDate DESC;
END$$

CREATE DEFINER=`christamakloe`@`localhost` PROCEDURE `hostedPartiesWithFilters`(IN `requestedLat` FLOAT, IN `requestedLong` FLOAT, IN `radius` INT, IN `age` INT, IN `genre` VARCHAR(30))
BEGIN

declare maxDistance int;
declare musicGenreLikeQuery varchar(32);

SELECT 
ConfigValue
INTO maxDistance FROM
    Configuration
WHERE
    ConfigKey = "RediusInKm";
	
SET musicGenreLikeQuery = CONCAT("%",genre,"%");	
    
-- First case if all of them are null or 0   
IF radius = 0 and age = 0 and (genre = '' or genre is null) THEN
SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeAttending as AgeRange,
    Interest,
    AgeAttending as Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    Active = 1
HAVING Distance < maxDistance
ORDER BY PartyDate DESC;
-- radius Y, age N, genre N
ELSEIF radius <> 0 and age = 0 and (genre = '' or genre is null) THEN

SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeAttending as AgeRange,
    Interest,
    AgeAttending as Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    Active = 1
HAVING Distance < radius
ORDER BY PartyDate DESC;
-- radius Y, age Y and genre N 
ELSEIF radius <> 0 and age <> 0 and (genre = '' or genre is null) THEN

SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeAttending as AgeRange,
    Interest,
    AgeAttending as Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    AgeAttending <= age and 
    Active = 1
HAVING Distance < radius
ORDER BY PartyDate DESC;
-- radius Y, age Y, genre Y
ELSEIF radius <> 0 and age <> 0 and genre <> '' THEN

SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeAttending as AgeRange,
    Interest,
    AgeAttending as Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    Music like musicGenreLikeQuery and 
    AgeAttending <= age and 
    Active = 1
HAVING Distance < radius
ORDER BY PartyDate DESC;
-- radius N, age Y, genre Y
ELSEIF radius = 0 and age <> 0 and genre <> '' THEN

SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeAttending as AgeRange,
    Interest,
    AgeAttending as Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    Music like musicGenreLikeQuery and 
    AgeAttending <= age and 
    Active = 1
HAVING Distance < maxDistance
ORDER BY PartyDate DESC;
-- radius N, age N, genre Y
ELSEIF radius = 0 and age = 0 and genre <> '' THEN

SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeAttending as AgeRange,
    Interest,
    AgeAttending as Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    Music like musicGenreLikeQuery and     
    Active = 1
HAVING Distance < maxDistance
ORDER BY PartyDate DESC;
-- radius Y, age N, genre Y
ELSEIF radius <> 0 and age = 0 and genre <> '' THEN

SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeAttending as AgeRange,
    Interest,
    AgeAttending as Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    Music like musicGenreLikeQuery and     
    Active = 1
HAVING Distance < radius
ORDER BY PartyDate DESC;

-- radius N, age Y, genre N
ELSEIF radius = 0 and age <> 0 and (genre = '' or genre is null) THEN

SELECT 
    PartyId,
    Title,
    Description,
    Latitude,
    Longitude,
    Location,
    Music,
    AgeAttending as AgeRange,
    Interest,
    AgeAttending as Attending,
    Image,
    HostBy,
    PartyDate,
    CreatedDate,
    (6371 * ACOS(COS(RADIANS(requestedLat)) * COS(RADIANS(Latitude)) * COS(RADIANS(Longitude) - RADIANS(requestedLong)) + SIN(RADIANS(requestedLat)) * SIN(RADIANS(Latitude)))) AS Distance
FROM
    parties
WHERE
    AgeAttending <= age and     
    Active = 1
HAVING Distance < maxDistance
ORDER BY PartyDate DESC;


END IF;


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Configuration`
--

CREATE TABLE IF NOT EXISTS `Configuration` (
  `ConfigId` int(11) NOT NULL AUTO_INCREMENT,
  `ConfigKey` varchar(45) DEFAULT NULL,
  `ConfigValue` int(11) DEFAULT NULL,
  `Active` int(11) DEFAULT NULL,
  PRIMARY KEY (`ConfigId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `Configuration`
--

INSERT INTO `Configuration` (`ConfigId`, `ConfigKey`, `ConfigValue`, `Active`) VALUES
(1, 'RediusInKm', 1000, 1);

-- --------------------------------------------------------

--
-- Table structure for table `favourite_party`
--

CREATE TABLE IF NOT EXISTS `favourite_party` (
  `FavouriteId` int(11) NOT NULL AUTO_INCREMENT,
  `PartyId` int(11) DEFAULT NULL,
  `UserId` int(11) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`FavouriteId`),
  KEY `FkFavouriteUserId_idx` (`UserId`),
  KEY `FkFaouritePartyId_idx` (`PartyId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=49 ;

--
-- Dumping data for table `favourite_party`
--

INSERT INTO `favourite_party` (`FavouriteId`, `PartyId`, `UserId`, `CreatedDate`) VALUES
(47, 58, 29, '2016-10-01 07:07:30');

-- --------------------------------------------------------

--
-- Table structure for table `like_party`
--

CREATE TABLE IF NOT EXISTS `like_party` (
  `LikeId` int(11) NOT NULL AUTO_INCREMENT,
  `PartyId` int(11) DEFAULT NULL,
  `UserId` int(11) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`LikeId`),
  KEY `FkLikeUserId_idx` (`UserId`),
  KEY `FkLikePartyId_idx` (`PartyId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=46 ;

--
-- Dumping data for table `like_party`
--

INSERT INTO `like_party` (`LikeId`, `PartyId`, `UserId`, `CreatedDate`) VALUES
(44, 58, 29, '2016-10-01 07:07:34'),
(45, 58, 25, '2016-10-01 07:28:22');

-- --------------------------------------------------------

--
-- Table structure for table `parties`
--

CREATE TABLE IF NOT EXISTS `parties` (
  `PartyId` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(200) DEFAULT NULL,
  `Description` text,
  `Latitude` double NOT NULL,
  `Longitude` double NOT NULL,
  `Location` text,
  `Music` varchar(200) DEFAULT NULL,
  `AgeRange` varchar(100) DEFAULT NULL,
  `Interest` varchar(45) DEFAULT NULL,
  `Attending` varchar(45) DEFAULT NULL,
  `Image` text,
  `HostBy` int(11) DEFAULT NULL,
  `PartyDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `Active` int(11) DEFAULT NULL,
  `AgeAttending` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PartyId`),
  KEY `FkPartiesUserId_idx` (`HostBy`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=59 ;

--
-- Dumping data for table `parties`
--

INSERT INTO `parties` (`PartyId`, `Title`, `Description`, `Latitude`, `Longitude`, `Location`, `Music`, `AgeRange`, `Interest`, `Attending`, `Image`, `HostBy`, `PartyDate`, `CreatedDate`, `Active`, `AgeAttending`) VALUES
(58, 'test', 'test', 18.5493868, 73.7893253, '	S.NO -135	Pashan	Pune, Maharashtra 411021	India', 'rock', NULL, NULL, NULL, 'http://aftersapp.com/api/party_images/test57ef607d63ebf.png', 29, '2016-10-01 07:06:37', '2016-10-01 07:06:37', 1, 30);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `UserId` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Email2` varchar(100) DEFAULT NULL,
  `Phone` double DEFAULT NULL,
  `Gender` varchar(45) DEFAULT NULL,
  `ProfileImage` text,
  `Dob` datetime DEFAULT NULL,
  `AccessToken` text,
  `EmailNotification` int(11) DEFAULT NULL,
  `LastLogin` datetime DEFAULT CURRENT_TIMESTAMP,
  `Active` int(11) DEFAULT NULL,
  PRIMARY KEY (`UserId`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=32 ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserId`, `Name`, `Email`, `Email2`, `Phone`, `Gender`, `ProfileImage`, `Dob`, `AccessToken`, `EmailNotification`, `LastLogin`, `Active`) VALUES
(24, 'Christopher Tamakloe', 'chrisatamakloe@gmail.com', 'chrisatamakloe@gmail.com', 123456789, 'Male', NULL, '1992-09-30 00:00:00', NULL, 1, '2016-09-30 14:22:05', 1),
(25, 'Akshay Gadhave', 'akshay@vibeosys.com', 'akshay@vibeosys.com', 1234567890, 'male', 'https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/14449845_212585585825004_8762624504834657416_n.jpg?oh=f474c3247dc63e00a411835b27129a7a&oe=587B5F66', '1992-04-04 00:00:00', 'EAAExzSmkFgYBAE6mDZBjMPYwz3yeS0FC4k9nAYUWyUmhjRYIjTinLmp99VZBCzRy7CbIMtcZCt0ZCnZC8ZBMfo6m2iU13BZCfRNeWJ9c1eDCuzE3G4nQoRmffT18OUn45mJqbwa63cp1W3wSVsZADOsYaU0Mzzi44j4FO2lKnxNyagZDZD', 1, '2016-10-01 05:10:42', 1),
(26, 'Shrinivas SH', 'shrinivas@vibeosys.com', 'shrinivas@vibeosys.com', 1234567890, 'male', 'https://scontent.xx.fbcdn.net/v/t1.0-1/s200x200/10354686_10150004552801856_220367501106153455_n.jpg?oh=b261f1fefcf52ab420b5941363b5e0fa&oe=5873E850', '1989-09-04 00:00:00', 'EAAExzSmkFgYBADd3P5axyby57OX230CmzeVNqB9uKOLa6jTUgU2CrKF48JI6eislGwY90aVcOcgGx0l2svZA6dc0k7hKSu7p1MknibzIpIb670nZBlivCF5ZBXUBd5HwtcXgWD9a22fogWa9q6MJmq7qYD3SD9iPydsjI392gZDZD', 1, '2016-10-01 05:30:02', 1),
(27, 'Andy Kulkarni', 'andyskulkarni@gmail.com', 'andyskulkarni@gmail.com', 1234567890, 'Male', NULL, NULL, '104466639598690285368', 1, '2016-10-01 05:33:11', 1),
(28, 'Anand Kulkarni', 'anand.kulkarni123@gmail.com', 'anand.kulkarni123@gmail.com', 1234567890, 'Male', 'https://lh6.googleusercontent.com/-bjTnxX4tcmQ/AAAAAAAAAAI/AAAAAAAAEc4/RdFVHvhkhDE/photo.jpg', NULL, '114794016657748111380', 1, '2016-10-01 05:35:13', 1),
(29, 'Vibeosys Software', 'vibeosys@gmail.com', 'vibeosys@gmail.com', 1234567890, 'Male', 'https://lh5.googleusercontent.com/-LUMuu8LgYaI/AAAAAAAAAAI/AAAAAAAAABU/jl2WJniuh7o/photo.jpg', NULL, '106386735903030299013', 1, '2016-10-01 06:12:05', 1),
(30, 'John Lewis', 'jaralewis@gmail.com', 'jaralewis@gmail.com', 1234567890, 'male', 'https://scontent.xx.fbcdn.net/v/l/t1.0-1/p200x200/12963697_1599095430412355_7834072811962200141_n.jpg?oh=6d81daedb644ffe8d193fec049c5d682&oe=58602F57', '1953-07-05 00:00:00', 'EAAExzSmkFgYBACSRjEctYlE7kbx5QalZBgAlvcrrtaJZACN9joz2xfvNEAnVqBATbnQZCASo20MsfiqdooOttYS7aHuJKYDZB1JZALVzO7HHjJ6JYHxGnNbiKFKlvy05ALTU82vuIo0pUUZBpAib1HcNwWzOsZC7ZAfaX3BELZArVhTjWOrgRKheJKlFegbTWKE4ZD', 1, '2016-10-01 07:22:05', 1),
(31, 'KP6P2LNLKEGULXTALLEJP3CRNI-00@cloudtestlabaccounts.com', 'KP6P2LNLKEGULXTALLEJP3CRNI-00@cloudtestlabaccounts.com', 'KP6P2LNLKEGULXTALLEJP3CRNI-00@cloudtestlabaccounts.com', 1234567890, 'Male', NULL, NULL, '108501451531827756812', 1, '2016-10-01 07:49:32', 1);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `favourite_party`
--
ALTER TABLE `favourite_party`
  ADD CONSTRAINT `FkFaouritePartyId` FOREIGN KEY (`PartyId`) REFERENCES `parties` (`PartyId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FkFavouriteUserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`UserId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `like_party`
--
ALTER TABLE `like_party`
  ADD CONSTRAINT `FkLikePartyId` FOREIGN KEY (`PartyId`) REFERENCES `parties` (`PartyId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `FkLikeUserId` FOREIGN KEY (`UserId`) REFERENCES `users` (`UserId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `parties`
--
ALTER TABLE `parties`
  ADD CONSTRAINT `FkUserPartiesUserId` FOREIGN KEY (`HostBy`) REFERENCES `users` (`UserId`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
