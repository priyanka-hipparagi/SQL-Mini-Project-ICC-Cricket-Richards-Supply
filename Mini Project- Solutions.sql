-- Creating the Database for the mini project.
CREATE DATABASE mini_project;
USE mini_project;
/* Ensuring that DML statement queries are allowed to execute */ 
SET SQL_SAFE_UPDATES=0;

####################################### PART A #######################################
# Task 1: Import the csv file to a table in the database.
/* The CSV file is imported by right-clicking on the database in the Schemas window of the
Navigator pane and selecting 'Table Data Import Wizard'. After that the required csv file,
which in this case is 'ICC Test Batting Figures (1).csv' is to be selected. Now Destination
database and table are to be selected. After all selections, data is imported. */
SHOW TABLES;
DESC `icc test batting figures`;

# Task 2: Remove the column 'Player Profile' from the table.
/* A simple Alter DDL Comand would help drop the column 'Player Profile'. */
ALTER TABLE
	`icc test batting figures`
DROP COLUMN
	`Player Profile`;
DESC `icc test batting`;

# Task 3:  Extract the country name and player names from the given data and
# store it in seperate columns for further usage.
/* In order to do the task, we would need to firstly create the new columns in the table.
After that, an update statement would add values to these columns.
The Player Name column can be populated by taking the string from the beginning till
one space before the opening paranthesis('(').
The Country column can be populated by obtaining the string between the opening
paranthesis ('(') and the closing paranthesis (')')  */
-- Alter statement to add new columns.
ALTER TABLE
	`icc test batting figures`
ADD COLUMN
	`Player Name` varchar(30),
ADD COLUMN
	`Country` varchar(20);
DESC `icc test batting figures`;
-- Updating all values in columns as needed.
UPDATE `icc test batting figures`
SET
	`Player Name` = SUBSTRING(Player, 1, position('(' in Player) - 2),
	Country = substr(Player, position('(' in Player) + 1, length(Player) - position('(' in Player) - 2);
SELECT
	*
FROM
	`icc test batting figures`;

# Task 4: From the column 'Span' extract the start_year and end_year 
# and store them in seperate columns for further usage.
/* In order to do the task, we would need to firstly create the new columns in the table.
After that, an update statement would add values to these columns.
The start_year column can be populated by taking the first 4 characters from the Span string.
The end_year column can be populated by obtaining the lst 4 characters from the Span string. */
-- Alter statement to add new columns.
ALTER TABLE
	`icc test batting figures`
ADD COLUMN
	start_year INT,
ADD COLUMN
	end_year INT;
DESC `icc test batting figures`;
-- Updating all values in columns as needed.
UPDATE `icc test batting figures`
SET
	start_year = SUBSTRING(Span, 1, 4),
	end_year = SUBSTRING(Span, 6, 4);
SELECT
	*
FROM
	`icc test batting figures`;

# Task 5:  The column 'HS' has the highest score scored by the player so far in any given match.
# The column also has details if the player had completed the match in a NOT OUT status.
# Extract the data and store the highest runs and the NOT OUT status in different columns.
/* In order to do the task, we would need to firstly create the new columns in the table.
After that, an update statement would add values to these columns.
The Highest run column can be populated by taking the string that comes before the '*' delimeter
in the HS string.
The `NOT OUT` column can be populated by implementing the logic that if the HS string ends with
a '*' symbol, then it is a Not Out, otherwise it is an Out. */
-- Alter statement to add new columns.
ALTER TABLE
	`icc test batting figures`
ADD COLUMN
	`Highest run` INT,
ADD COLUMN
	`NOT OUT` varchar(3);
DESC `icc test batting figures`;
-- Updating all values in columns as needed.
UPDATE `icc test batting figures`
SET
	`Highest run` = SUBSTRING_INDEX(HS, '*', 1),
    `NOT OUT` = IF(POSITION('*' in HS) = 0, 'No', 'Yes');	
SELECT
	*
FROM
	`icc test batting figures`;

# Task 6: Using the data given, considering the players who were active in the year of 2019,
# create a set of batting order of best 6 players using the selection criteria of those
# who have a good average score across all matches for India.
/* Here, we are to simply order the batting order according to the Avg score. The good scores
would be greater in value, so the order would have to be descending. We are provided a condition that
the players are active in 2019, so this would go into the WHERE clause. Also, we require only the
best 6 players. We thus have to use the LIMIT clause.
*/
SELECT
	`Player Name`, Avg
