set echo off
define def_stmt_id = "&1"
define def_line_id = "&2"

set verify off
set feedback off

set termout off
define def_plan_id = ""
column plan_id noprint new_value def_plan_id
select
    max(pt.plan_id) as plan_id
from
    plan_table pt
where
    pt.statement_id = '&&def_stmt_id'
    and pt.id = 0;
column plan_id clear
set termout on
 
column id         format 999
column pred_type  format a10 
column predicates format a140 word_wrapped
select 
    *
from 
    (select
        pt.id,
        pt.access_predicates,
        pt.filter_predicates
    from
        plan_table pt
    where
        pt.statement_id = '&&def_stmt_id'
        and pt.plan_id = &&def_plan_id
        and pt.id = &&def_line_id
    )    
    unpivot exclude nulls
    (predicates for pred_type in (
        access_predicates as 'ACCESS',
        filter_predicates as 'FILTER'
    ))
order by
    pred_type
;
column id         clear
column pred_type  clear
column predicates clear

set verify on
set feedback on

undefine 1
undefine 2
undefine def_plan_id
undefine def_stmt_id
undefine def_line_id
