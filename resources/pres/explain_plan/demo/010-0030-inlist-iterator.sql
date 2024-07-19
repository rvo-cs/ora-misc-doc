-- Employees with the specified job identifiers

select emp.employee_id,
       emp.first_name,
       emp.last_name,
       emp.job_id
  from employees emp
 where emp.job_id in ('FI_MGR', 'NO_SUCH', 'AD_ASST');
