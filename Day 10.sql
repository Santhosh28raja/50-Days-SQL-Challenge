/*
Delete duplicate rows from the employees table based on the name and 
department_id columns, keeping only the row with the highest salary.
*/ 

use practice;

CREATE TABLE emps (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    salary DECIMAL(10, 2),
    manager_id INT
);

INSERT INTO emps VALUES
(1, 'John Doe', 1, 60000, NULL),
(2, 'Jane Smith', 1, 75000, 1),
(3, 'Emily Davis', 1, 80000, 1),
(4, 'Michael Brown', 2, 65000, NULL),
(5, 'Sarah Wilson', 2, 85000, 4),
(6, 'David Lee', 2, 70000, 4),
(7, 'Chris Johnson', 3, 72000, NULL),
(8, 'Anna White', 3, 95000, 7),
(9, 'James Green', 3, 68000, 7);

-- Query
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY name, department_id ORDER BY salary DESC) AS rn
    FROM emps
)
DELETE FROM emps
WHERE employee_id IN (
    SELECT employee_id FROM CTE WHERE rn > 1
);
