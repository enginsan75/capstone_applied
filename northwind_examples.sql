use northwind;

ALTER TABLE Customers 
RENAME COLUMN ContactName TO CustomerName;

ALTER TABLE Shippers 
RENAME COLUMN CompanyName TO ShipperName;

SELECT DISTINCT Country FROM Customers;

SELECT COUNT(DISTINCT Country) FROM Customers;


SELECT * FROM Customers
WHERE CustomerID = 'ALFKI';

SELECT * FROM Customers
WHERE NOT Country = 'Germany';

SELECT * FROM Customers
WHERE Country = 'Germany' AND City = 'Berlin';

SELECT * FROM Customers
WHERE City = 'Berlin' OR City = 'Stuttgart';

SELECT * FROM Customers
WHERE Country = 'Germany' AND (City = 'Berlin' OR City = 'Stuttgart');

SELECT * FROM Customers
WHERE NOT Country = 'Germany' AND NOT Country = 'USA';

SELECT * FROM Customers
ORDER BY Country DESC;

# DESC ordering in strings alphabetically goes from Z to A..

SELECT * FROM Customers
ORDER BY Country, CustomerName;

SELECT * FROM Customers
ORDER BY Country ASC, CustomerName DESC;

#INSERT INTO Customers (CustomerName, City, Country)
#VALUES ('Cardinal', 'Stavanger', 'Norway');

SELECT CustomerName, Address, City 
FROM Customers
WHERE Address IS NULL;

SELECT CustomerName, Address, City 
FROM Customers
WHERE Address IS not NULL;

UPDATE Customers
SET PostalCode = 00000
WHERE Country = 'Mexico';

DELETE FROM Customers WHERE CustomerName='Alfreds Futterkiste';

SELECT * FROM Customers
WHERE Country='Germany'
LIMIT 3;

ALTER TABLE Products 
RENAME COLUMN UnitPrice TO Price;

SELECT MIN(Price) AS SmallestPrice
FROM Products;

SELECT MAX(Price) AS LargestPrice
FROM Products;

SELECT COUNT(ProductID)
FROM Products;

SELECT AVG(Price)
FROM Products;

RENAME TABLE northwind.`Order Details` TO OrderDetails;

SELECT SUM(Quantity)
FROM OrderDetails;

/*WHERE CustomerName LIKE 'a%'	Finds any values that start with "a"
WHERE CustomerName LIKE '%a'	Finds any values that end with "a"
WHERE CustomerName LIKE '%or%'	Finds any values that have "or" in any position
WHERE CustomerName LIKE '_r%'	Finds any values that have "r" in the second position
WHERE CustomerName LIKE 'a_%'	Finds any values that start with "a" and are at least 2 characters in length
WHERE CustomerName LIKE 'a__%'	Finds any values that start with "a" and are at least 3 characters in length
WHERE ContactName LIKE 'a%o'	Finds any values that start with "a" and ends with "o"*/

SELECT * FROM Customers
WHERE CustomerName LIKE 'a%';
--customer name starts with a...

SELECT * FROM Customers
WHERE CustomerName LIKE '%or%';

--all customers with a CustomerName that have "or" in any position:

SELECT * FROM Customers
WHERE CustomerName LIKE 'a__%';

--all customers with a CustomerName that starts with "a" and are at least 3 characters in length:

SELECT * FROM Customers
WHERE CustomerName LIKE 'a%o';

SELECT * FROM Customers
WHERE City LIKE 'ber%';

SELECT * FROM Customers
WHERE City LIKE '_ondon';

--WHERE CustomerName LIKE '_r%'	Finds any values that have "r" in the second position


--The IN operator allows you to specify multiple values in a WHERE clause.

--The IN operator is a shorthand for multiple OR conditions.

SELECT * FROM Customers
WHERE Country NOT IN ('Germany', 'France', 'UK');

SELECT * FROM Customers
WHERE Country IN (SELECT Country FROM Suppliers);

--The SQL statement selects all customers that are from the same countries as the suppliers:

SELECT * FROM Products
WHERE Price BETWEEN 10 AND 20
AND CategoryID NOT IN (1,2,3);


SELECT * FROM Products
WHERE ProductName BETWEEN 'Carnarvon Tigers' AND 'Mozzarella di Giovanni'
ORDER BY ProductName;

SELECT * FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31';

SELECT CustomerName, CONCAT_WS(', ', Address, PostalCode, City, Country) AS Address
FROM Customers;

SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Customers AS c, Orders AS o
WHERE c.CustomerName='Maria Anders' AND c.CustomerID=o.CustomerID;


/*#INNER JOIN: Returns records that have matching values in both tables
#LEFT JOIN: Returns all records from the left table, and the matched records from the right table
#RIGHT JOIN: Returns all records from the right table, and the matched records from the left table
#CROSS JOIN: Returns all records from both tables*/


SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

SELECT Orders.OrderID, Customers.CustomerName, Shippers.ShipperName
FROM ((Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID)
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID);

SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
ORDER BY Customers.CustomerName;

/*The LEFT JOIN keyword returns all records from the left table (Customers), 
#even if there are no matches in the right table (Orders).*/

SELECT Orders.OrderID, Employees.LastName, Employees.FirstName
FROM Orders
RIGHT JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
ORDER BY Orders.OrderID;

--The RIGHT JOIN keyword returns all records from the right table (Employees), 
--even if there are no matches in the left table (Orders)

SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
CROSS JOIN Orders;

/*#The CROSS JOIN keyword returns all matching records 
#from both tables whether the other table matches or not. So, 
#if there are rows in "Customers" that do not have matches in "Orders", 
#or if there are rows in "Orders" that do not have matches in "Customers", 
#those rows will be listed as well.

#If you add a WHERE clause (if table1 and table2 has a relationship), 
#the CROSS JOIN will produce the same result as the INNER JOIN clause:*/

SELECT A.CustomerName AS CustomerName1, B.CustomerName AS CustomerName2, A.City
FROM Customers A, Customers B
WHERE A.CustomerID <> B.CustomerID
AND A.City = B.City
ORDER BY A.City;

SELECT City FROM Customers
UNION
SELECT City FROM Suppliers
ORDER BY City;

--UNION selects only distinct values. Use UNION ALL to also select duplicate values!

SELECT City FROM Customers
UNION ALL
SELECT City FROM Suppliers
ORDER BY City;

SELECT City, Country FROM Customers
WHERE Country='Germany'
UNION
SELECT City, Country FROM Suppliers
WHERE Country='Germany'
ORDER BY City;

SELECT 'Customer' AS Type, CompanyName, City, Country
FROM Customers
UNION
SELECT 'Supplier', CompanyName, City, Country
FROM Suppliers;

SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
ORDER BY COUNT(CustomerID) DESC;

SELECT Shippers.ShipperName, COUNT(Orders.OrderID) AS NumberOfOrders FROM Orders
LEFT JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
GROUP BY ShipperName;


--#The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggrega

SELECT COUNT(CustomerID), Country
FROM Customers
GROUP BY Country
HAVING COUNT(CustomerID) > 5;


SELECT Employees.LastName, COUNT(Orders.OrderID) AS NumberOfOrders
FROM (Orders
INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID)
GROUP BY LastName
HAVING COUNT(Orders.OrderID) > 10;

/*#The EXISTS operator is used to test for the existence of any record in a subquery.

#The EXISTS operator returns TRUE if the subquery returns one or more records.*/


SELECT CompanyName
FROM Suppliers
WHERE EXISTS 
(SELECT ProductName FROM Products 
WHERE Products.SupplierID = Suppliers.supplierID AND Price > 22);

/*The ANY and ALL operators allow you to perform a comparison 
#between a single column value and a range of other values*/

SELECT ProductName
FROM Products
WHERE ProductID = ANY
(SELECT ProductID
FROM OrderDetails
WHERE Quantity = 10);

/*#The SQL statement lists the ProductName 
#if it finds ANY records in the OrderDetails table has Quantity equal to 
#10 (this will return TRUE because the Quantity column has some values of 10):*/

SELECT ProductName
FROM Products
WHERE ProductID = ALL
  (SELECT ProductID
  FROM OrderDetails
  WHERE Quantity = 10);

/*#The SQL statement lists the ProductName 
#if ALL the records in the OrderDetails table has 
#Quantity equal to 10. This will of course return FALSE because the Quantity 
#column has many different values (not only the value of 10):*/
 

 
/*#The INSERT INTO SELECT statement copies data from one table and inserts it into another table.

#The INSERT INTO SELECT statement requires that the data types in source and target tables matches.

#Note: The existing records in the target table are unaffected.*/


INSERT INTO Employees (City, Country)
SELECT City, Country FROM Suppliers
WHERE Country='Germany';

--make it some column properties NOT NULL before inserting....


SELECT OrderID, Quantity,
CASE
    WHEN Quantity > 30 THEN 'The quantity is greater than 30'
    WHEN Quantity = 30 THEN 'The quantity is 30'
    ELSE 'The quantity is under 30'
END AS QuantityText
FROM OrderDetails;

--Case results are given in the 3.column as QuantityText...


SELECT ProductName, Price * (UnitsInStock + IFNULL(UnitsOnOrder, 0))
FROM Products;

--IFNULL() function lets you return an alternative value if an expression is NULL.

The example abovereturns 0 if the value is NULL

SELECT ProductName, Price * (UnitsInStock + COALESCE(UnitsOnOrder, 0))
FROM Products;

--IFNULL() =COALESCE() 

-- Select all:
SELECT * FROM Customers;


