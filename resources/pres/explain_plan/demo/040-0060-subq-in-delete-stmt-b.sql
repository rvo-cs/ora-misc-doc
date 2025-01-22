-- Equiv. DELETE statement, using an IN ( subquery ) predicate

delete from employees emp
 where emp.salary in ( select job.min_salary
                         from jobs job
                        where job.job_id = emp.job_id );