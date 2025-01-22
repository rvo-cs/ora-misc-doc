-- Equiv. DELETE statement, using an EXISTS ( subquery ) predicate

delete from employees emp
 where exists ( select 1 from jobs job
                 where job.job_id = emp.job_id 
                   and job.min_salary = emp.salary ); 