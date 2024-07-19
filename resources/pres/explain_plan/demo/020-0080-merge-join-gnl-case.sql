-- Jobs with salaries always higher than salaries in other jobs, excluding
-- the cases of managers vs non-managers, and of the President + vice-presidents

select jhi.job_title as job_title,
       jhi.min_salary as min_salary, 
       jlo.job_title as job_title_2,
       jlo.max_salary as max_salary
  from jobs jhi,
       jobs jlo
 where jlo.max_salary < jhi.min_salary
       and jhi.job_title not like '%President'
       and not (jhi.job_title like '%Manager' and jlo.job_title not like '%Manager');
