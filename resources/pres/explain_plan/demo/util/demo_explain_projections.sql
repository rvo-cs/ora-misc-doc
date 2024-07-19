set echo off
define def_stmt_id = "&1"
define def_extr_cnd = "&2"

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
column projection format a140 word_wrapped
select
    pt.id,
    pt.projection
from
    plan_table pt
where
    pt.statement_id = '&&def_stmt_id'
    and &&def_extr_cnd
order by
    id
;
column id         clear
column projection clear

set verify on
set feedback on

undefine 1
undefine 2
undefine def_plan_id
undefine def_stmt_id
undefine def_extr_cnd
