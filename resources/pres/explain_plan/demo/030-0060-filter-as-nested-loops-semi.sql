-- Managers in department 50
-- with the NO_UNNEST hint in the subquery

select mgr.employee_id, mgr.first_name, mgr.last_name, mgr.hire_date
  from employees mgr
 where mgr.department_id = 50
   and exists ( select /*+ no_unnest */ 1 from employees sub
                 where sub.manager_id = mgr.employee_id );
