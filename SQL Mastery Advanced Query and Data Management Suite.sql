-- this uses  [AdventureWorks2012] 
 -- download here [https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms]

--Please run your query against the Adventures works2012 
--Homework 2: This homework will combine almost every materials that we have covered.
-- Question 1
--Return a list of first name, last name and  phone numbers Remember that all records need to have phone numbers
--HINT: Person.Person AND Person.PersonPhone

use [AdventureWorks2012] 

select concat(p.firstname, ' ', p.LastName) as 'full name', ph.PhoneNumber from person.person p
join person.PersonPhone ph
on ph.BusinessEntityID = p.BusinessEntityID
-- Question 2
--Using the same tables from question 1, return the first name, middle name and last name and email
--address, remember that all the names must have email addresses create a derived columns called Full
--name that will concatenated values that includes Title, First Name, Middle Name, Last name. 
--Also include their email addresses. 
--Hint: Person.PersonPhone and Person.EmailAddress

select concat(firstname,' ', middlename, ' ', lastname) as 'full name', emailaddress
from person.person p
join person.EmailAddress e
on p.BusinessEntityID=e.BusinessEntityID
--Question 3
--Please return all the list of phone numbers where the phone number type is "Home" 
--HINT:Person.PersonPhone, Person.PhoneNumberType, WHERE

select ph.phonenumber, pn.name as 'phone number type' 
from person.PersonPhone ph
join person.PhoneNumberType pn
on ph.PhoneNumberTypeID = pn.PhoneNumberTypeID
where pn.name = 'home'

--Question 4
--Retrieve the FirstName, MiddleName, LastName of all the employees. 
--Also create a derived column called LegalName. LegalName is a combination of the FirstName,
--MiddleName and LastName. If the middle name is null replace it with "NA".
--Also create a derived column for the age of all the employees
--HINT: Person.Person, HumanResources.Employee, DATEDIFF(), COALESCE() OR ISNULL()

select concat(p.firstname, isnull(p.middlename, 'NA'), p.lastname) as [Legal Name],
datediff(yy, e.birthdate, getdate()) as [Age]
from person.person p
join HumanResources.Employee e
on p.businessentityid = e.businessentityid

--Question 5
--Using the query from question 3&5, retrieve the FullName, age, PhoneNumber, 
--Address and EmailAddress of all the employees.
--HINT: HumanResources.Employee,Person.Person,Person.PersonPhone,Person.BusinessEntityAddress
--,Person.EmailAddress,DATEDIFF(), COALESCE() OR ISNULL()

select concat (p.firstname, ' ', isnull(p.middlename, 'NA'), ' ', p.lastname) as 'full name'
, datediff(yy, birthdate, getdate()) as Age, pn.phonenumber, pe.emailaddress,
concat(pa.addressline1, ' ', pa.city, ' ',pa.postalcode) as [Full Address] from person.person p
join HumanResources.Employee e
on p.BusinessEntityID = e.BusinessEntityID
join Person.Personphone pn
on p.BusinessEntityID = pn.BusinessEntityID
join Person.BusinessEntityAddress be
on pn.BusinessEntityID = be.BusinessEntityID
join Person.EmailAddress pe
on p.BusinessEntityID=pe.BusinessEntityID
join person.address pa
on be.AddressID = pa.AddressID
---=======================================SUB QUERY QUESTION==========================
--Question 6
--Provide a list of Employees (FirstName , LastName) that have changed departments at least twice
--HINT : HumanResources.Employee ,[HumanResources].[EmployeeDepartmentHistory], 
--Non correlated sub query in WHERE Clause,GROUP BY IN Subquery , 
--HAVING In Subquery, COUNT IN Subquery

Select BusinessEntityID, FirstName, LastName From Person.Person 
Where BusinessEntityID in
(Select BusinessEntityID From 
humanresources.EmployeeDepartmentHistory group by BusinessEntityID
Having Count (BusinessEntityID)>=2)

-- Question 7
--Using JOIN re-Write your the same question from question 6

Select p.FirstName, p.LastName
From Person.Person p 
join humanResources.EmployeeDepartmentHistory H on 
H.BusinessEntityID=p.BusinessEntityID
group by p.FirstName, p.LastName
Having Count (h.BusinessEntityID)>=2

-- Question 8
-- Provide a list of Vendors that supply more than one type of product 
--HINT : [Purchasing].[ProductVendor],[Purchasing].[Vendor], 
--Non correlated sub query in WHERE Clause,GROUP BY IN Subquery , 
--HAVING In Subquery, COUNT IN Subquery

select name, BusinessEntityID
from Purchasing.Vendor p where BusinessEntityID in(
select BusinessEntityID
from Purchasing.ProductVendor
group by BusinessEntityID
having count(productid)>1);

