CREATE DATABASE LMS;
USE LMS;

CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    PublicationYear YEAR,
    CopiesAvailable INT DEFAULT 0
);

CREATE TABLE Members (
	MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL, 
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    JoinDate DATE  NOT NULL);
    
    CREATE TABLE BorrowTransactions (
    TransactionID INT AUTO_INCREMENT  PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    BorrowDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID));
    
    CREATE TABLE Fines (
    FineID INT AUTO_INCREMENT PRIMARY KEY,
    TransactionID INT NOT NULL, 
    FineAmount DECIMAL(10, 2) NOT NULL CHECK (FineAmount >= 0),
	PaidStatus ENUM('Paid', 'Unpaid') DEFAULT 'Unpaid',
    FOREIGN KEY (TransactionID) REFERENCES BorrowTransactions(TransactionID) );
    
    INSERT INTO Books (Title, Author, Category, PublicationYear, CopiesAvailable)
VALUES
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', 1960, 5),
('1984', 'George Orwell', 'Dystopian', 1949, 4),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 1925, 3),
('Pride and Prejudice', 'Jane Austen', 'Romance', 1901, 6),
('The Catcher in the Rye', 'J.D. Salinger', 'Fiction', 1951, 2),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 1937, 7),
('Harry Potter and the Sorcerer\'s Stone', 'J.K. Rowling', 'Fantasy', 1997, 10),
('The Alchemist', 'Paulo Coelho', 'Adventure', 1988, 8),
('Brave New World', 'Aldous Huxley', 'Dystopian', 1932, 5),
('The Lord of the Rings', 'J.R.R. Tolkien', 'Fantasy', 1954, 4),
('The Book Thief', 'Markus Zusak', 'Historical', 2005, 6),
('The Chronicles of Narnia', 'C.S. Lewis', 'Fantasy', 1956, 5),
('Moby Dick', 'Herman Melville', 'Classic', 1901, 3),
('The Kite Runner', 'Khaled Hosseini', 'Drama', 2003, 7),
('Life of Pi', 'Yann Martel', 'Adventure', 2001, 6);

INSERT INTO Members (FirstName, LastName, Email, JoinDate)
VALUES
('John', 'Doe', 'john.doe@example.com', '2024-01-15'),
('Jane', 'Smith', 'jane.smith@example.com', '2024-02-20'),
('Alice', 'Johnson', 'alice.johnson@example.com', '2024-03-10'),
('Bob', 'Brown', 'bob.brown@example.com', '2024-04-05'),
('Charlie', 'Davis', 'charlie.davis@example.com', '2024-05-12'),
('Emily', 'Clark', 'emily.clark@example.com', '2024-06-18'),
('Frank', 'Adams', 'frank.adams@example.com', '2024-07-22'),
('Grace', 'Martin', 'grace.martin@example.com', '2024-08-08'),
('Henry', 'Garcia', 'henry.garcia@example.com', '2024-09-14'),
('Isabella', 'Wilson', 'isabella.wilson@example.com', '2024-10-01');

SELECT * FROM  books;
SELECT * FROM members;

INSERT INTO BorrowTransactions (BookID, MemberID, BorrowDate, ReturnDate)
VALUES
(31, 1, '2024-01-05', '2024-01-15'),
(32, 2, '2024-01-10', '2024-01-20'),
(33, 3, '2024-01-15', '2024-01-25'),
(34, 4, '2024-01-20', '2024-01-30'),
(35, 5, '2024-02-01', NULL), -- Book not yet returned
(36, 6, '2024-02-10', '2024-02-20'),
(37, 7, '2024-02-15', '2024-02-25'),
(38, 8, '2024-02-20', '2024-03-01'),
(39, 9, '2024-03-01', NULL), 
(40, 10, '2024-03-05', '2024-03-15'),
(41, 1, '2024-03-10', '2024-03-20'),
(42, 2, '2024-03-15', '2024-03-25'),
(43, 3, '2024-03-20', NULL), 
(44, 4, '2024-03-25', '2024-04-05'),
(45, 5, '2024-04-01', '2024-04-10'),
(31, 6, '2024-04-05', '2024-04-15'),
(32, 7, '2024-04-10', '2024-04-20'),
(33, 8, '2024-04-15', '2024-04-25'),
(34, 9, '2024-04-20', NULL), 
(35, 10, '2024-04-25', '2024-05-05');

SELECT * FROM BorrowTransactions;

INSERT INTO Fines (TransactionID, FineAmount, PaidStatus)
VALUES
(41, 10.50, 'paid'),  
(42, 15.00, 'unpaid'), 
(43, 7.25, 'paid'),    
(44, 12.00, 'unpaid'), 
(45, 5.00, 'paid');    

INSERT INTO BorrowTransactions (BookID, MemberID, BorrowDate, ReturnDate)
VALUES
(31, 1, '2024-11-20', '2024-12-01'),
(32, 2, '2024-11-25', '2024-12-05'),
(33, 3, '2024-11-30', '2024-12-10');

SELECT 
    b.Title AS BookTitle,
    b.Author AS BookAuthor,
    m.FirstName AS MemberFirstName,
    m.LastName AS MemberLastName,
    bt.BorrowDate,
    bt.ReturnDate
FROM 
    BorrowTransactions bt
JOIN 
    Books b ON bt.BookID = b.BookID
JOIN 
    Members m ON bt.MemberID = m.MemberID
WHERE 
    bt.BorrowDate >= CURDATE() - INTERVAL 30 DAY;

SELECT 
    m.FirstName AS MemberFirstName,
    m.LastName AS MemberLastName,
    COUNT(bt.TransactionID) AS TotalBooksBorrowed
FROM 
    BorrowTransactions bt
JOIN 
    Members m ON bt.MemberID = m.MemberID
GROUP BY 
    m.MemberID
ORDER BY 
    TotalBooksBorrowed DESC;
    
    
