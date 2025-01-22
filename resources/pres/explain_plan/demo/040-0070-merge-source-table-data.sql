-- We'll use the following data in the next examples

select sr.employee_id, sr.salary_incr_pct, sr.reason
  from &_USER..salary_raises sr;
