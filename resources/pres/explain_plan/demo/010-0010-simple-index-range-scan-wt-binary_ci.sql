-- Same query, using the COLLATE operator in the 2nd LIKE condition
-- (Oracle 12.2 and higher)

select cnt.country_id,
       cnt.country_name
  from countries cnt
 where cnt.country_id like 'C%'
   and cnt.country_name like '%A' collate binary_ci;