--Question 9:-Re write question 8's query using a JOIN
select  p.[name],v.BusinessEntityID from Purchasing.Vendor p
join Purchasing.ProductVendor v
on p.BusinessEntityID = v.BusinessEntityID 
group by v.BusinessEntityID, p.name
having count(productid) >1

--Question 10
--Provide a list of individual products (Product Name , List Price) 
--that are supplied by different vendors. i.e a single product can be supplied by multiple vendors
--HINT : [Purchasing].[ProductVendor],[Production].[Product], 
--Non correlated sub query in WHERE Clause,GROUP BY IN Subquery , 
--HAVING In Subquery, COUNT DISTINCT IN Subquery

Select Name, Listprice From Production.Product where productid in (select 
distinct productid from Purchasing.ProductVendor group by ProductID)

Select Name, Listprice From Production.Product where productid in (select 
productid from Purchasing.ProductVendor group by BusinessEntityID, productid)

------========================Case statement==========================================
--Question 11
--Return the job title, birthdate, gender, and vacation hours, sick leave hours.
--Write a column that meets the below condition
--   If the salaried Flag is 1 then Employee else contractor
-- If the salaried Flag is 1 then = "Yes Make"
-- Else "contractor"
select jobtitle, birthdate, gender, vacationhours, sickleavehours, 
case when SalariedFlag = 1 then 'Employee'
	else 'contractor'
	end as [salary flag]
from [HumanResources].[Employee]
--Question 12
----RETURN THE [MaritalStatus], [Gender] ,[VacationHours] ,[SickLeaveHours]
----Please create a derived column to indicate when the Marital Status is 
----M to read married and when the 
----Marital Status is S to read single
select MaritalStatus,gender, VacationHours,SickLeaveHours,
	case when MaritalStatus = 'm' then 'maried'
		when MaritalStatus = 's' then 'single'
end as [Marital Status] from [HumanResources].employee
-- Question 13 --
----RETURN THE [MaritalStatus], [Gender] ,[VacationHours] ,[SickLeaveHours]
----Please create a derived column to indicate when the Marital Status is 
----M to read married and when the 
----Marital Status is S to read single
----Also create another derived column that indicate M for Male and F for female
select MaritalStatus,gender, VacationHours,SickLeaveHours,
	case when MaritalStatus = 'm' then 'maried'
		when MaritalStatus = 's' then 'single'
end as [Marital Status],
	case when gender = 'm' then 'male'
		when gender = 'f' then 'female'
end as [Gender]
from [HumanResources].employee
--   Question --14
----RETURN THE [MaritalStatus], [Gender] ,[VacationHours] ,[SickLeaveHours]
----Please create a derived column to indicate when the Marital Status is 
----M and vacation hours is grater than 50 it should read "Go to Vacation" 
----ALSO if the Marital Status is S and the vacation hours is less than
---- 30 it should "you need more hours"  
----Every other category should ready "you are safe"

select MaritalStatus,gender, VacationHours,SickLeaveHours,
	case when MaritalStatus = 'm' and VacationHours > 50 then 'go to Vacation'
		when MaritalStatus = 's' and VacationHours < 30 then 'you need more hours'
		else 'you are safe'
end as [vaction hour with gender]
from [HumanResources].employee                 
----====================================OTHER MATERIALS==========================================
--Question 15. 
--Your manager wants you to return vendor's account numbers but he wants you to make sure each vendor
-- account number needs to be 20 characters. 
--Please add the applicable number of Zeroes to the beginning of the account numbers to make it up to
-- 20 characters
-- HINT : LEN,REPLICATE,CONCAT,[Purchasing].[Vendor]

select BusinessEntityID, case when LEN(accountNumber)>=20 then accountNumber
else concat(REPLICATE('0',20-LEN(accountNumber)),accountNumber) end
as accountNumber from Purchasing.Vendor
--Question 16. 
--You manager want you to retune the name of all the vendors
--and then write him a derived column that will remove the following special characters 
--from the Name column: periods,Commas,&,and spaces
--HINT : REPLACE (NESTED),[Purchasing].[Vendor]
select name,  REPLACE (REPLACE (REPLACE(name, ',', ''), '.', ''), ' ', '') [derived name] 
from Purchasing.Vendor;

--Question 17. 
--What is the difference between VARCHAR and NVARCHAR datatypes? 

--varchar is stored data at 1 byte per character and nvarchar stores at 2 bytes per character.
--therefore nvarchar takes double the space as SQL varchar.
  
