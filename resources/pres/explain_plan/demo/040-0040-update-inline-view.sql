-- A far better way of writing the same UPDATE statement, using an
-- inline view which preserves the primary key values of EMPLOYEES.

update ( select emp.employee_id,
                emp.salary,
                job.max_salary,
                job.min_salary
           from employees emp,
                jobs job
           where emp.job_id = job.job_id
             and emp.salary = job.min_salary
       ) upd
   set upd.salary = upd.salary 
            + 0.025 * (upd.max_salary - upd.min_salary);