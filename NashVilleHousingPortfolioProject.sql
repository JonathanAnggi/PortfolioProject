-- Cleaning Data In SQL Queries

Select *
From PortfolioProject..NashVilleHousing

-- Standardize Date Format

Select SaleDateConverted, convert(date, saledate)
From PortfolioProject..NashVilleHousing

update NashVilleHousing
set SaleDate = convert(date, saledate)

alter table NashVilleHousing
add SaleDateConverted date;

update NashVilleHousing
set SaleDateConverted  = convert(date, saledate)


-- Populate Property Adress Data

Select *
From PortfolioProject..NashVilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashVilleHousing a
join PortfolioProject..NashVilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashVilleHousing a
join PortfolioProject..NashVilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Addres Into Individual Columns (Address, City, State)

Select PropertyAddress
from PortfolioProject..NashVilleHousing

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

from PortfolioProject..NashVilleHousing

alter table NashVilleHousing
add PropertySplitAddress nvarchar(255);

update NashVilleHousing
set PropertySplitAddress  = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

alter table NashVilleHousing
add PropertySplitCity nvarchar(255);

update NashVilleHousing
set PropertySplitCity  = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
from PortfolioProject..NashVilleHousing


Select OwnerAddress
from PortfolioProject..NashVilleHousing


Select
parsename(replace(OwnerAddress, ',', '.'),3)
,parsename(replace(OwnerAddress, ',', '.'),2)
,parsename(replace(OwnerAddress, ',', '.'),1)
from PortfolioProject..NashVilleHousing



alter table NashVilleHousing
add OwnerSplitAddress nvarchar(255);

update NashVilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'),3)

alter table NashVilleHousing
add OwnerSplitCity nvarchar(255);

update NashVilleHousing
set OwnerSplitCity  = parsename(replace(OwnerAddress, ',', '.'),2)

alter table NashVilleHousing
add OwnerSplitState nvarchar(255);

update NashVilleHousing
set OwnerSplitState  = parsename(replace(OwnerAddress, ',', '.'),1)

Select *
from PortfolioProject..NashVilleHousing


-- Change Y and N to Yes and No In "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashVilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from PortfolioProject..NashVilleHousing

Update NashVilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end


--- Removes Duplicates

WITH RowNumCTE as (
Select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by
					UniqueID
					) row_num
from PortfolioProject..NashVilleHousing
--order by ParcelID
)

Select *
from RowNumCTE
where row_num > 1
--order by PropertyAddress



-- Delete Unused Columns

Select *
from PortfolioProject..NashVilleHousing

alter table PortfolioProject..NashVilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

