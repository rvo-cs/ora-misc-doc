-- Count of employees per city and department

select --+ full(loc)
       loc.city,
       dep.department_name,
       count(*) as cnt_emp
  from employees emp,
       departments dep,
       locations loc
 where dep.department_id (+) = emp.department_id
   and loc.location_id (+) = dep.location_id
 group by loc.city,
       dep.department_name
 order by sum(cnt_emp) over (partition by loc.city) desc, 
       loc.city, 
       cnt_emp desc,
       dep.department_name;