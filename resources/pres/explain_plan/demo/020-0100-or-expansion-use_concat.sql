-- Last name, job title, city of location, of employees meeting 1 of the 2 conditions
-- (version with the USE_CONCAT hint)

select /*+ use_concat */
       emp.last_name, job.job_title, loc.city
  from jobs job,
       employees emp,
       departments dep,
       locations loc
 where job.job_id = emp.job_id
   and emp.department_id = dep.department_id
   and dep.location_id = loc.location_id
   and (emp.email = 'HBROWN' or job.job_id = 'HR_REP');
