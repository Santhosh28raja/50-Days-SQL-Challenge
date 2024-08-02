/*
Write a recursive CTE (Common Table Expression) query to retrieve the entire 
hierarchy of employees who are directly or indirectly reporting to an employee with 
employee_id = 110 (the CEO). The result should include the employee_id, first_name, 
last_name, and manager_id of all employees in this hierarchy.
*/
use practice;

CREATE TABLE employee (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    manager_id INT
);

INSERT INTO employee VALUES
(100, 'Steven', 'King', NULL),
(101, 'Neena', 'Kochhar', 100),
(102, 'Lex', 'De Haan', 100),
(103, 'Alexander', 'Hunold', 101),
(104, 'Bruce', 'Ernst', 101),
(105, 'David', 'Austin', 102),
(106, 'Valli', 'Pataballa', 102),
(107, 'Diana', 'Lorentz', 103),
(110, 'John', 'Doe', NULL),
(111, 'Jane', 'Smith', 110),
(112, 'Mike', 'Johnson', 111),
(113, 'Chris', 'Lee', 111);


WITH RECURSIVE EmployeeHierarchy AS (
    SELECT *
    FROM employee
    WHERE employee_id = 110
    
    UNION ALL
    
    SELECT e.*
    FROM employee e
    INNER JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT *
FROM EmployeeHierarchy;
