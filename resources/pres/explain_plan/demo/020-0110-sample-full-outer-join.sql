-- Example of a full outer join

select loc.city, dep.department_name
  from ( select location_id, city
           from locations
          where city in ('Whitehorse', 'Toronto')
       ) loc
  full outer join
       ( select department_id, location_id, department_name
           from departments
          where department_id in (20, 230)
       ) dep
       on dep.location_id = loc.location_id;
