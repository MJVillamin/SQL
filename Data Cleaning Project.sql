select *
from PortfolioProject..NationalHousing

select SaleDate
from NationalHousing

select SaleDate, CONVERT(DATE,SaleDate)
from NationalHousing

alter table NationalHousing
add SaleDateConverted DATE;

UPDATE NationalHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)

select SaleDateConverted
from NationalHousing


select PropertyAddress
from NationalHousing
where PropertyAddress is null

select *
from NationalHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NationalHousing a
join NationalHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from NationalHousing a
join NationalHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NationalHousing a
join NationalHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NationalHousing a
join NationalHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


select PropertyAddress
from NationalHousing

select
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as StreetAddress,
substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as CityAddress
from NationalHousing

alter table NationalHousing
add PropertyStreetAddress NVarchar(255);

UPDATE NationalHousing
SET PropertyStreetAddress = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

alter table NationalHousing
add PropertyCityAddress NVarchar(255);

UPDATE NationalHousing
SET PropertyCityAddress = substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


select
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from NationalHousing

alter table NationalHousing
add OwnerStreetAddress NVarchar(255);

UPDATE NationalHousing
SET OwnerStreetAddress = parsename(replace(OwnerAddress,',','.'),3)

alter table NationalHousing
add OwnerCityAddress NVarchar(255);

UPDATE NationalHousing
SET OwnerCityAddress = parsename(replace(OwnerAddress,',','.'),2)

alter table NationalHousing
add OwnerStateAddress NVarchar(255);

UPDATE NationalHousing
SET OwnerStateAddress = parsename(replace(OwnerAddress,',','.'),1)


select Distinct(SoldAsVacant), Count(SoldAsVacant)
from NationalHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from NationalHousing

update NationalHousing
SET SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
						end



With DuplicateCTE as(
select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueID) duplicate_num
from NationalHousing
)
select *
from DuplicateCTE
where duplicate_num > 1
order by PropertyAddress

With DuplicateCTE as(
select *,
	ROW_NUMBER() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueID) duplicate_num
from NationalHousing
)
delete
from DuplicateCTE
where duplicate_num > 1


alter table NationalHousing
drop column SaleDate, PropertyAddress, OwnerAddress, TaxDistrict