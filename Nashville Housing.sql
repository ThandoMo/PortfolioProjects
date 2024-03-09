/*
CLEANING DATA IN SQL QUERIES

*/

Select *
From PortfolioProject.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------------

--Standardize Date format


Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate) 


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;


UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate) 

---------------------------------------------------------------------------------------------------

--populate property address data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID 


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 And a.[UniqueID ] <> b. [UniqueID ]
Where a.PropertyAddress is null

Update a
SET propertyAddress = ISNULL(a.propertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 And a.[UniqueID ] <> b. [UniqueID ]
Where a.PropertyAddress is null

----------------------------------------------------------------------------------------------------------

--Breaking out address into individual columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID 

Select
SUBSTRING(propertyaddress, 1, CHARINDEX(',' , PropertyAddress) -1) as Address
 , SUBSTRING(propertyaddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))  as Address
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
ADD propertySplitAddress NVARCHAR(255);


UPDATE NashvilleHousing
SET propertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',' , PropertyAddress) -1) 



ALTER TABLE NashvilleHousing
ADD propertySplitCity NVARCHAR(255);


UPDATE NashvilleHousing
SET propertySplitCity =  SUBSTRING(propertyaddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) 



Select*
From PortfolioProject.dbo.NashvilleHousing



Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)
From PortfolioProject.dbo.NashvilleHousing






ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2) 

 

ALTER TABLE NashvilleHousing
ADD OwnerSplitstate NVARCHAR(255);


UPDATE NashvilleHousing
SET OwnerSplitstate =  PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,1)


Select *
From PortfolioProject.dbo.NashvilleHousing



----------------------------------------------------------------------------------------------------

--change Y and N to Yes and No in "sold as vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

----------------------------------------------------------------------------------------------

-- remove duplicates

WITH RowNumCTE AS(
select* ,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
                propertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				  UniqueID
				  ) row_num
                       


From PortfolioProject.dbo.NashvilleHousing
--order by ParcelI
)
SELECT*
FROM RowNumCTE
WHERE row_num >1
Order by PropertyAddress


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused columns


Select*
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
