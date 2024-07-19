-- Employees with ids between 100 and 105, having prior assignment before 2010
-- Note: the subquery is hinted to demonstrate this particular plan shape, with
-- (expectedly) a child operation below the index range scan at line id 2.

select emp.employee_id,
       emp.first_name,
       emp.last_name
  from employees emp
 where emp.employee_id between 100 and 105
   and exists ( select /*+ no_unnest push_subq */ 1 
                  from job_history jh
                 where jh.employee_id = emp.employee_id
                   and jh.start_date <= date '2010-01-01' );
