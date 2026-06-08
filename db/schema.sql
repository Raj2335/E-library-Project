-- E-Library database schema (MySQL 8+)
CREATE TABLE admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(191) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_num VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    dept VARCHAR(120) NOT NULL,
    year INT NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(191) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_student_year CHECK (year >= 1)
);
CREATE TABLE book (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) NOT NULL UNIQUE,
    category VARCHAR(120),
    publisher VARCHAR(160),
    total_quantity INT NOT NULL DEFAULT 0,
    available_quantity INT NOT NULL DEFAULT 0,
    shelf_location VARCHAR(100),
    cover_image VARCHAR(500),
    created_by INT NOT NULL,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT chk_book_total_qty CHECK (total_quantity >= 0),
    CONSTRAINT chk_book_avail_qty CHECK (available_quantity >= 0),
    CONSTRAINT chk_book_qty_relation CHECK (available_quantity <= total_quantity),
    CONSTRAINT fk_book_created_by FOREIGN KEY (created_by) REFERENCES admin(id),
    CONSTRAINT fk_book_updated_by FOREIGN KEY (updated_by) REFERENCES admin(id)
);
CREATE TABLE borrow (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    book_id INT NOT NULL,
    admin_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    fine_amount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    fine_paid BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_borrow_student FOREIGN KEY (student_id) REFERENCES student(id),
    CONSTRAINT fk_borrow_book FOREIGN KEY (book_id) REFERENCES book(id),
    CONSTRAINT fk_borrow_admin FOREIGN KEY (admin_id) REFERENCES admin(id),
    CONSTRAINT chk_borrow_fine_amount CHECK (fine_amount >= 0),
    CONSTRAINT chk_borrow_dates CHECK (due_date >= issue_date),
    CONSTRAINT chk_borrow_status CHECK (
        status IN ('ISSUED', 'RETURNED', 'OVERDUE', 'LOST')
    )
);

-- New fines table for Fine Management System
CREATE TABLE IF NOT EXISTS fines (
        fine_id INT AUTO_INCREMENT PRIMARY KEY,
        borrow_id INT NOT NULL,
        student_id INT NOT NULL,
        book_id INT NOT NULL,
        due_date DATE NOT NULL,
        return_date DATE,
        days_late INT NOT NULL DEFAULT 0,
        fine_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
        status ENUM('UNPAID','PAID') NOT NULL DEFAULT 'UNPAID',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        CONSTRAINT fk_fines_borrow FOREIGN KEY (borrow_id) REFERENCES borrow(id) ON DELETE CASCADE,
        CONSTRAINT fk_fines_student FOREIGN KEY (student_id) REFERENCES student(id) ON DELETE CASCADE,
        CONSTRAINT fk_fines_book FOREIGN KEY (book_id) REFERENCES book(id) ON DELETE CASCADE
);

-- Seed: add some dummy students (only if student table is empty)
INSERT INTO student (name, roll_num, email) 
SELECT 'Riya Patel', 'STU2001', 'riya.patel@example.com' WHERE NOT EXISTS (SELECT 1 FROM student WHERE roll_num='STU2001');
INSERT INTO student (name, roll_num, email) 
SELECT 'Kabir Singh', 'STU2002', 'kabir.singh@example.com' WHERE NOT EXISTS (SELECT 1 FROM student WHERE roll_num='STU2002');

-- Example: insert fines for demonstration (only if not already present)
-- This assumes there are borrow records; if not, these are no-op.
INSERT INTO fines (borrow_id, student_id, book_id, due_date, return_date, days_late, fine_amount, status)
SELECT br.id, br.student_id, br.book_id, br.due_date, br.return_date, GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) AS days_late,
             CASE
                 WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) <= 2 THEN 0.00
                 WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) BETWEEN 3 AND 7 THEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 2
                 WHEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) BETWEEN 8 AND 15 THEN GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 5
                 ELSE GREATEST(DATEDIFF(CURDATE(), br.due_date), 0) * 10
             END AS fine_amount,
             'UNPAID'
FROM borrow br
WHERE NOT EXISTS (SELECT 1 FROM fines f WHERE f.borrow_id = br.id) AND br.status IN ('ISSUED','OVERDUE');
CREATE INDEX idx_borrow_student_id ON borrow(student_id);
CREATE INDEX idx_borrow_book_id ON borrow(book_id);
CREATE INDEX idx_borrow_admin_id ON borrow(admin_id);
CREATE INDEX idx_borrow_status ON borrow(status);
INSERT INTO admin (name, email, password)
VALUES (
        'Administrator',
        'admin@example.com',
        'Admin@123'
    );
INSERT INTO student (roll_num, name, dept, year, phone, email)
VALUES (
        'STU1001',
        'Aarav Sharma',
        'Computer Science',
        2,
        '9876543210',
        'aarav.sharma@example.com'
    ),
    (
        'STU1002',
        'Neha Verma',
        'Information Technology',
        3,
        '9876543211',
        'neha.verma@example.com'
    ),
    (
        'STU1003',
        'Kabir Singh',
        'Mechanical Engineering',
        1,
        '9876543212',
        'kabir.singh@example.com'
    );
INSERT INTO book (
        title,
        author,
        isbn,
        category,
        publisher,
        total_quantity,
        available_quantity,
        shelf_location,
        cover_image,
        created_by
    )
VALUES (
        'Clean Code',
        'Robert C. Martin',
        '9780132350884',
        'Programming',
        'Prentice Hall',
        4,
        3,
        'A-1',
        'https://covers.openlibrary.org/b/isbn/9780132350884-L.jpg',
        1
    ),
    (
        'The Pragmatic Programmer',
        'Andrew Hunt, David Thomas',
        '9780135957059',
        'Programming',
        'Addison-Wesley',
        5,
        4,
        'A-2',
        'https://covers.openlibrary.org/b/isbn/9780135957059-L.jpg',
        1
    ),
    (
        'Atomic Habits',
        'James Clear',
        '9780735211292',
        'Self Help',
        'Avery',
        6,
        5,
        'B-1',
        'https://covers.openlibrary.org/b/isbn/9780735211292-L.jpg',
        1
    ),
    (
        'The Alchemist',
        'Paulo Coelho',
        '9780061122415',
        'Fiction',
        'HarperOne',
        5,
        4,
        'B-2',
        'https://covers.openlibrary.org/b/isbn/9780061122415-L.jpg',
        1
    ),
    (
        'To Kill a Mockingbird',
        'Harper Lee',
        '9780061120084',
        'Classic Fiction',
        'Harper Perennial',
        3,
        2,
        'C-1',
        'https://covers.openlibrary.org/b/isbn/9780061120084-L.jpg',
        1
    );