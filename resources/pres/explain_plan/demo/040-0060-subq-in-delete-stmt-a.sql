-- Equiv. DELETE statement, using a scalar subquery in the WHERE clause

delete from employees emp
 where emp.salary = ( select job.min_salary
                        from jobs job
                       where job.job_id = emp.job_id );