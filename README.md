# Library-Management-System using SQL Queries and PL/SQL Block
The system will be used to manage books, members, and borrowing transactions. Your task is to create the necessary database schema, populate the database with sample data, and develop PL/SQL procedures to handle book borrowing, returning, and fine calculation.

## Explanation of the Project
I have created library management system . This system contains the information about members, books, transaction about books and calculation of fines. I have used the concept like  exception handling and procedure.


## Features

- **Books Management**: Store and manage details of books including title, author, publisher, category, and the number of available copies.
- **Members Management**: Store and manage details of library members including their names, email addresses, phone numbers, and addresses.
- **Borrowing Transactions**: Track borrowing and returning of books by members with automatic handling of transaction IDs.
- **Fine Calculation**: Calculate fines for overdue books based on a configurable overdue period.

## Database Schema

### Tables

- **Books**
  - `book_id` (Primary Key): Unique identifier for each book.
  - `title`: Title of the book.
  - `author`: Author of the book.
  - `publisher`: Publisher of the book.
  - `category`: Category of the book.
  - `available_copies`: Number of available copies.

- **Members**
  - `member_id` (Primary Key): Unique identifier for each member.
  - `first_name`: First name of the member.
  - `last_name`: Last name of the member.
  - `email`: Email address of the member.
  - `phone_number`: Phone number of the member.
  - `address`: Address of the member.

- **Borrowing Transactions**
  - `transaction_id` (Primary Key): Unique identifier for each transaction.
  - `member_id` (Foreign Key): Reference to the `member_id` in the members table.
  - `book_id` (Foreign Key): Reference to the `book_id` in the books table.
  - `borrow_date`: Date when the book was borrowed.
  - `return_date`: Date when the book was returned.
  - `status`: Status of the transaction (e.g., 'borrowed', 'returned').

## Procedures

- **`borrow_book`**: Procedure to borrow a book. Checks availability, updates the transactions, and decreases the available copies.
- **`return_book`**: Procedure to return a book. Updates the transactions, calculates fines for overdue books, and increases the available copies.
- **`calculate_fines`**: Procedure to calculate and output fines for all overdue books.

## Sample Data

The repository includes sample data for testing, with sample books and members located in Chennai. These help in demonstrating the functionality of borrowing and returning books.

## Usage

To use the Library Management System, follow these steps:

1. **Create Tables**: Create the `books`, `members`, and `borrowing_transactions` tables in your Oracle database.
2. **Insert Sample Data**: Insert the provided sample data into the tables.
3. **Create Procedures**: Create the stored procedures for borrowing, returning books, and calculating fines.
4. **Run Examples**: Use the example `begin` blocks to test borrowing and returning books, as well as calculating fines.

## Getting Started

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/library-management-system.git
    ```
2. Navigate to the project directory:
    ```sh
    cd library-management-system
    ```
3. Follow the instructions in the `Usage` section to set up and test the system.



