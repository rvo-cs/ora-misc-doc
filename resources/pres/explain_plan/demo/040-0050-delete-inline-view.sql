-- DELETE may also use a key-preserving inline view

delete from ( select emp.employee_id
                from jobs job, employees emp
               where emp.job_id = job.job_id
                 and emp.salary = job.min_salary
            );