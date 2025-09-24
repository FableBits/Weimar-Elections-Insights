--Data from Harvard Dataverse, from the study
--"Ordinary Economic Voting Behavior in the Extraordinary Election of Adolf Hitler"
--We use the sheet named "resultslabelled" from the csv file "results" 
--We use the mean values of the votes to the nazi party based on social class and religion 
--We have renamed the table to "weimar_election"

ALTER TABLE weimar_election
CHANGE COLUMN Column1 year INT;

ALTER TABLE weimar_election
MODIFY COLUMN year VARCHAR(10);

UPDATE weimar_election
SET year = '1932(7)'
WHERE year = '19327';

UPDATE weimar_election
SET year = '1932(11)'
WHERE year = '193211';

--set the vote percentage values to 3 digits decimals
--the first letter of the name indicates the social class:
--U = Unemployed
--B = Blue Collar
--W = White Collar
--S = Self Employed
--D = Domestic
--the second letter of the name indicates regional unemployment:
--L = Low Unemployment
--M = Medium Unemployment
--H = High Unemployment
--the last letter of the name indicates the religion:
--P = Protestant
--C = Catholic
UPDATE weimar_election 
SET 
ULP = ROUND(ULP, 3),
BLP = ROUND(BLP, 3),
WLP = ROUND(WLP, 3),
SLP = ROUND(SLP, 3),
DLP = ROUND(DLP, 3),
UMP = ROUND(UMP, 3),
BMP = ROUND(BMP, 3),
WMP = ROUND(WMP, 3),
SMP = ROUND(SMP, 3),
DMP = ROUND(DMP, 3),
UHP = ROUND(UHP, 3),
BHP = ROUND(BHP, 3),
WHP = ROUND(WHP, 3),
SHP = ROUND(SHP, 3),
DHP = ROUND(DHP, 3),
ULC = ROUND(ULC, 3),
BLC = ROUND(BLC, 3),
WLC = ROUND(WLC, 3),
SLC = ROUND(SLC, 3),
DLC = ROUND(DLC, 3),
UMC = ROUND(UMC, 3),
BMC = ROUND(BMC, 3),
WMC = ROUND(WMC, 3),
SMC = ROUND(SMC, 3),
DMC = ROUND(DMC, 3),
UHC = ROUND(UHC, 3),
BHC = ROUND(BHC, 3),
WHC = ROUND(WHC, 3),
SHC = ROUND(SHC, 3),
DHC = ROUND(DHC, 3);

--adjust the percentages to the population of each social class
--social class populations based on the same Harvard study in word file named "Documentation"
CREATE TABLE weimar_weighted AS
SELECT
  year,
  (
    ULP * 3598176 +
    UMP * 5819807 +
    UHP * 13307338 +
    ULC * 2847738 +
    UMC * 2435575 +
    UHC * 4037088
  ) / (
    3598176 + 5819807 + 13307338 + 2847738 + 2435575 + 4037088
  ) AS U_avg,
  (
    BLP * 3598176 +
    BMP * 5819807 +
    BHP * 13307338 +
    BLC * 2847738 +
    BMC * 2435575 +
    BHC * 4037088
  ) / (
    3598176 + 5819807 + 13307338 + 2847738 + 2435575 + 4037088
  ) AS B_avg,
  (
    WLP * 3598176 +
    WMP * 5819807 +
    WHP * 13307338 +
    WLC * 2847738 +
    WMC * 2435575 +
    WHC * 4037088
  ) / (
    3598176 + 5819807 + 13307338 + 2847738 + 2435575 + 4037088
  ) AS W_avg,
  (
    SLP * 3598176 +
    SMP * 5819807 +
    SHP * 13307338 +
    SLC * 2847738 +
    SMC * 2435575 +
    SHC * 4037088
  ) / (
    3598176 + 5819807 + 13307338 + 2847738 + 2435575 + 4037088
  ) AS S_avg,
  (
    DLP * 3598176 +
    DMP * 5819807 +
    DHP * 13307338 +
    DLC * 2847738 +
    DMC * 2435575 +
    DHC * 4037088
  ) / (
    3598176 + 5819807 + 13307338 + 2847738 + 2435575 + 4037088
  ) AS D_avg
FROM weimar_election;

DELETE FROM weimar_weighted 
WHERE YEAR IS NULL;

--adjust the percentages to the population of each social class
--religion populations based on the same Harvard study in pdf file named "NaziVP"
CREATE TABLE weimar_rel AS
SELECT 
	year,
	(
	ULP * 3598176 +
	BLP * 3598176 +
	WLP * 3598176 +
	SLP * 3598176 +
	DLP * 3598176 + 
	UMP * 5819807 +
	BMP * 5819807 +
	WMP * 5819807 +
	SMP * 5819807 +
	DMP * 5819807 +
	UHP * 13307338 +
	BHP * 13307338 +
	WHP * 13307338 +
	SHP * 13307338 +
	DHP * 13307338
	) / (
	(3598176 * 5) + (5819807 * 5) + (13307338 * 5)
	) AS Protestants,
	(
	ULC * 2847738 +
	BLC * 2847738 +
	WLC * 2847738 +
	SLC * 2847738 +
	DLC * 2847738 + 
	UMC * 2435575 +
	BMC * 2435575 +
	WMC * 2435575 +
	SMC * 2435575 +
	DMC * 2435575 +
	UHC * 4037088 +
	BHC * 4037088 +
	WHC * 4037088 +
	SHC * 4037088 +
	DHC * 4037088
	) / (
	(2847738 * 5) + (2435575 * 5) + (4037088 * 5)
	) AS Catholics
FROM weimar_election;

DELETE FROM weimar_rel 
WHERE YEAR IS NULL;

