-- A contrived example of a match_recognize query: longest sequence of hires with
-- increasing length of their first name

select dense_rank() over (order by match#) as seq_num,
       hire_date, employee_id, first_name
  from ( select mr.*, 
                dense_rank() over (order by row_cnt desc) as match_rank
           from ( select emp.hire_date, emp.employee_id, emp.first_name,
                         length(emp.first_name) as first_name_len
                    from employees emp )
          match_recognize (
              order by hire_date, first_name_len
              measures match_number() as match#,
                       final count(*) as row_cnt
              all rows per match
              after match skip past last row
              pattern (strt incr+)
              define incr as incr.first_name_len = prev(incr.first_name_len) + 1
          ) mr
       )
 where match_rank = 1
 order by seq_num, hire_date, first_name_len;
 