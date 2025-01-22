-- Subquery in the SELECT-list, case #2

select emp.employee_id, emp.last_name, emp.commission_pct,
       ( select case
                   when emp.commission_pct > avg(sub1.commission_pct) then 'GT'
                   when emp.commission_pct = avg(sub1.commission_pct) then 'EQ'
                   else 'LT'
                end
           from employees sub1
           where sub1.manager_id = emp.manager_id
       ) as comm_pct_compar,
       ( select case emp.commission_pct
                   when max(sub2.commission_pct) then 'MAX'
                   when min(sub2.commission_pct) then 'MIN'
                end
           from employees sub2
          where sub2.manager_id = emp.manager_id
       ) as comm_pct_indic
  from employees emp
 where emp.commission_pct is not null
   and emp.manager_id = 100;