/*SQL constraints are used to specify rules for the data in a table.

Constraints are used to limit the type of data that can go into a table. This ensures the accuracy and reliability of the data in the table. If there is any violation between the constraint and the data action, the action is aborted.

Constraints can be column level or table level. Column level constraints apply to a column, and table level constraints apply to the whole table.

The following constraints are commonly used in SQL:

NOT NULL - Ensures that a column cannot have a NULL value
UNIQUE - Ensures that all values in a column are different
PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
FOREIGN KEY - Prevents actions that would destroy links between tables
CHECK - Ensures that the values in a column satisfies a specific condition
DEFAULT - Sets a default value for a column if no value is specified
CREATE INDEX - Used to create and retrieve data from the database very quickly*/


CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255) NOT NULL,
    Age int
);

ALTER TABLE Persons
MODIFY Age int NOT NULL;

-- Alter table with modify you can change properties of an existing table...

DROP TABLE Persons;
CREATE TABLE Persons (
    PersonID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    UNIQUE (PersonID)
);

-- To name a UNIQUE constraint, and to define a UNIQUE constraint on multiple columns, use the following SQL syntax:

DROP TABLE Persons2;
CREATE TABLE Persons2 (
    PersonID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    CONSTRAINT UC_Persons2 UNIQUE (ID,LastName)
);

ALTER TABLE Persons2
DROP INDEX UC_Persons2;


/*The FOREIGN KEY constraint is used to prevent actions that would destroy links between tables.

A FOREIGN KEY is a field (or collection of fields) in one table, that refers to the PRIMARY KEY in another table.

The table with the foreign key is called the child table, 
and the table with the primary key is called the referenced or parent table.*/


INSERT INTO Persons (PersonID, LastName , FirstName, Age)
VALUES ('1', 'Hansen', 'Ola', '30');

INSERT INTO Persons (PersonID, LastName , FirstName, Age)
VALUES ('2', 'Svendson', 'Tobe', '23');

INSERT INTO Persons (PersonID, LastName , FirstName, Age)
VALUES ('3', 'Petersen', 'Kari', '20');

/*UPDATE Persons 
SET LastName = 'Svendson', FirstName  = 'Tobe', Age='23'
WHERE ID = 2;*/

ALTER TABLE Persons
ADD PRIMARY KEY (PersonID);


CREATE TABLE Orders2 (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    PersonID int NOT NULL,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)
);


INSERT INTO Orders2 (OrderID, OrderNumber, PersonID)
VALUES ('1', '77895', '3');

INSERT INTO Orders2 (OrderID, OrderNumber, PersonID)
VALUES ('2', '44678', '3');

INSERT INTO Orders2 (OrderID, OrderNumber, PersonID)
VALUES ('3', '22456', '2');

INSERT INTO Orders2 (OrderID, OrderNumber, PersonID)
VALUES ('4', '22562', '1');

SELECT OrderNumber, LastName
FROM Orders2, Persons;

-- UPDATE Orders2 (Parent Table)
UPDATE Orders2 
SET OrderNumber = '22457'
WHERE OrderID = 2;

INSERT INTO Orders2 (OrderID, OrderNumber, PersonID)
VALUES ('5', '22700', '5');

-- it gives error when entering new data to parent table because child table referenced PersonID

CREATE TABLE Persons3 (
    PersonID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    Check  (Age >=18)
);

-- CHECK constraint ensures that the age of a person must be 18, or older

/*The CREATE INDEX statement is used to create indexes in tables.

Indexes are used to retrieve data from the database more quickly than otherwise. 
The users cannot see the indexes, they are just used to speed up searches/queries.*/

CREATE INDEX idx_lastname
ON Persons (LastName);

CREATE UNIQUE INDEX idx_firstname
ON Persons (FirstName);


/*MySQL comes with the following data types for storing a date or a date/time value in the database:

DATE - format YYYY-MM-DD
DATETIME - format: YYYY-MM-DD HH:MI:SS
TIMESTAMP - format: YYYY-MM-DD HH:MI:SS
YEAR - format YYYY or YY
Note: The date data type are set for a column when you create a new table in your database!*/



/*In SQL, a view is a virtual table based on the result-set of an SQL statement.

A view contains rows and columns, just like a real table. 
The fields in a view are fields from one or more real tables in the database.

You can add SQL statements and functions to a view and 
present the data as if the data were coming from one single table.

A view is created with the CREATE VIEW statement.*/

CREATE VIEW Report_Shippers AS
SELECT Shippers.ShipperName, COUNT(Orders.OrderID) AS NumberOfOrders FROM Orders
LEFT JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID
GROUP BY ShipperName;

SELECT * from Report_Shippers rs;

-- Views can provide advantages over tables:

/*Views can represent a subset of the data contained in a table
Views can join and simplify multiple tables into a single virtual table
Views can act as aggregated tables, where the database engine aggregates data (sum, average etc) and presents the calculated results as part of the data
Views can hide the complexity of data; for example a view could appear as Sales2000 or Sales2001, transparently partitioning the actual underlying table
Views take very little space to store; the database contains only the definition of a view, not a copy of all the data it presents
Depending on the SQL engine used, views can provide extra security
Views can limit the degree of exposure of a table or tables to the outer world*/







