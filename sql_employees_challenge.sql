CREATE TABLE "departments" (
    "dept_no" varchar(100)   NOT NULL,
    "dept_name" varchar(100)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar(100)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(100)   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar(100)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(100)   NOT NULL,
    "last_name" varchar(100)   NOT NULL,
    "sex" varchar(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no","salary"
     )
);

CREATE TABLE "titles" (
    "title_id" varchar(100)   NOT NULL,
    "title" varchar(100)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--SELECT *
--FROM titles;

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no,employees.first_name,
		employees.last_name,employees.sex,salaries.salary
FROM employees
INNER JOIN salaries ON
employees.emp_no=salaries.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name,last_name,hire_date
FROM employees
WHERE hire_date<'1/1/1987' AND hire_date>'12/31/1985';

--List the manager of each department along with their department number, department name,
--employee number, last name, and first name.
SELECT dept_manager.emp_no,dept_manager.dept_no,departments.dept_name,
employees.last_name,employees.first_name
FROM employees
INNER JOIN dept_manager ON
dept_manager.emp_no=employees.emp_no
INNER JOIN departments ON
departments.dept_no=dept_manager.dept_no;

--List the department number for each employee along with that employee’s employee number,
--last name, first name, and department name.
SELECT dept_emp.emp_no,dept_emp.dept_no,departments.dept_name,
employees.last_name,employees.first_name
FROM employees
INNER JOIN dept_emp ON
dept_emp.emp_no=employees.emp_no
INNER JOIN departments ON
departments.dept_no=dept_emp.dept_no;

--List first name, last name, and sex of each employee whose first name is Hercules
--and whose last name begins with the letter B.
SELECT first_name,last_name,sex
FROM employees
WHERE first_name='Hercules' AND last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number,
--last name, and first name.
SELECT emp_no,last_name,first_name
FROM employees
WHERE emp_no IN
(SELECT emp_no
 FROM dept_emp
 WHERE dept_no IN
 (SELECT dept_no
  FROM departments
  WHERE dept_name='Sales'));

--List each employee in the Sales and Development departments,
--including their employee number, last name, first name, and department name.
SELECT dept_emp.emp_no,departments.dept_name,employees.last_name,employees.first_name
FROM employees
INNER JOIN dept_emp ON
dept_emp.emp_no=employees.emp_no
INNER JOIN departments ON
departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name='Sales' OR departments.dept_name='Development';

--List the frequency counts, in descending order, of all the employee last names
--(that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) AS "Last_Name_Frequency_Count"
FROM employees
GROUP BY last_name
ORDER BY "Last_Name_Frequency_Count" DESC;

