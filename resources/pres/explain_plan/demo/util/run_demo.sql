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
select
    1 as c1,
    2 as c2,
    3 as c3
from
    dual
where
    null is not null;
column c1 clear
column c2 clear
column c3 clear

define def_schema = "&1"
define def_sqlfile = "&2"
define def_enable_adaptive_plans = "&3"

column demo_num noprint new_value def_demo_num
column banner   noprint new_value def_banner
with
demo_number(n, n_as_text) as (
    select 
        &&def_demo_num + 1,
        '[ Demo #' || to_char(&&def_demo_num + 1) || ' ]'
    from
        dual
)
select
    n as demo_num,
    rpad('=', 50 - floor(length(n_as_text) / 2), '=') 
        || n_as_text
        || rpad('=', 50 - ceil(length(n_as_text) / 2), '=') as banner
from
    demo_number;
column demo_num clear
column banner   clear

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

set termout on
prompt
prompt &&def_banner
prompt
@@demo_print_remark&&def_demo_remark_ind..sql

@@demo_cat_sqlfile.sql

@&&def_sqlfile

undefine 1
undefine 2
undefine 3
undefine def_host_cmd_cat
undefine def_host_cmd_rm
undefine def_enable_adaptive_plans
undefine def_schema
undefine def_sqlfile
undefine def_banner