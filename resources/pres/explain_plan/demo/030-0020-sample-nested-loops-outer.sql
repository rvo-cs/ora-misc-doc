-- Countries with specified values of country_id, along with their locations, if any

select cou.country_id,
       cou.country_name,
       loc.location_id,
       loc.city
  from locations loc 
 right join countries cou on cou.country_id = loc.country_id
 where cou.country_id in ('FR', 'DE', 'CA');
