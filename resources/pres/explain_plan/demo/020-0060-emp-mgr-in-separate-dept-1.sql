-- Employees not working in the same department as their manager

select emp.employee_id, emp.last_name, edep.department_name,
       mgr.last_name as mgr_last_name, 
       mgrd.department_name as mgr_dept_name
  from employees emp,
       employees mgr,
       departments edep,
       departments mgrd
 where emp.manager_id = mgr.employee_id
   and lnnvl(emp.department_id = mgr.department_id)
   and edep.department_id (+) = emp.department_id
   and mgrd.department_id (+) = mgr.department_id
   and emp.manager_id <> 100  -- exclude employees directly reporting to the President
 order by emp.employee_id;
