--Drop commands for tables
DROP TABLE IF EXISTS Feeder CASCADE;
DROP TABLE IF EXISTS Students CASCADE;
DROP TABLE IF EXISTS Program CASCADE;
DROP TABLE IF EXISTS Grades_and_status CASCADE;
DROP TABLE IF EXISTS Course CASCADE;
DROP TABLE IF EXISTS Credentials CASCADE;
DROP TABLE IF EXISTS course_program CASCADE;

--Database tables: number 1-7

--1.
CREATE TABLE Feeder
(
Feeder_id INT PRIMARY KEY,
school_name TEXT NOT NULL
);

-- 2. 
CREATE TABLE Students
(
Student_id INT PRIMARY KEY,
dob TEXT,
gender CHAR(4),
ethnicity TEXT,
city CHAR(100),
district TEXT,
Feeder_id INT,
FOREIGN KEY (Feeder_id)
REFERENCES Feeder(Feeder_id)
);

--3.
CREATE TABLE Program
(
Program_id INT PRIMARY KEY,
program_code CHAR(50) ,
program_name CHAR(100) ,
degree_type TEXT
);

--4.
CREATE TABLE Course
(
Course_id INT PRIMARY KEY,
course_code VARCHAR (10),
course_title TEXT,
course_credits DECIMAL
);

--5.
CREATE TABLE Grades_and_status
(
Grades_status_id INT PRIMARY KEY,
semester TEXT,
semester_credits_attempted DECIMAL,
semestercredits_earned DECIMAL,
semester_points DECIMAL,
cgpa DECIMAL,
semester_gpa DECIMAL,
course_grade CHAR(5),
course_points DECIMAL,
course_gpa DECIMAL,
comments TEXT,
Student_id INT ,
Course_id INT ,
FOREIGN KEY (Student_id )
REFERENCES Students (Student_id),
FOREIGN KEY (Course_id )
REFERENCES Course (Course_id )
);

--6.
CREATE TABLE Credentials
(
Credential_id INT PRIMARY KEY,
program_start TEXT,
program_end TEXT,
grad_date TEXT,
program_status TEXT,
Student_id INT,
FOREIGN KEY (Student_id )
REFERENCES Students (Student_id)
);

--7.
CREATE TABLE course_program
(
Co_pro_id INT PRIMARY KEY,
Course_id INT,
Program_id INT,
Foreign key(Course_id)
REFERENCES Course(Course_id),
Foreign key(Program_id )
REFERENCES Program (Program_id )
);



--Link data files: number 1-7

--1.
\COPY Feeder
FROM '/home/akeylah/finalProject/Feeder.csv'
DELIMITER ','
CSV HEADER;

--2. 
\COPY Students
FROM '/home/akeylah/finalProject/Students.csv'
DELIMITER ','
CSV HEADER;

--3. 
\COPY Program
FROM '/home/akeylah/finalProject/Program.csv'
DELIMITER ','
CSV HEADER;

--4.
\COPY Course
FROM '/home/akeylah/finalProject/Course.csv'
DELIMITER ','
CSV HEADER;

--5.
\COPY Grades_and_status
FROM '/home/akeylah/finalProject/Grades_and_status.csv'
DELIMITER ','
CSV HEADER;

--6.
\COPY Credentials
FROM '/home/akeylah/finalProject/Credentials.csv'
DELIMITER ','
CSV HEADER;

--7.
\COPY course_program
FROM '/home/akeylah/finalProject/course_program.csv'
DELIMITER ','
CSV HEADER;



--Display tables: number 1-7
--1.
SELECT*
FROM Feeder;

--2. 
SELECT*
FROM Students;

--3. 
SELECT*
FROM Program;

--4.
SELECT*
FROM Course;

--5. 
SELECT*
FROM Grades_and_status;

--6.
SELECT*
FROM Credentials;
--7. 
SELECT*
FROM course_program;



--Final Project queries: number 1-4

--1.Overall acceptance rates into the AINT and BINT programs: #works
SELECT p.program_code, 
COUNT(DISTINCT s.Student_id) * 100 / COUNT(*) as admission_rate
FROM Students as s 
INNER JOIN Credentials as c ON s.Student_id = c.Student_id 
INNER JOIN Program as p ON p.program_id = p.program_id
GROUP BY p.program_code;


--2. Feeder institutions ranked by admission rates and grades:#works
SELECT f.school_name, 
COUNT(DISTINCT s.Student_id) * 100 / COUNT(*) as admission_rate, 
AVG(gs.cgpa) as course_grades
FROM Students as s 
INNER JOIN Credentials as c ON s.Student_id = c.Student_id 
INNER JOIN Program as p ON p.program_id = p.program_id 
INNER JOIN Grades_and_status as gs ON gs.Student_id = s.Student_id 
INNER JOIN Feeder as f ON f.Feeder_id = s.Feeder_id 
WHERE p.program_code = 'BINT' 
GROUP BY f.school_name 
ORDER BY admission_rate DESC, course_grades DESC;


--3. Calculate graduation rate for student's in BINT program. #works
SELECT COUNT(DISTINCT gs.Student_id)*100/(
SELECT COUNT(DISTINCT s.Student_id) 
FROM Students as s
INNER JOIN Credentials as c ON s.Student_id = c.Student_id 
INNER JOIN Program as p ON p.Program_id = p.Program_id 
WHERE p.program_code = 'BINT') as graduation_rate 
FROM Grades_and_status as gs 
INNER JOIN Students as s ON gs.Student_id = s.Student_id 
INNER JOIN Credentials as c ON s.Student_id = c.Student_id 
INNER JOIN Program as p ON p.Program_id = p.Program_id 
WHERE p.program_code = 'BINT' AND c.program_status = 'Graduated';

--4.Then calculate the average amount of time it takes AINT students to graduate and BINT students take to graduate.#WORKS
SELECT AVG((c.program_end::date - c.program_start::date)/365.0) as avgerage_time_to_graduate 
FROM Credentials as c
INNER JOIN Program as p
ON p.program_code = p.program_code
WHERE p.program_code = 'BINT';
