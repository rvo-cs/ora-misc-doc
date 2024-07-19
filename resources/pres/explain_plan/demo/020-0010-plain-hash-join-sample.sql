-- Employees having a higher salary than their manager

select emp.employee_id, emp.last_name, 
       emp.salary, emp.job_id,
       mgr.employee_id as mgr_id, mgr.last_name as manager_name,
       mgr.salary as mgr_salary, mgr.job_id as mgr_job_id
  from employees emp,
       employees mgr
 where emp.manager_id = mgr.employee_id
   and emp.salary > mgr.salary;
   