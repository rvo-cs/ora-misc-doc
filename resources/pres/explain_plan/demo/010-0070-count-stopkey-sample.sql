-- Top 5 highest salaries

select *
  from ( select emp.first_name,
                emp.last_name,
                emp.salary,
                emp.commission_pct
           from employees emp
          order by emp.salary desc, 
                emp.commission_pct desc nulls last )
 where rownum <= 5;