--  - Question 18
--You web applicated team want to generate a unique ID for each customer the customer
--in the system and you are asked to write a SQL query that will generate a
--unique ID based on the following fields and condition:
--     :first 3 character of the [PersonID]
--	 :last two characters of the [StoreID]
--	 :[TerritoryID] but replacing the first 3 values with with the word "21a,
--	 :and the [AccountNumber]
--      Use  the concat function, substring, replicate, replace and maybe more
--	   to achieve this task
--    HINT : CONCAT(),[Sales].[Customer]
select * from sales.Customer

select substring (StoreID, 1, 3) from sales.Customer;

SELECT SUBSTRING(personid, LEN(personid)-2, 3) from sales.Customer

SELECT SUBSTRING(storeid, LEN(storeid)-2, 3) from sales.Customer

SELECT CHARINDEX('aw', AccountNumber) from sales.Customer;  

--QUESTION 19. 
--    Convert all Last name values to Upper Case
--	Convert all First name values to lower case
--  HINT : UPPER(),LOWER(),[Person].[Person]
select  lower(firstname) as firstname, upper(lastname) as lastname from person.Person
--Question 20
--Please return the year of the modified data 
--HINT:YEAR(), [Person].[Person]

select year(ModifiedDate) as 'modifed year' from person.Person
select datename(yy, modifieddate) as 'modifed year' from person.Person

--Question 21
--Using answer from question 18 please return the month of the modified data 
--HINT:MONTH(), [Person].[Person]

select month(ModifiedDate) as 'modifed month' from person.Person
select datename(mm, modifieddate) as 'modifed month' from person.Person

--Question 22
--Please return the job title, birth date, and modified date
--also write a derived column called DayDiff that return the difference in DAY between the 
--birthdate and modified date 
--HINT: HumanResources.Employee, DAY()

select JobTitle,BirthDate,ModifiedDate, datediff(dd, birthdate, ModifiedDate) as DayDiff
from HumanResources.Employee

--Question 23
--Using you answer from question 20 write a derived column called MonthDiff that return the 
--difference in MONTH between the 
--birthdate and modified date
--HINT: HumanResources.Employee, MONTH()

select JobTitle,BirthDate,ModifiedDate, datediff(mm, birthdate, ModifiedDate) as MonthDiff
from HumanResources.Employee


--Question 24
-- --SUBSTRING Function  --  using 'JONATHAN'
--Example =  SELECT SUBSTRING('JONATHAN',1,3) --  Produce JON
--using 'JONATHAN' -- Produce NATHAN
--using 'JONATHAN' -- Produce HAN
--using 'JONATHAN' -- Produce JONA

SELECT SUBSTRING('JONATHAN', -6, 6)
SELECT SUBSTRING('JONATHAN',-3,3)
SELECT SUBSTRING('JONATHAN',1,4)

-- Question 25
----USING The CHARINDEX Function  ---using 'UNITED STATES'
--  'UNITED STATES' --RETURNS 7
--  'UNITED STATES'--RETURNS 8
--   'UNITED STATES'--RETURNS 12
--   'UNITED STATES' -- RETURNS 4

SELECT CHARINDEX(' ', 'united states');
SELECT CHARINDEX('s', 'united states');
SELECT CHARINDEX('e', 'united states', 8);
SELECT CHARINDEX('e', 'united states', 10);
SELECT CHARINDEX('t', 'united states');

-- Question 26
---- --USING THE UPPER and LOWER Functions
-- ---- UPPER --- 'together everyone achives more'
------- UPPER --- 'the harder you work for something, the greater you will feel when you achieve it'
-- --- - LOWER ----'THIS IS A REALLY GOOD CLASS'

select upper('together everyone achives more') [upper],
upper('the harder you work for something, the greater you will feel when you achieve it') [upper], 
lower('THIS IS A REALLY GOOD CLASS') [lower]

--Question 27
--Write derived column labeled last4_Card that return the last 4 credit
--card number but masked the rest numbers with *. Please mask with a total
--of 10 * 
select cardnumber, stuff(cardnumber, 11, 4, '****') as [masked number]
from [Sales].[CreditCard]

SELECT cardnumber, Concat(replicate('*',10),right(cardnumber,4)) from [Sales].[CreditCard]

--Question 28
--name column 
--Table: [Sales].[CreditCard]
--HINT: RIGHT, REPLICATE
--SEE SAMPLE OUTPUT BELOW
--CardNumber			last4_Card
--11111000471254		**********1254
--11111002034157		**********4157
--11111005230447		**********0447
--...					...
--...					...
--...					...
--11111007955171		**********5171
--11111009772675		**********2675
--11111016029803		**********9803
--11111016740421		**********0421
--11111017091860		**********1860
--11111017448906		**********8906
--11111018232698		**********2698
--
SELECT cardnumber, Concat(replicate('*',10),Right(cardnumber,4)) from [Sales].[CreditCard]

