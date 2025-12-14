SELECT DISTINCT department_id, AVG(salary)
FROM employees
GROUP BY department_id
;