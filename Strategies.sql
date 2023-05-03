--These queries can be useful for the strategy you suggest for recruiting.


--1.Identify the most popular feeder institutions for the UB IT program.
SELECT 
    f.school_name, 
    COUNT(DISTINCT s.Student_id) as num_students
FROM 
    Students as s 
    INNER JOIN Feeder as f ON f.Feeder_id = s.Feeder_id 
    INNER JOIN Credentials as c ON c.Student_id = s.Student_id 
    INNER JOIN Program as p ON p.Program_id = p.Program_id 
WHERE 
    p.program_code = 'BINT' 
GROUP BY 
    f.school_name 
ORDER BY 
    num_students DESC;


--Explanation: This query identifies the feeder institutions that 
--are currently sending the most students to the BINT program.
--This information could be used to target recruitment efforts towards these 
--institutions in order to attract even more students from them.




--2.Determine the average GPA of students who pass the most difficult IT and Math courses.
SELECT 
    c.course_title, 
    AVG(gs.course_gpa) as avg_gpa 
FROM 
    Grades_and_status as gs 
    INNER JOIN Course as c ON c.Course_id = gs.Course_id 
WHERE 
    c.course_title LIKE '%Math%' OR c.course_title LIKE '%IT%' 
    AND gs.course_grade NOT IN ('F', 'D', 'D+', 'D-', 'F-', 'NP') 
GROUP BY 
    c.course_title 
ORDER BY 
    avg_gpa DESC;

--Explanation: This query identifies the IT and Math courses 
--that are considered the most difficult (based on the fact that only
-- passing grades are included in the average calculation). Knowing which 
--courses are the most challenging can help target additional support services 
--towards students taking these courses, which can improve their chances of success 
--and potentially improve retention rates.




--3.Determine the most common reasons for students dropping out of the IT program.
SELECT 
    gs.comments, 
    COUNT(*) as num_students 
FROM 
    Grades_and_status as gs 
    INNER JOIN Course as c ON c.Course_id = gs.Course_id 
WHERE 
    c.course_title LIKE '%IT%' 
    AND gs.course_grade = 'F' 
    AND gs.comments IS NOT NULL 
GROUP BY 
    gs.comments 
ORDER BY 
    num_students DESC;

--Explanation: This query identifies the most common reasons given 
--by students for failing IT courses. Knowing why students are struggling can help.






