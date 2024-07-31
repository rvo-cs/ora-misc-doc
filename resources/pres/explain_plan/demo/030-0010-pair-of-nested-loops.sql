-- Countries whose identifiers start with a "C"

select cnt.country_id,
       cnt.country_name,
       reg.region_name
  from countries cnt,
       regions reg
 where cnt.country_id like 'C%'
   and cnt.region_id = reg.region_id;
