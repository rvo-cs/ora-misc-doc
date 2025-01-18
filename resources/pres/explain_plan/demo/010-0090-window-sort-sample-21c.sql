-- Same as prior query, but slightly simpler thanks to the EXCLUDE CURRENT ROW
-- clause in the windowing clause (Oracle 21c and higher)

select emp.department_id, emp.job_id,
       emp.first_name, emp.last_name,
       emp.hire_date, emp.salary,
       emp.cnt_12m,
       emp.avg_salary as cmp_salary
  from ( select em0.department_id, em0.job_id,
                em0.first_name, em0.last_name,
                em0.hire_date, em0.salary,
                count(*) over (
                        partition by em0.department_id, em0.job_id
                        order by em0.hire_date
                        range between interval '12' month preceding
                                  and current row
                        exclude current row /* 21c enhancement */ ) as cnt_12m,
                round(avg(em0.salary) over (
                        partition by em0.department_id, em0.job_id
                        order by em0.hire_date
                        range between interval '12' month preceding
                                  and current row
                        exclude current row /* 21c enhancement */ )) as avg_salary
           from employees em0
       ) emp
 where emp.cnt_12m >= 5
   and emp.salary >= emp.avg_salary * 1.10;
