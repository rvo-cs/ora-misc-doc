-- Analytic functions, aka window functions

select emp.department_id, emp.job_id,
       emp.first_name, emp.last_name,
       emp.hire_date, emp.salary,
       emp.cnt_12m - 1 as cnt_12m,
       round((emp.sum_salary - emp.salary) / (emp.cnt_12m - 1)) as cmp_salary
  from ( select em0.department_id, em0.job_id,
                em0.first_name, em0.last_name,
                em0.hire_date, em0.salary,
                count(*) over (
                        partition by em0.department_id, em0.job_id
                        order by em0.hire_date
                        range between interval '12' month preceding
                                  and current row) as cnt_12m,
                sum(em0.salary) over (
                        partition by em0.department_id, em0.job_id
                        order by em0.hire_date
                        range between interval '12' month preceding
                                  and current row) as sum_salary
           from employees em0
       ) emp
 where emp.cnt_12m > 5
   and emp.salary >= (emp.sum_salary - salary) / (emp.cnt_12m - 1) * 1.10;

-- This query returns employees earning a salary higher by 10% or more than
-- the average of colleagues (same job and department) hired up to 12 months 
-- before them, assuming there are at least 5 such colleagues
