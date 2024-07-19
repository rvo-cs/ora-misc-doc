-- Top 5 highest salaries, using the FETCH FIRST n ROWS ONLY clause
-- (Oracle 12.1 and higher)

select emp.first_name,
       emp.last_name,
       emp.salary,
       emp.commission_pct
  from employees emp
 order by emp.salary desc,
       emp.commission_pct desc nulls last
 fetch first 5 rows only;