FROM
	`icc test batting figures`
WHERE
	end_year = 2019
ORDER BY Avg DESC
LIMIT 6;

# Task 7: Using the data given, considering the players who were active in the year of 2019,
# create a set of batting order of best 6 players using the selection criteria of 
# those who have highest number of 100s across all matches for India.
/* Here, we are to simply order the batting order according to the number of 100s. A greater
occurence of 100s would be expected of a great player, so the order would have to be descending.
We are provided the conditions that the players are active in 2019 and belong to India, so these
would go into the WHERE clause. Also, we require only the best 6 players. We thus have to use 
the LIMIT clause.
*/
SELECT
	`Player Name`, `100`
FROM
	`icc test batting figures`
WHERE
	end_year = 2019 AND Country LIKE '%INDIA%'
ORDER BY `100` DESC
LIMIT 6;

# Task 8: Using the data given, considering the players who were active in the year of 2019,
# create a set of batting order of best 6 players using 2 selection criterias of your own for India.
/* Here, we are to firstly order the batting order according to the number of 100s, followed by the 
average score. A greater occurence of 100s would be expected of a great player, so the 100s order would
have to be descending. Also, The good scores would be greater in value, so the average score order would
have to be descending.
We are provided the conditions that the players are active in 2019 and belong to India, so these
would go into the WHERE clause. Also, we require only the best 6 players. We thus have to use 
the LIMIT clause.
*/
SELECT
	`Player Name`,
    `100`,
    Avg
FROM
	`icc test batting figures`
WHERE end_year = 2019 AND Country LIKE '%INDIA%'
ORDER BY `100` DESC, Avg DESC
LIMIT 6;

# Task 9: Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players
# who were active in the year of 2019, create a set of battingorder of best 6 players using the selection
# criteria of those who have a good average score across all matches for South Africa.
/* Here, we are to simply order the batting order according to the Avg score. The good scores
would be greater in value, so the order would have to be descending. We are provided the conditions
that the players are active in 2019 and are also belonging to South Africa, so this would go into 
the WHERE clause. Also, we require only the best 6 players. We thus have to use the LIMIT clause. */
CREATE VIEW Batting_Order_GoodAvgScorers_SA
	AS
SELECT
	`Player name`,
    Avg
FROM
	`icc test batting figures`
WHERE end_year = 2019 AND (Country = 'SA' OR Country = 'ICC/SA')
ORDER BY Avg DESC
LIMIT 6;
SELECT
	*
FROM
	Batting_Order_GoodAvgScorers_SA;

# Task 10: Create a View named‘Batting_Order_HighestCenturyScorers_SA’ using the data given, considering
# the players who were active in the year of 2019, create a set of batting order of best 6 players
# using the selection criteria of those who have highest number of 100s across all matches for South Africa.
/* Here, we are to simply order the batting order according to the number of 100s. A greater
occurence of 100s would be expected of a great player, so the order would have to be descending.
We are provided the conditions that the players are active in 2019 and belong to South Africa, so these
would go into the WHERE clause. Also, we require only the best 6 players. We thus have to use 
the LIMIT clause.*/
CREATE VIEW Batting_Order_HighestCenturyScorers_SA
	AS
SELECT
	`Player name`,
    `100`
FROM
	`icc test batting figures`
WHERE end_year = 2019 and (Country = 'SA' or Country = 'ICC/SA')
ORDER BY `100` DESC
LIMIT 6;
SELECT
	*
FROM
	Batting_Order_HighestCenturyScorers_SA;

-- Task 11: Using the data given, Give the number of player_played for each country.
/* Here a simple GROUP BY clause is used by country, and the aggregate clause COUNT is
implemented to obtain the count of the players playing for each country*/
SELECT
	Country,
    COUNT(*) players_played
FROM
	`icc test batting figures`
GROUP BY
	Country;
    
