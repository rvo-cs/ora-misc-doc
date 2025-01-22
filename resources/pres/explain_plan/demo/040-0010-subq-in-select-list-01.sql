-- Subquery in the SELECT-list, case #1

select emp.employee_id,
       emp.last_name,
       emp.salary,
       emp.commission_pct,
       round( ( select avg(sub.commission_pct)
                  from employees sub
                 where sub.manager_id = emp.manager_id ), 2 ) as avg_comm_pct
  from employees emp
  where emp.commission_pct is not null
    and emp.manager_id = 100;
