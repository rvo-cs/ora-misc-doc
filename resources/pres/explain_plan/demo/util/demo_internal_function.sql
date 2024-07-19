define def_internal_function_ind = "--"

set termout off
set verify off

column is_internal_function noprint new_value def_internal_function_ind
select
    case
        when count(*) > 0 then
            null
        else
            '--'
    end as is_internal_function
from 
    v$sql_plan pln
where 
    pln.sql_id = '&&def_prev_sql_id' 
    and pln.child_number = '&&def_prev_child_number'
    and pln.filter_predicates like '%INTERNAL_FUNCTION(%';
column is_internal_function clear

set verify on
set termout on

@@demo_internal_function-comment&&def_internal_function_ind..sql

undefine def_internal_function_ind