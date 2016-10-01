CREATE DEFINER=`dev`@`%` PROCEDURE `hostedPartiesWithFilters`(
IN requestedLat float, 
IN requestedLong float,
IN radius int,
IN age int,
IN genre varchar(30))
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


END