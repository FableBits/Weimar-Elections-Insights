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