-- Task 12: Using the data given, Give the number of player_played for Asian and Non-Asian continent.
/* Here, we are classifying players as belonging to the Asian or Non-Asian continent depending on
whether where each known Asian country string is found in the Country string. Finally, players are
grouped by whether they are Asian or not and finding the count of players using the COUNT
aggregate clause.*/
SELECT
	CASE
		WHEN Country LIKE '%INDIA%' OR Country LIKE '%PAK%' OR Country LIKE '%AFG%' OR Country LIKE '%SL%' OR Country LIKE '%BDESH%'
			THEN 'Asian'
		ELSE 'Non-Asian'
	END `Asian/Non-Asian`,
    COUNT(*)
FROM
	`icc test batting figures`
GROUP BY
	`Asian/Non-Asian`;
    
####################################### PART B #######################################
USE supply_chain;
# Task 1: Company sells the product at different discounted rates. 
# Refer actual product price in product table and selling price in the order item table. 
# Write a query to find out total amount saved in each order then display the orders from 
# highest to lowest amount saved.
/* The amount saved is obtained by subtracting the actual product total price, which is obtained by
multiplying the actual product price per unit into the quantity, from the total selling price, which
is obtained by multiplying selling price per unit into quantity. To get the amount saved per order
of a product need to be summed up. */
SELECT ProductName, SUM(total_discount_amt) `Amount Saved`
	FROM 
(
SELECT ProductName, P.UnitPrice*Quantity - OI.UnitPrice*Quantity total_discount_amt
  FROM product P JOIN orderitem OI ON P.Id = OI.ProductId 
  ) Discount
  GROUP BY ProductName ORDER BY `Amount Saved` DESC;

# Task 2: Mr. Kavin want to become a supplier.
# He got the database of "Richard's Supply" for reference. Help him to pick:
# a. List few products that he should choose based on demand.
/* Demand is directly proportional to the quantity ordered. So, here we find the total quantity ordered
for each product and order this quantity in decreasing order and limit till the top products needed. */
-- Let us find the top 10 products based on demand.
SELECT
	ProductName
FROM
	(SELECT
		P.ProductName,
		SUM(OI.Quantity) `Total quantity`
	FROM
		OrderItem OI
			INNER JOIN
		Product P
		ON P.Id = OI.ProductId
	GROUP BY P.ProductName
	ORDER BY `Total quantity` DESC
	LIMIT 10) ProductQuantity;
/* Mr. Kavin should choose these 10 products which are in high demand. */
# b. Who will be the competitors for him for the products suggested in above questions.
/*The companies that manufacture the products that are in high demand in the greatest quantities
would be Mr. Kavin's competitors.*/
SELECT
	DISTINCT(CompanyName)
FROM
	Supplier S
		JOIN
	Product P ON S.Id = P.SupplierId
 WHERE
	ProductName IN (
		SELECT
			ProductName
		FROM(
			SELECT
				ProductName,
                SUM(Quantity) `Total quantity`
			FROM
				OrderItem OI
					JOIN
				Product P
                ON P.Id = OI.ProductId 
			GROUP BY ProductName
            ORDER BY `Total quantity` DESC
            LIMIT 10
            ) Demand
			)
	LIMIT 5;
/*These five companies would be Mr. Kavin's competitors. */
# Task 3: Create a combined list to display customers and suppliers details
# considering the following criteria
/* A combined list is queried that displays customers and suppliers details. Then,
each condition is applied as required to get the suitable data. */
# •	Both customer and supplier belong to the same country
SELECT
	*
FROM
	(
	SELECT  
		CustomerId,
        CONCAT(FirstName,' ',LastName) cust_name,
        C.City cust_city, 
		C.Country cust_country, 
        ContactName,
        CompanyName,
        S.City supp_city,
        S.Country supp_country
	FROM
		customer C
			JOIN
		orders O
        ON C.Id = O.CustomerId
			JOIN
		orderitem OI
        ON OI.OrderId = O.Id
			JOIN
		product P
        ON OI.ProductId = P.Id
			JOIN
		supplier S
        ON S.Id = P.SupplierId) Combined_List
WHERE
	cust_name<>ContactName AND cust_city=supp_city;

# •	Customer who does not have supplier in their country
SELECT
	*
FROM
	(
	SELECT  
		CustomerId,
        CONCAT(FirstName,' ',LastName) cust_name,
        C.City cust_city, 
		C.Country cust_country, 
        ContactName,
        CompanyName,
        S.City supp_city,
        S.Country supp_country
	FROM
		customer C
			JOIN
		orders O
        ON C.Id = O.CustomerId
			JOIN
		orderitem OI
        ON OI.OrderId = O.Id
			JOIN
		product P
        ON OI.ProductId = P.Id
			JOIN
		supplier S
        ON S.Id = P.SupplierId) Combined_List
