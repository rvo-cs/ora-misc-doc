-- MERGE statement, with a subquery in the WHERE clause of the merge_update_clause

merge into employees emp
using &_USER..salary_raises src
   on ( emp.employee_id = src.employee_id )
 when matched then
      update
         set emp.salary = emp.salary * (1 + src.salary_incr_pct / 100)
       where ( select job.max_salary from jobs job
                where job.job_id = emp.job_id ) >=
                    emp.salary * (1 + src.salary_incr_pct / 100);