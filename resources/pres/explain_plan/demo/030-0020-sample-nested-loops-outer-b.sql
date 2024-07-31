-- Countries with specified values of country_id, along with their locations, if any,
-- not joining locations for countries in region 20

select cou.region_id,
       cou.country_id,
       cou.country_name,
       loc.location_id,
       loc.city
  from countries cou
  left join locations loc on loc.country_id = cou.country_id
                         and cou.region_id <> 20
 where cou.country_id in ('FR', 'DE', 'CA');