WHERE
	cust_country<>supp_country;

# •	Supplier who does not have customer in their country
SELECT
	*
FROM
	(
	SELECT  
		CustomerId,
        CONCAT(FirstName,' ',LastName) cust_name,
        C.City cust_city, 
		C.Country cust_country, 
        ContactName,
        CompanyName,
        S.City supp_city,
        S.Country supp_country
	FROM
		customer C
			JOIN
		orders O
        ON C.Id = O.CustomerId
			JOIN
		orderitem OI
        ON OI.OrderId = O.Id
			JOIN
		product P
        ON OI.ProductId = P.Id
			JOIN
		supplier S
        ON S.Id = P.SupplierId) Combined_List
WHERE
	cust_country<>supp_country;

# Task 4: Every supplier supplies specific products to the customers.
# Create a view of suppliers and total sales made by their products and write a query on this 
# view to find out top 2 suppliers (using windows function RANK() in each country
# by total sales done by the products.
/* All tables are joined suitably and the required conditions applied to get the top two suppiers */
CREATE VIEW Top_Two_Suppliers
	AS
SELECT
	*,
	RANK() OVER(ORDER BY COUNRY_TOT_AMNT DESC) 'RANK'
FROM
	(
	SELECT
		ContactName,
		ProductName,
        Country,
        SUM(total_amount) COUNRY_TOT_AMNT
	FROM 
		(
		SELECT
			ContactName,
            ProductName,
            Country,
            SUM(TotalAmount) total_amount
		FROM
			Supplier S
				JOIN
			Product P
            ON S.Id = P.SupplierId 
				JOIN
			OrderItem OI
            ON OI.ProductId = P.Id
				JOIN
			Orders O
			ON O.Id = OI.OrderId
		GROUP BY ContactName, ProductName, Country
        ORDER BY SUM(TotalAmount) DESC) R1
	GROUP BY ContactName, ProductName, Country) R2
LIMIT 2;
SELECT
	*
FROM
	Top_Two_Suppliers;

# Task 5: Find out for which products, UK is dependent on other countries for the supply.
# List the countries which are supplying these products in the same list.
/*The products that UK is dependent on would not be manufactured by it, so such products
are queried here.*/
SELECT
	ProductName,
	Country
FROM
	Supplier S
		JOIN
	Product P
	ON S.Id = P.SupplierId
WHERE
	Country <> 'UK';
    
# Task 6: Create two tables as ‘customer’ and ‘customer_backup’ as follow - 
# ‘customer’ table attributes -
# Id, FirstName,LastName,Phone
# ‘customer_backup’ table attributes - 
# Id, FirstName,LastName,Phone
# 
# Create a trigger in such a way that It should insert the details into the 
# ‘customer_backup’ table when you delete the record from the ‘customer’ table automatically.
-- Creating the 'customer' table
CREATE DATABASE supply;
USE supply;
CREATE TABLE customer(
	Id INT,
    FirstName varchar(30),
    LastName varchar(30),
    Phone text);
-- Creating the 'customer_backup' table
CREATE TABLE customer_backup(
	Id INT,
    FirstName varchar(30),
    LastName varchar(30),
    Phone text);

-- Creating the Trigger
/*The trigger code is written such that before the delete statement on customer,
each row is inserted into the customer_backup table. After all data is inserted, then
only does the data get deleted in the customer table.*/
DELIMITER $$

CREATE TRIGGER backup_customer_records
BEFORE DELETE ON customer
FOR EACH ROW
BEGIN
	INSERT INTO customer_backup (Id, FirstName, LastName, Phone)
	VALUES (OLD.Id, OLD.FirstName, OLD.LastName, OLD.Phone);
END$$

DELIMITER ;
	
-- Testing it
INSERT INTO customer VALUES(1, "Dylan", "O'Brien", 9764543323);
INSERT INTO customer VALUES(2, "Felicity", "Jones", 9764535623);
INSERT INTO customer VALUES(3, "Oliver", "Twist", 9763433323);
SELECT * FROM customer;
DELETE FROM customer;
SELECT * FROM customer_backup;