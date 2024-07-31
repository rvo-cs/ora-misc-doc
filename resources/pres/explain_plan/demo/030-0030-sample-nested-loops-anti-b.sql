-- Employees from the IT department who are not managers
-- Equivalent query using an outer join + a post-join null check on the join column

select emp.employee_id, emp.first_name, emp.last_name
  from departments dep,
       employees emp,
       employees sub
 where dep.department_name = 'IT'
   and emp.department_id = dep.department_id
   and sub.manager_id (+) = emp.employee_id
   and sub.manager_id is null;
