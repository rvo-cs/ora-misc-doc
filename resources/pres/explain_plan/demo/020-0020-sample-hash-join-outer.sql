-- Contrived example of HASH JOIN OUTER

select sub.employee_id, sub.last_name, sub.hire_date
  from employees sub
  left outer join employees mgr on mgr.employee_id = sub.manager_id
                               and mgr.hire_date <= sub.hire_date
 where mgr.employee_id is null             -- keep only non-matching rows
   and sub.job_id <> 'AD_PRES'             -- also exclude the President
   and sub.department_id not in (50, 80);
