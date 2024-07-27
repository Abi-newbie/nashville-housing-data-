create table Nashville_Housing(
	UniqueID 	varchar(255),
	ParcelID	varchar(255),
	LandUse	varchar(255),
	PropertyAddress	varchar(255),
	SaleDate	date,
	SalePrice	NUMERIC(10,2),
	LegalReference varchar(255),
	SoldAsVacant  	varchar(255),
	OwnerName varchar(255),
	OwnerAddress	varchar(255),
	Acreage	numeric(10,2),
	TaxDistrict	varchar(255),
	LandValue	INT,
	BuildingValue	INT,
	TotalValue	INT,
	YearBuilt INT,
	Bedrooms	INT,
	FullBath  INT,
	HalfBath INT
);

__polpulte property data address
	
SELECT a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress,COALESCE (a.propertyaddress,  b.propertyaddress)
FROM Nashville_Housing as a 
join Nashville_Housing as b
on a.parcelid = b.parcelid 
and a.UniqueID <> b.UniqueID
where 'propertyaddress' is null

update Nashville_Housing 
set propertyaddress = COALESCE (a.propertyaddress,  b.propertyaddress)
FROM Nashville_Housing as a 
join Nashville_Housing as b
on a.parcelid = b.parcelid 
and a.UniqueID <> b.UniqueID
where 'propertyaddress' is null

SELECT *
FROM NASHVILLE_HOUSING
ORDER BY PARCELID

--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS
SELECT 
SUBSTRING(PROPERTYADDRESS,1, POSITION (',' IN PROPERTYADDRESS)-1)AS ADDRESS
,SUBSTRING(PROPERTYADDRESS, POSITION (',' IN PROPERTYADDRESS)+1 )AS ADDRESS1
FROM NASHVILLE_HOUSING

ALTER TABLE NASHVILLE_HOUSING
ADD OWNERSPLITSTATE VARCHAR(255)

UPDATE  NASHVILLE_HOUSING
SET OWNERSPLITSTATE = SUBSTRING(OWNERADDRESS,39, POSITION (',' IN OWNERADDRESS)+1)

ALTER TABLE NASHVILLE_HOUSING
ADD OWNERSPLITCITY VARCHAR(255)

UPDATE  NASHVILLE_HOUSING
SET OWNERSPLITCITY = SUBSTRING(OWNERADDRESS,23, POSITION (',' IN PROPERTYADDRESS)-7)

SELECT OWNERADDRESS
FROM NASHVILLE_HOUSING

SELECT 
SUBSTRING(OWNERADDRESS,1, POSITION (',' IN OWNERADDRESS)-1)AS ADDRESS
,SUBSTRING(OWNERADDRESS,23, POSITION (',' IN OWNERADDRESS)-7)AS ADDRESS1
,SUBSTRING(OWNERADDRESS,39, POSITION (',' IN OWNERADDRESS)+1)
FROM NASHVILLE_HOUSING

--CHANGE Y AND N TO YES AND NO
SELECT DISTINCT(SOLDASVACANT)
FROM NASHVILLE_HOUSING

SELECT DISTINCT(SOLDASVACANT), COUNT(SOLDASVACANT)
FROM NASHVILLE_HOUSING
GROUP BY SOLDASVACANT
ORDER BY 2

SELECT SOLDASVACANT,
  CASE 	WHEN SOLDASVACANT = 'Y' THEN 'YES'
		WHEN SOLDASVACANT = 'N' THEN 'NO'   
		ELSE SOLDASVACANT
		END	
FROM NASHVILLE_HOUSING

UPDATE  NASHVILLE_HOUSING
SET SOLDASVACANT =
	CASE 	WHEN SOLDASVACANT = 'Y' THEN 'YES'
		WHEN SOLDASVACANT = 'N' THEN 'NO'   
		ELSE SOLDASVACANT
		END	

--REMOVE DUPLICATES
WITH rownumcte AS (
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY PARCELID,
				 PROPERTYADDRESS,
				 SALEDATE,
	   			 SALEPRICE,
				 LEGALREFERENCE
				ORDER BY UNIQUEID
			)ROW_NUM
FROM NASHVILLE_HOUSING
ORDER BY PARCELID
)
select *
from rownumcte
WHERE row_num > 1
ORDER BY PROPERTYADDRESS

--dleting unsued columns

alter table nashville_housing
drop column taxdistrict

alter table nashville_housing
drop column halfbath

