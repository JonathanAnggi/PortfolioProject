-- Cleaning Data In SQL Queries

SELECT
	*
FROM PortfolioProject..NashVilleHousing;

-- Standardize Date Format

SELECT
	SaleDateConverted,
	CONVERT(DATE, saledate)
FROM PortfolioProject..NashVilleHousing;

UPDATE NashVilleHousing
	SET SaleDate = CONVERT(DATE, saledate);

ALTER TABLE NashVilleHousing
	ADD SaleDateConverted DATE;

UPDATE NashVilleHousing
	SET SaleDateConverted  = CONVERT(DATE, saledate);


-- Populate Property Adress Data

SELECT
	*
FROM PortfolioProject..NashVilleHousing
WHERE PropertyAddress is null
ORDER BY ParcelID;

SELECT
	a.ParcelID,
	a.PropertyAddress,
	b.ParcelID,
	b.PropertyAddress,
	ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashVilleHousing a
JOIN PortfolioProject..NashVilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;


UPDATE a
	SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashVilleHousing a
JOIN PortfolioProject..NashVilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;


-- Breaking out Addres Into Individual Columns (Address, City, State)

SELECT
	PropertyAddress
FROM PortfolioProject..NashVilleHousing;

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,
	LEN(PropertyAddress)) as Address
FROM PortfolioProject..NashVilleHousing;

ALTER TABLE NashVilleHousing
	ADD PropertySplitAddress nvarchar(255);

UPDATE NashVilleHousing
	SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

ALTER TABLE NashVilleHousing
	ADD PropertySplitCity nvarchar(255);
	
UPDATE NashVilleHousing
	SET PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress));

SELECT
	*
FROM PortfolioProject..NashVilleHousing;


SELECT
	OwnerAddress
FROM PortfolioProject..NashVilleHousing;


SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject..NashVilleHousing;

ALTER TABLE NashVilleHousing
	ADD OwnerSplitAddress nvarchar(255);

UPDATE NashVilleHousing
	SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3);

ALTER TABLE NashVilleHousing
	ADD OwnerSplitCity nvarchar(255);

UPDATE NashVilleHousing
	SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2);

ALTER TABLE NashVilleHousing
	ADD OwnerSplitState nvarchar(255);

UPDATE NashVilleHousing
	SET OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1);

SELECT
	*
FROM PortfolioProject..NashVilleHousing;


-- Change Y and N to Yes and No In "Sold as Vacant" field

SELECT
	DISTINCT(SoldAsVacant),
	COUNT(SoldAsVacant)
FROM PortfolioProject..NashVilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT
	SoldAsVacant,
	CASE
		WHEN SoldAsVacant = 'Y' then 'Yes'
		WHEN SoldAsVacant = 'N' then 'No'
		ELSE SoldAsVacant
	END
FROM PortfolioProject..NashVilleHousing;

UPDATE NashVilleHousing
	SET SoldAsVacant = CASE
				WHEN SoldAsVacant = 'Y' then 'Yes'
				WHEN SoldAsVacant = 'N' then 'No'
				ELSE SoldAsVacant
			END;


--- Removes Duplicates

WITH RowNumCTE as (
SELECT
	*,
	ROW_NUMBER() OVER (
			PARTITION BY
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
			ORDER BY UniqueID) row_num
FROM PortfolioProject..NashVilleHousing
)

SELECT
	*
FROM RowNumCTE
WHERE row_num > 1;


-- Delete Unused Columns

SELECT
	*
FROM PortfolioProject..NashVilleHousing;

ALTER TABLE PortfolioProject..NashVilleHousing;

DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

