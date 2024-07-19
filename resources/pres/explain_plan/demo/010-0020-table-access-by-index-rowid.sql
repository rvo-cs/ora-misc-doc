-- Employees with ids between 100 and 105

select emp.employee_id,
       emp.first_name,
       emp.last_name
  from employees emp
 where emp.employee_id between 100 and 105;
