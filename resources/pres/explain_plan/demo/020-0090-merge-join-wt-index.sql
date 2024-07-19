-- Employees earning the lowest / highest permitted salary in their job
-- (or even beyond that)

select emp.employee_id, emp.last_name, emp.hire_date, emp.salary,
       job.job_title,
       case
           when emp.salary > job.max_salary then '+++'
           when emp.salary = job.max_salary then 'MAX'
           when emp.salary < job.min_salary then '---'
           when emp.salary = job.min_salary then 'MIN'
       end as indic
  from employees emp,
       jobs job
 where emp.job_id = job.job_id
   and (emp.salary <= job.min_salary
        or emp.salary >= job.max_salary);
