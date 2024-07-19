set termout off
set verify off

column c1 noprint new_value 1
select 
    1 as c1
from
    dual
where
    null is not null;
column c1 clear

define def_outline_data_filter = "&1"

column outline_data_filter noprint new_value def_outline_data_filter
select
    nvl(q'{&&def_outline_data_filter}', '1 = 1') as outline_data_filter
from
    dual;
column outline_data_filter clear

define def_plan_id = ""

column plan_id noprint new_value def_plan_id
select
    max(pt.plan_id) as plan_id
from
    plan_table pt
where
    pt.statement_id = 'sql_id:&&def_prev_sql_id'
    and pt.id = 0;
column plan_id clear

set termout on

column hint format a140 word_wrapped
select
    sqh.hint
from
    plan_table pln,
    xmltable('/other_xml/outline_data/hint' 
             passing xmltype(pln.other_xml)
             columns hint varchar2(500) path '.') sqh
where
    pln.plan_id = '&&def_plan_id'
    and pln.id = 1
    and (&&def_outline_data_filter)
;
column hint clear

set verify on

undefine def_plan_id
undefine def_outline_data_filter