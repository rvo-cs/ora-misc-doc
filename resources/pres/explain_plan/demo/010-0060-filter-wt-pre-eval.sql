-- Some FILTERs can check their condition upfront, and enable/disable
-- their child operation(s) accordingly

select emp.job_id,
       min(salary) as min_sal
  from employees emp
 where :INDIC is not null
   and emp.department_id = 20
 group by emp.job_id
having min(salary) >= 10000;
