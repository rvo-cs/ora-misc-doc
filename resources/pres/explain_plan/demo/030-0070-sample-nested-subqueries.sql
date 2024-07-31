-- Employees who have the specified first name, and who share it with another
-- employee also having the same manager's manager

select jam1.employee_id, jam1.first_name, jam1.last_name,
       mgr1.last_name as lev1_mgr_name, 
       mgr2.last_name as lev2_mgr_name
  from employees jam1,
       employees mgr1,
       employees mgr2
 where jam1.first_name = :EMP_FIRST_NAME
   and mgr1.employee_id = jam1.manager_id
   and mgr2.employee_id = mgr1.manager_id
   and exists ( select 1
                  from employees jam2
                 where jam2.manager_id in ( select mid.employee_id
                                              from employees mid
                                             where mid.manager_id = mgr2.employee_id )
                   and jam2.employee_id <> jam1.employee_id
                   and jam2.first_name = jam1.first_name );
