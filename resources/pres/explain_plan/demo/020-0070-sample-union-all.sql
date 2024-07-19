-- UNION ALL query, returning employees meeting various conditions
-- (remark: without deduplication)

select emp.employee_id, emp.email, phone_number, job_id
  from employees emp
 where emp.email like '%Z'
 union all
select emp.employee_id, emp.email, phone_number, job_id
  from employees emp
 where emp.email like 'V%'
 union all
select emp.employee_id, emp.email, phone_number, job_id
  from employees emp
 where emp.phone_number like '33.1.%'
 union all
select emp.employee_id, emp.email, phone_number, job_id
  from employees emp
 where emp.job_id = 'AC_ACCOUNT';
