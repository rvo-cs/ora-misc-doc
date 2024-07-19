-- Employees whose manager works in a department with a name matching
-- the specified regexp

select emp.employee_id, emp.last_name, emp.manager_id
  from employees emp
 where exists ( select 1 from employees mgr,
                              departments dep
                 where mgr.employee_id = emp.manager_id 
                   and mgr.department_id = dep.department_id
                   and regexp_like(dep.department_name, '^M.*ting$')
              );
