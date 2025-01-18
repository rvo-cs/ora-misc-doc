-- Employees who were the single hire in a full quarter

select emp.first_name, emp.last_name, emp.email, 
       emp.phone_number, emp.job_id, emp.department_id,
       emp.manager_id, emp.hire_date
  from employees emp
 where not exists (select 1 from employees oth
                    where oth.employee_id <> emp.employee_id
                      and trunc(oth.hire_date, 'Q') = trunc(emp.hire_date, 'Q'));
