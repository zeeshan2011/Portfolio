--------------------------------------------
-----------Cleaning Data in Sql-------------
--------------------------------------------
select * from NationalHousing
select saledate2 from NationalHousing

-- coverting saledate from datetime to date

update NationalHousing
set SaleDate = convert(date, SaleDate)

alter table NationalHousing
add SaleDate2 date

update NationalHousing
set SaleDate2 = convert(date, SaleDate)

-- populating the property address

select * from NationalHousing 
order by ParcelID

select  [UniqueID ], ParcelID, PropertyAddress 
from NationalHousing
where PropertyAddress is null
 

--

update a 
set a.PropertyAddress = isnull(a.propertyAddress, b.PropertyAddress)
from NationalHousing a
join NationalHousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- dividing property address into Address and City

select PropertyAddress ,
SUBSTRINg(PropertyAddress, 1, (CHARINDEX(',', PropertyAddress))-1) as Address,
SUBSTRINg(PropertyAddress, (CHARINDEX(',', PropertyAddress))+1, LEN(PropertyAddress)) as City
from NationalHousing

-- add two new columns to add values of address and city

alter table NationalHousing
add Address nvarchar(255),
City nvarchar(255)

update NationalHousing
set Address = SUBSTRINg(PropertyAddress, 1, (CHARINDEX(',', PropertyAddress))-1),
City = SUBSTRINg(PropertyAddress, (CHARINDEX(',', PropertyAddress))+1, LEN(PropertyAddress))

select PropertyAddress, Address, City  from NationalHousing

-- for owner Address
-- splitting it to 3 individual columns for Address, City Name and State Name

select OwnerName, OwnerAddress 
from NationalHousing 
where OwnerName is not null
 
select PARSENAME(REPLACE(OwnerAddress, ',','.'), '3') ,
PARSENAME(REPLACE(OwnerAddress, ',','.'), '2'), 
PARSENAME(REPLACE(OwnerAddress, ',','.'), '1') 
from NationalHousing

--- adding new columns

alter table NationalHousing
add OwnerSplitAddress nvarchar(255),
OwnerSplitCity nvarchar(255),
OwnerSplitState nvarchar(255)

update NationalHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'), '3'),
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'), '2'), 
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'), '1')

----

select OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState
from NationalHousing
where OwnerAddress is not null

-- changing Y to Yes and N to No in SoldAsVacant column
 
select SoldAsVacant,
case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else 
SoldAsVacant
end
from NationalHousing

update NationalHousing
set SoldAsVacant = case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else 
SoldAsVacant
end
from NationalHousing

select *
from NationalHousing

--- removing Duplicates from the Data
WITH RowNumCte AS
(
select *, 
Row_number() over (
partition by [ParcelID], [PropertyAddress], [SaleDate], [SalePrice], [LegalReference]
order by [UniqueID ]
) rownumber
from NationalHousing
)
select *  from RowNumCte
where rownumber > 1

-- deleting Unsused Columns

select * from NationalHousing
--
alter Table NationalHousing
drop Column SaleDate , propertyAddress , OwnerAddress, TaxDistrict