--1 What is the undiscounted subtotal for each Order (identified by OrderID).
SELECT o.OrderID, sum(od.Quantity * od.UnitPrice) as Undiscounted
FROM Orders o
	JOIN [Order Details] od
	ON o.OrderID = od.OrderID
GROUP BY o.OrderID

--2 What products are currently for sale (not discontinued)?
SELECT p.*
FROM Products p
WHERE p.Discontinued = 0

--3 What is the cost after discount for each order?  Discounts should be applied as a percentage off.
SELECT o.OrderID, round(sum(od.Quantity * od.UnitPrice * (1 - od.Discount)),2) AS WithoutDiscount
FROM Orders o
	JOIN [Order Details] od
	ON o.OrderID = od.OrderID
GROUP BY o.OrderID

--4 I need a list of sales figures broken down by category name.  Include the total $ amount sold over all time and the total number of items sold.
SELECT c.CategoryName, sum(od.UnitPrice * Quantity  * (1-Discount)) AS revenue, count(od.Quantity) AS AmountSold
FROM Products p
	JOIN [Order Details] od 
		ON p.ProductID = od.ProductID
	JOIN Categories c
		ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName 
ORDER BY revenue DESC

--5 What are our 10 most expensive products?
SELECT TOP 10 *
FROM Products p
WHERE p.Discontinued = 0
ORDER BY p.UnitPrice DESC

--6 In which quarter in 1997 did we have the most revenue?
SELECT datepart(quarter, o.OrderDate) as Quarter, round(sum((od.UnitPrice * od.Quantity) * (1-od.Discount)),2) as Subtotal
FROM Orders o
	JOIN [Order Details] od
	on o.OrderID = od.OrderID
	WHERE year(o.OrderDate) = 1997
GROUP BY datepart(quarter, o.OrderDate)
ORDER BY Subtotal DESC

--7 Which products have a price that is higher than average?
SELECT p.ProductID, p.ProductName, p.UnitPrice 
FROM Products p
WHERE p.UnitPrice > (SELECT avg(p.UnitPrice) FROM Products p)
	AND p.Discontinued = 0
ORDER BY p.UnitPrice DESC
