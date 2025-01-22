-- Equiv. MERGE statement, but using inline views as the source
-- and target of the statement in order to limit column projections

merge into 
      ( select emp.employee_id, emp.job_id, emp.salary
          from employees emp 
      ) tgt
using ( select sal.employee_id, sal.salary_incr_pct
          from &_USER..salary_raises sal 
      ) src
   on ( tgt.employee_id = src.employee_id )
 when matched then update
          set tgt.salary = tgt.salary * (1 + src.salary_incr_pct / 100)
        where ( select job.max_salary from jobs job
                 where job.job_id = tgt.job_id ) >=
                          tgt.salary * (1 + src.salary_incr_pct / 100);