-- Departments, with a "T" in their name, not having any employee

select dep.department_id, dep.department_name
  from departments dep
 where dep.department_name like '%T%' 
   and not exists ( select 1 from employees emp
                     where emp.department_id = dep.department_id );
