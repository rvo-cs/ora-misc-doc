-- Contrived example of HASH JOIN OUTER

select sub.employee_id, sub.last_name, sub.hire_date
  from employees sub
  left outer join employees mgr on mgr.employee_id = sub.manager_id
                               and mgr.hire_date <= sub.hire_date
 where sub.department_id not in (50, 80)
   and sub.job_id <> 'AD_PRES'  -- exclude the President
   and mgr.employee_id is null;