--Question 29
--Write derived column labeled @_Location that return the the position 
--of the @ sign in the emailaddress column
--Table: [Person].[EmailAddress]
--HINT: CHARINDEX
--SEE SAMPLE OUTPUT BELOW
--EmailAddress					@_Location
--a0@adventure-works.com				3
--a1@adventure-works.com				3
--aaron0@adventure-works.com			7
--aaron1@adventure-works.com			7
--...									...
--...									...
--...									...
--aaron10@adventure-works.com			8
--aaron11@adventure-works.com			8
--aaron12@adventure-works.com			8

SELECT emailaddress ,CHARINDEX('@',emailaddress) AS Location_@
FROM [Person].[EmailAddress]

-- 4. 
--Using answer from question 3. Remember that you have to get 3 right 
--to get 4 right. 
--Write a derived column labeled dotCome that will find the position of 
--the "." in the @_Location column
--Table: [Person].[EmailAddress]
--HINT: CHARINDEX
--SEE SAMPLE OUTPUT BELOW
--EmailAddress					@_Location		dotCome
--a0@adventure-works.com				3			19
--a1@adventure-works.com				3			19
--aaron0@adventure-works.com			7			23
--aaron1@adventure-works.com			7			23
--...									...			...
--...									...			...
--...									...			...
--aaron10@adventure-works.com			8			24
--aaron11@adventure-works.com			8			24
--aaron12@adventure-works.com			8			24

SELECT emailaddress ,CHARINDEX('@', EmailAddress) AS [@_Location], CHARINDEX('.', EmailAddress)
as dotCome FROM [Person].[EmailAddress]

--Question 30
--Using answer from question 4. Remember that you have to get 4 right 
--to get 5 right. 
--Write a derived column labeled gov that replace the com in the email Address column 
--with gov
--Table: [Person].[EmailAddress]
--HINT: REPLACE
--SEE SAMPLE OUTPUT BELOW
--EmailAddress					@_Location		dotCome		gov
--a0@adventure-works.com				3			19			a0@adventure-works.gov
--a1@adventure-works.com				3			19			a1@adventure-works.gov
--aaron0@adventure-works.com			7			23			aaron0@adventure-works.gov
--aaron1@adventure-works.com			7			23			aaron1@adventure-works.gov
--...									...			...
--...									...			...
--...									...			...
--aaron10@adventure-works.com			8			24			aaron10@adventure-works.gov
--aaron11@adventure-works.com			8			24			aaron11@adventure-works.gov
--aaron12@adventure-works.com			8			24			aaron11@adventure-works.gov

SELECT emailaddress ,CHARINDEX('@', EmailAddress) AS [@_Location], CHARINDEX('.', EmailAddress)
as dotCome, replace(emailaddress, 'com', 'gov') as Gov
FROM [Person].[EmailAddress]

--Question 31    . BONUS QUESTION
--Using answer from question 5. To do this you have to 
--get all steps correct  
--Write a derived column labeled replaceWith$ that replaceS ALL the email
--address with a dollar sign
--Table: [Person].[EmailAddress]
--HINT: REPLACE,CHARINDEX, LEFT, REPLICATE
--SEE SAMPLE OUTPUT BELOW
--EmailAddress					@_Location		dotCome		gov								replaceWith$
--a0@adventure-works.com				3			19			a0@adventure-works.gov			$$$$$$$$$$$$$$$$$$$.com
--a1@adventure-works.com				3			19			a1@adventure-works.gov			$$$$$$$$$$$$$$$$$$$.com
--aaron0@adventure-works.com			7			23			aaron0@adventure-works.gov		$$$$$$$$$$$$$$$$$$$$$$$.com
--aaron1@adventure-works.com			7			23			aaron1@adventure-works.gov		$$$$$$$$$$$$$$$$$$$$$$$.com
--...									...			...
--...									...			...
--...									...			...
--aaron10@adventure-works.com			8			24			aaron10@adventure-works.gov		$$$$$$$$$$$$$$$$$$$$$$$$.com
--aaron11@adventure-works.com			8			24			aaron11@adventure-works.gov		$$$$$$$$$$$$$$$$$$$$$$$$.com
--aaron12@adventure-works.com			8			24			aaron11@adventure-works.gov		$$$$$$$$$$$$$$$$$$$$$$$$.com

SELECT emailaddress ,CHARINDEX('@', EmailAddress) AS [@_Location],
CHARINDEX('.', EmailAddress) as dotCome, replace(emailaddress, 'com', 'gov') as Gov,
Concat(replicate('$',10),Right(emailaddress,4)) as replaceWith$
FROM [Person].[EmailAddress]




