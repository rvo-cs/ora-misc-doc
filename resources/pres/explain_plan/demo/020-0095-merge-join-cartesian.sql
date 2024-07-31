-- Join condition omitted for demonstration purposes

select reg.region_id, reg.region_name, 
       job.job_id, job.job_title
  from regions reg,
       jobs job
 where job.job_id like 'SA%';