-- ===================================================================
-- DATA VALIDATION QUERIES
-- ===================================================================
-- These queries help verify data integrity and identify potential issues

-- 1. Check for missing or invalid data in main table
SELECT 'Main table record count' AS validation_check, COUNT(*) AS result FROM weimar_election;
SELECT 'Records with NULL year' AS validation_check, COUNT(*) AS result FROM weimar_election WHERE year IS NULL;
SELECT 'Distinct years in dataset' AS validation_check, GROUP_CONCAT(DISTINCT year ORDER BY year) AS result FROM weimar_election;

-- 2. Validate percentage ranges (should be between 0 and 100)
SELECT 'Values outside 0-100 range' AS validation_check, COUNT(*) AS result FROM weimar_election 
WHERE ULP < 0 OR ULP > 100 OR BLP < 0 OR BLP > 100 OR WLP < 0 OR WLP > 100 
   OR SLP < 0 OR SLP > 100 OR DLP < 0 OR DLP > 100 OR UMP < 0 OR UMP > 100 
   OR BMP < 0 OR BMP > 100 OR WMP < 0 OR WMP > 100 OR SMP < 0 OR SMP > 100 
   OR DMP < 0 OR DMP > 100 OR UHP < 0 OR UHP > 100 OR BHP < 0 OR BHP > 100 
   OR WHP < 0 OR WHP > 100 OR SHP < 0 OR SHP > 100 OR DHP < 0 OR DHP > 100
   OR ULC < 0 OR ULC > 100 OR BLC < 0 OR BLC > 100 OR WLC < 0 OR WLC > 100 
   OR SLC < 0 OR SLC > 100 OR DLC < 0 OR DLC > 100 OR UMC < 0 OR UMC > 100 
   OR BMC < 0 OR BMC > 100 OR WMC < 0 OR WMC > 100 OR SMC < 0 OR SMC > 100 
   OR DMC < 0 OR DMC > 100 OR UHC < 0 OR UHC > 100 OR BHC < 0 OR BHC > 100 
   OR WHC < 0 OR WHC > 100 OR SHC < 0 OR SHC > 100 OR DHC < 0 OR DHC > 100;

-- 3. Check for NULL values in percentage columns
SELECT 'NULL percentage values' AS validation_check, 
       SUM(CASE WHEN ULP IS NULL THEN 1 ELSE 0 END) + 
       SUM(CASE WHEN BLP IS NULL THEN 1 ELSE 0 END) + 
       SUM(CASE WHEN WLP IS NULL THEN 1 ELSE 0 END) +
       SUM(CASE WHEN SLP IS NULL THEN 1 ELSE 0 END) +
       SUM(CASE WHEN DLP IS NULL THEN 1 ELSE 0 END) AS result 
FROM weimar_election;

-- 4. Validate weighted averages table
SELECT 'Weighted table record count' AS validation_check, COUNT(*) AS result FROM weimar_weighted;
SELECT 'Weighted averages range check' AS validation_check, COUNT(*) AS result FROM weimar_weighted 
WHERE U_avg < 0 OR U_avg > 100 OR B_avg < 0 OR B_avg > 100 OR W_avg < 0 OR W_avg > 100 
   OR S_avg < 0 OR S_avg > 100 OR D_avg < 0 OR D_avg > 100;

-- 5. Validate religious breakdown table
SELECT 'Religious table record count' AS validation_check, COUNT(*) AS result FROM weimar_rel;
SELECT 'Religious percentages range check' AS validation_check, COUNT(*) AS result FROM weimar_rel 
WHERE Protestants < 0 OR Protestants > 100 OR Catholics < 0 OR Catholics > 100;

-- 6. Summary statistics for main variables by year
SELECT year, 
       ROUND(AVG((ULP + UMP + UHP + ULC + UMC + UHC)/6), 2) AS avg_unemployed_support,
       ROUND(AVG((BLP + BMP + BHP + BLC + BMC + BHC)/6), 2) AS avg_blue_collar_support,
       ROUND(AVG((WLP + WMP + WHP + WLC + WMC + WHC)/6), 2) AS avg_white_collar_support,
       ROUND(MIN(LEAST(ULP, UMP, UHP, ULC, UMC, UHC, BLP, BMP, BHP, BLC, BMC, BHC, 
                      WLP, WMP, WHP, WLC, WMC, WHC, SLP, SMP, SHP, SLC, SMC, SHC, 
                      DLP, DMP, DHP, DLC, DMC, DHC)), 2) AS min_percentage,
       ROUND(MAX(GREATEST(ULP, UMP, UHP, ULC, UMC, UHC, BLP, BMP, BHP, BLC, BMC, BHC, 
                         WLP, WMP, WHP, WLC, WMC, WHC, SLP, SMP, SHP, SLC, SMC, SHC, 
                         DLP, DMP, DHP, DLC, DMC, DHC)), 2) AS max_percentage
FROM weimar_election 
GROUP BY year 
ORDER BY year;

-- 7. Compare Protestant vs Catholic support by year
SELECT w.year, 
       ROUND(r.Protestants, 2) AS protestant_support,
       ROUND(r.Catholics, 2) AS catholic_support,
       ROUND(r.Protestants - r.Catholics, 2) AS protestant_catholic_diff
FROM weimar_weighted w
JOIN weimar_rel r ON w.year = r.year
ORDER BY w.year;

-- 8. Data completeness check
SELECT 'Data validation complete' AS status, 
       CONCAT('Main table: ', (SELECT COUNT(*) FROM weimar_election), ' records, ',
              'Weighted table: ', (SELECT COUNT(*) FROM weimar_weighted), ' records, ',
              'Religious table: ', (SELECT COUNT(*) FROM weimar_rel), ' records') AS summary;
