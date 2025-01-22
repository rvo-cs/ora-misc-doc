set echo off
set termout off
set verify off
set serveroutput off

-- for SQLcl only
set sqlformat default

@@run_demo-settings

column c1 noprint new_value 1
column c2 noprint new_value 2
column c3 noprint new_value 3
column cx noprint new_value def_cat_sqlfile
column cy noprint new_value def_hide_results
select
    1 as c1,
    2 as c2,
    3 as c3,
    'x' as cx,
    'y' as cy
from
    dual
where
    null is not null;
column c1 clear
column c2 clear
column c3 clear
column cx clear
column cy clear

define def_schema = "&1"
define def_sqlfile = "&2"
define def_enable_adaptive_plans = "&3"

alter session set current_schema = "&&def_schema";

declare
    e_invalid_option exception;
    pragma exception_init(e_invalid_option, -2248);
begin
    execute immediate
        'alter session set optimizer_adaptive_plans = '
        || nvl('&&def_enable_adaptive_plans', 'false');
exception
    when e_invalid_option then
        null;
end;
/

alter session set statistics_level = all;

column cat_sqlfile  noprint new_value def_cat_sqlfile
column hide_results noprint new_value def_hide_results
select
    nvl2('&&def_cat_sqlfile',  null, '--')  as cat_sqlfile,
    nvl2('&&def_hide_results', null, '--')  as hide_results
from
    dual;
column cat_sqlfile  clear
column hide_results clear

set termout on
@@demo_print_remark&&def_demo_remark_ind..sql

@@demo_cat_sqlfile&&def_cat_sqlfile..sql

@@demo_termout_off&&def_hide_results..sql
@&&def_sqlfile
@@demo_termout_on&&def_hide_results..sql

undefine 1
undefine 2
undefine 3
undefine def_host_cmd_cat
undefine def_host_cmd_rm
undefine def_enable_adaptive_plans
undefine def_schema
undefine def_cat_sqlfile
undefine def_hide_results
undefine def_sqlfile
