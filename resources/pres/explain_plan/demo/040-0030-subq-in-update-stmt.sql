-- Inefficient UPDATE statement, with nested subqueries in
-- the WHERE clause and the SET clause

update employees emp
   set emp.salary = emp.salary 
            + 0.025 * ( select /*+ qb_name(gap) */
                              job.max_salary - job.min_salary
                         from jobs job
                        where job.job_id = emp.job_id )
 where emp.salary = ( select /*+ qb_name(minsal) */ 
                             job.min_salary
                        from jobs job
                       where job.job_id = emp.job_id );