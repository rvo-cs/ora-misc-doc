-- Same query in native Oracle syntax

select cou.region_id,
       cou.country_name,
       loc.location_id,
       loc.city
  from countries cou,
       locations loc
 where cou.country_id in ('FR', 'DE', 'CA')
   and loc.country_id (+) = cou.country_id
   and case
           when loc.country_id (+) is not null then
               20
           else
               20
       end <> cou.region_id;
