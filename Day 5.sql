use practice;

CREATE TABLE projects (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255),
    start_date DATETIME,
    end_date DATETIME,
    budget INTEGER
);

CREATE TABLE employee_projects (
    project_id INTEGER,
    employee_id INTEGER
);

INSERT INTO projects VALUES
(1, 'Project_1', '2021-01-01 00:00:00', '2022-01-01 00:00:00', 50000),
(2, 'Project_2', '2021-02-01 00:00:00', '2022-02-01 00:00:00', 60000),
(3, 'Project_3', '2021-03-01 00:00:00', '2022-03-01 00:00:00', 70000),
(4, 'Project_4', '2021-04-01 00:00:00', '2022-04-01 00:00:00', 80000),
(5, 'Project_5', '2021-05-01 00:00:00', '2022-05-01 00:00:00', 90000),
(6, 'Project_6', '2021-06-01 00:00:00', '2022-06-01 00:00:00', 100000),
(7, 'Project_7', '2021-07-01 00:00:00', '2022-07-01 00:00:00', 110000),
(8, 'Project_8', '2021-08-01 00:00:00', '2022-08-01 00:00:00', 120000),
(9, 'Project_9', '2021-09-01 00:00:00', '2022-09-01 00:00:00', 130000),
(10, 'Project_10', '2021-10-01 00:00:00', '2022-10-01 00:00:00', 140000),
(11, 'Project_11', '2021-11-01 00:00:00', '2022-11-01 00:00:00', 150000),
(12, 'Project_12', '2021-12-01 00:00:00', '2022-12-01 00:00:00', 160000),
(13, 'Project_13', '2021-01-01 00:00:00', '2022-01-01 00:00:00', 170000),
(14, 'Project_14', '2021-02-01 00:00:00', '2022-02-01 00:00:00', 180000),
(15, 'Project_15', '2021-03-01 00:00:00', '2022-03-01 00:00:00', 190000),
(16, 'Project_16', '2021-04-01 00:00:00', '2022-04-01 00:00:00', 200000),
(17, 'Project_17', '2021-05-01 00:00:00', '2022-05-01 00:00:00', 210000),
(18, 'Project_18', '2021-06-01 00:00:00', '2022-06-01 00:00:00', 220000),
(19, 'Project_19', '2021-07-01 00:00:00', '2022-07-01 00:00:00', 230000),
(20, 'Project_20', '2021-08-01 00:00:00', '2022-08-01 00:00:00', 240000),
(21, 'Project_21', '2021-09-01 00:00:00', '2022-09-01 00:00:00', 250000),
(22, 'Project_22', '2021-10-01 00:00:00', '2022-10-01 00:00:00', 260000),
(23, 'Project_23', '2021-11-01 00:00:00', '2022-11-01 00:00:00', 270000),
(24, 'Project_24', '2021-12-01 00:00:00', '2022-12-01 00:00:00', 280000),
(25, 'Project_25', '2021-01-01 00:00:00', '2022-01-01 00:00:00', 290000);

-- Insert random data into employee_projects table
INSERT INTO employee_projects (project_id, employee_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10),
(6, 11),
(6, 12),
(7, 13),
(7, 14),
(8, 15),
(8, 16),
(9, 17),
(9, 18),
(10, 19),
(10, 20),
(11, 21),
(11, 22),
(12, 23),
(12, 24),
(13, 25);

-- Method 1
WITH employee_counts AS (
    SELECT project_id, COUNT(DISTINCT employee_id) AS employee_count
    FROM employee_projects
    GROUP BY project_id
),
project_budgets AS (
    SELECT p.id, p.title, p.budget, ec.employee_count,
           p.budget / COALESCE(NULLIF(ec.employee_count, 0), 1) AS budget_per_employee
    FROM projects p
    JOIN employee_counts ec ON p.id = ec.project_id
)
SELECT title, budget_per_employee
FROM project_budgets
ORDER BY budget_per_employee DESC
limit 5;


-- Method 2
WITH DeduplicatedEmployeeProjects AS (
    SELECT 
        project_id, 
        employee_id,
        ROW_NUMBER() OVER (PARTITION BY project_id, employee_id ORDER BY project_id) AS rn
    FROM employee_projects
),
FilteredEmployeeProjects AS (
    SELECT project_id, employee_id
    FROM DeduplicatedEmployeeProjects
    WHERE rn = 1
)
SELECT
    p.title,
    (p.budget * 1.0 / COUNT(fep.employee_id)) AS budget_per_employee
FROM
    projects p
JOIN
    FilteredEmployeeProjects fep ON p.id = fep.project_id
GROUP BY
    p.title, p.budget
ORDER BY
    budget_per_employee DESC
LIMIT 5;


-- Method 3
WITH UniqueEmployeeProjects AS (
    SELECT DISTINCT project_id, employee_id
    FROM employee_projects
),
ProjectEmployeeCount AS (
    SELECT ep.project_id, p.title, p.budget, COUNT(ep.employee_id) AS employee_count
    FROM UniqueEmployeeProjects ep
    JOIN projects p ON ep.project_id = p.id
    GROUP BY ep.project_id, p.title, p.budget
),
BudgetPerEmployee AS (
    SELECT title, (budget * 1.0 / employee_count) AS budget_per_employee
    FROM ProjectEmployeeCount
)
SELECT title, budget_per_employee
FROM BudgetPerEmployee
ORDER BY budget_per_employee DESC
LIMIT 5;
