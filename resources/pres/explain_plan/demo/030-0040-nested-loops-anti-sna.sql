-- Departments, with a "T" in their name, not having any employee
-- Non-equivalent rewrite because employees.department_id can be null

select dep.department_id, dep.department_name
  from departments dep
 where dep.department_name like '%T%' 
   and dep.department_id not in ( select emp.department_id
                                    from employees emp );
