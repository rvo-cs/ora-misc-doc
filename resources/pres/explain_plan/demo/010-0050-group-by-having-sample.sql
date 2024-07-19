-- HAVING is typically implemented by a single-child FILTER

select emp.job_id,
       count(*) as cnt_emp,
       min(salary) as min_sal,
       round(avg(salary)) as avg_sal,
       round(percentile_cont(0.9) within group (order by salary)) as pct90_sal,
       max(salary) as max_sal
  from employees emp
 group by emp.job_id
having count(*) >= 10 and avg(salary) >= 3000;
