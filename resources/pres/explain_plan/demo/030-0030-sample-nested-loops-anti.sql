-- Employees from the IT department who are not managers

select emp.employee_id, emp.first_name, emp.last_name
  from departments dep,
       employees emp
 where dep.department_name = 'IT'
   and emp.department_id = dep.department_id
   and not exists ( select 1 from employees sub
                     where sub.manager_id = emp.employee_id );
