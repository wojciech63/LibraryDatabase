Create TABLE BookCategories (
	CategoryID SERIAL PRIMARY KEY,
	CategoryName VARCHAR(255) Not Null
);

Create Table Book(
	CopyID SERIAL Primary Key,
	Title VARCHAR(255) NOT NULL,
	BookCondition VARCHAR(50) NOT NULL,
	CategoryID INT,
	Foreign Key (CategoryID) REFERENCES BookCategories(CategoryID)
	
);

Create Table Authors (
	AuthorID SERIAL Primary Key,
	FirstName VarChar(100) Not Null,
	LastName VarChar(100) Not null
);

-- Junction Table
CREATE TABLE BookAuthors (
	CopyID INT Not Null,
	AuthorID INT Not Null,
	Primary Key (CopyID, AuthorID),
	Foreign Key (CopyID) References Book(CopyID),
	Foreign Key (AuthorID) References Authors(AuthorID)
);

Create Table Customer(
	CustomerID SERIAL Primary Key,
	FirstName VARCHAR(50),
	LastName VARCHAR(50),
	PhoneNumber VARCHAR(9),
	Email VARCHAR(255),
	Address TEXT,
	DateOfBirth DATE
);

Create TABLE Rental(
	RentID SERIAL Primary Key,
	CopyID INT NOT NULL,
	CustomerID INT NOT NULL,
-- 1 - Availiable, 0 - Not availiable
	Fine Numeric(3, 2),
	RentalDate DATE NOT NULL,
	ReturnDate DATE,
	Foreign Key (CopyID) References Book(CopyID),
	Foreign Key (CustomerID) References Customer(CustomerID)
);

ALTER TABLE Book ADD COLUMN Status BOOLEAN DEFAULT FALSE;

ALTER TABLE Book ADD COLUMN TimesRented INT Default 0;

CREATE OR REPLACE FUNCTION update_book_status()
Returns TRIGGER AS $$
BEGIN
	IF NEW.ReturnDate IS NULL THEN
	UPDATE Book
	SET TimesRented = TimesRented +1,
		Status = FALSE
	WHERE CopyID = NEW.CopyID;
	ELSIF
	NEW.ReturnDate IS NOT NULL THEN
	UPDATE Book
	SET Status = TRUE
	WHERE CopyID = NEW.CopyID;
END IF;

RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER when_rented
AFTER INSERT ON RENTAL
FOR EACH ROW
EXECUTE FUNCTION update_book_status();

CREATE TRIGGER post_rental
AFTER UPDATE OF ReturnDate on Rental
FOR EACH ROW
EXECUTE FUNCTION update_book_status();

