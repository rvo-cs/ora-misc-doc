-- A contrived example of a model clause: employees managed by someone in another
-- department. Note: don't do this: the obvious solution, using a plain relational
-- join, is far simpler--and it probably scales up better, too.

select emp.employee_id, emp.last_name,
       emp.manager_id, emp.mgr_last_name,
       emp.department_id, emp.mgr_dept_id
  from ( select *
           from employees em0 model 
                dimension by ( employee_id )
                 measures ( last_name, manager_id, department_id, 
                            cast(null as varchar2(25)) as mgr_last_name,
                            0 as mgr_dept_id, '?' as cross_dept )
                    rules ( mgr_last_name[any] = last_name[manager_id[cv()]],
                            mgr_dept_id[any] = department_id[manager_id[cv()]],
                            cross_dept[any] = case
                                                  when department_id[cv()] = mgr_dept_id[cv()] then
                                                      'N'
                                                  when department_id[cv()] is null 
                                                      and mgr_dept_id[cv()] is null 
                                                  then
                                                      'N'
                                              end )               
       ) emp
 where lnnvl(cross_dept = 'N')
       and employee_id <> 100  -- exclude the President
       and manager_id <> 100   -- exclude employees reporting to the President
;