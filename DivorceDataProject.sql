/*

Divorce Data Exploration


*/

--Cleaned the Data by Removing NULLS and UnSpecified entries From all the Columns we are using

-- Deleting Nulls From all the Columns we are using

Delete
From Divorces
Where MaleNoTimesMarried Is Null
	Or FemaleNoTimesMarried Is Null
	Or MaleAge Is Null
	Or FemaleAge Is Null
	Or MarriageYear Is Null
	Or NoOfChildren Is Null
	Or DurationOfMarriage Is Null

-- Checked for Any remaining NUlls in the Table
--
Select *
From Divorces
Where MaleNoTimesMarried Is Not Null
	Or FemaleNoTimesMarried Is Not Null
	Or MaleAge Is Not Null
	Or FemaleAge Is Not Null
	Or MarriageYear Is Not Null
	Or NoOfChildren Is Not Null
	Or DurationOfMarriage Is Not Null
									--14 153 rows returned by this query
Select *
From Divorces
Where MaleNoTimesMarried Is Null
	Or FemaleNoTimesMarried Is Null
	Or MaleAge Is Null
	Or FemaleAge Is Null
	Or MarriageYear Is Null
	Or NoOfChildren Is Null
	Or DurationOfMarriage Is Null
								--0 rows returned by this query
--____________________________________________________________________

--Creating a new table for visualization

Drop Table New_Divorce
Create Table New_Divorce (
Province varchar (50),
GroundsForDivorce varchar (50),
CoupleRace varchar (50),
AgeDiff varchar (255),
AvgDurationOfMarriage float 
)
--___________________________________________________________________________________

--Inserting data into the New Table

Insert into New_Divorce
Select Divorces.ProvinceCode, Divorces.GroundsForDivorce, Divorces.CoupleRace,
		Civil.AgeDiff, Round(AVG(DurationOfMarriage), 2) As AvgDurationOfMarriage
From Divorces
Join CivilMarriages Civil
On Divorces.ProvinceCode = Civil.ProvinceCode
Where DurationOfMarriage < 60
Group By Divorces.ProvinceCode, Divorces.GroundsForDivorce, Divorces.CoupleRace,
		Civil.AgeDiff

Select Province, AvgDurationOfMarriage
From New_Divorce
Group By Province,AvgDurationOfMarriage
Order by AvgDurationOfMarriage desc




--______________________________________________________________

--Divorce Rate by Grounds Excluding 'Unspecified'

Select ProvinceCode, GroundsForDivorce, COUNT(GroundsForDivorce) As CountGrounds, Round(AVG(DurationOfMarriage), 2) As AvgDurationOfMarriage
From Divorces
Where DurationOfMarriage < 60 and GroundsForDivorce <> 'Unspecified'
Group By ProvinceCode, GroundsForDivorce, GroundsForDivorce
Order By CountGrounds desc

Create View 
DivorceGrounds As
Select ProvinceCode, GroundsForDivorce, COUNT(GroundsForDivorce) As CountGrounds, Round(AVG(DurationOfMarriage), 2) As AvgDurationOfMarriage
From Divorces
Where DurationOfMarriage < 60 and GroundsForDivorce <> 'Unspecified'
Group By ProvinceCode, GroundsForDivorce, GroundsForDivorce

Select *
From DivorceGrounds