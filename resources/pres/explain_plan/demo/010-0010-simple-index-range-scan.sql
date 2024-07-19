-- A simple query, resolved in 1 index range scan

select cnt.country_id,
       cnt.country_name
  from countries cnt
 where cnt.country_id like 'C%'
   and cnt.country_name like '%a';
