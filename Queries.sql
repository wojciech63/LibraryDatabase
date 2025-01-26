-- Queries asked by the professor

-- What is the most popular book in the library?
SELECT Title, TimesRented
From Book
Order BY TimesRented DESC
LIMIT 1;

-- Which author is the most popular?
Select a.FirstName, a.LastName, COUNT(r.RentID) AS TotalRentals
FROM Authors a
JOIN BookAuthors ba ON a.Author.ID = ba.AuthorID
JOIN Rental r ON ba.CopyID = r.CopyID
GROUP BY a.AuthorID, a.FirstName, a.LastName
ORDER BY TotalRentals DESC
Limit 1;

-- For a given customer, display the books he has not yet returned
Select b.Title, r.RentalDate
From Rental r
Join Book b ON r.CopyID = b.CopyID
WHERE r.CustomerID = 2 AND r.ReturnDate IS NULL;

-- List all the books that have still not returned after the due date (4 weeks)
Select b.Title, r.RentalDate, r.ReturnDate
From Rental r
Join Book b ON r.CopyID = b.CopyID
WHERE r.ReturnDate IS NULL AND r.RentalDate < CURRENT_DATE - INTERVAL '4 weeks';

-- For every category, list the most popular book
SELECT bc.CategoryName, b.Title, b.TimesRented
FROM BookCategories bc
JOIN Book b ON bc.CategoryID = b.CategoryID
Where b.TimesRented 

-- Alternative Using Window Functions
SELECT DISTINCT ON (bc.CategoryID)
	bc.CategoryName,
	b.Title,
	b.TimesRented
FROM BookCategories bc
JOIN Book b ON bc.CategoryID = b.CategoryID
ORDER BY bc.CategoryID, b.TimesRented DESC;