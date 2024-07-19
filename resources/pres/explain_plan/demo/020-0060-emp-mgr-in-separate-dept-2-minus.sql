-- Employees not working in the same department as their manager
-- (poorly written in order to use MINUS twice in the same query)

select emp.employee_id, emp.last_name, emp.department_id,
       mgr.last_name as mgr_last_name, 
       mgr.department_id as mgr_dept_id
  from employees emp,
       employees mgr
 where emp.manager_id = mgr.employee_id
 minus
select emp.employee_id, emp.last_name, emp.department_id,
       mgr.last_name as mgr_last_name, 
       mgr.department_id as mgr_dept_id
  from employees emp,
       employees mgr
 where emp.manager_id = mgr.employee_id
   and emp.department_id = mgr.department_id
 minus
select emp.employee_id, emp.last_name, emp.department_id,
       mgr.last_name as mgr_last_name, 
       mgr.department_id as mgr_dept_id
  from employees emp,
       employees mgr
 where emp.manager_id = mgr.employee_id
   and emp.manager_id = 100
 order by employee_id;
 