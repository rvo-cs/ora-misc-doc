set echo off
set pagesize 50000
set long 200000
set linesize 200
set trimspool on

@@run_demo-settings

define def_prev_sql_id = ""
define def_prev_child_number = ""

set termout off
column prev_sql_id       noprint new_value def_prev_sql_id
column prev_child_number noprint new_value def_prev_child_number
select
    ses.prev_sql_id,
    to_char(ses.prev_child_number) as prev_child_number
from
    v$session ses
where
    ses.sid = sys_context('USERENV', 'SID');
column prev_sql_id       clear
column prev_child_number clear
set termout on

set verify off
set heading off
set feedback off
with
db_release_level as (
    select
        to_number(substr(comp.version, 1, instr(comp.version, '.') - 1))  as version
    from
        sys.product_component_version comp
    where
        comp.product like 'Oracle Database %'
        and rownum = 1
),
display_plan_options as (
    select
        'Advanced -outline -projection '
            || case
                   when lev.version >= 12 then
                       '+adaptive '
               end
            || case
                   when lev.version >= 19 then
                       '-qbregistry -hint_report '
               end
            || case
                   when lev.version >= 23 then
                       '-sql_analysis_report '
               end
            || '+allstats last '
        as plan_options
    from
        db_release_level lev
),
target_cursor_plus as (
    select
        'sql_id = ''&&def_prev_sql_id'' and child_number = &&def_prev_child_number'  as filter_preds,
        'SQL_ID &&def_prev_sql_id, child number &&def_prev_child_number'  as label,
        plan_options
    from
        display_plan_options
)
select
    cast(a.label as varchar2(300)) as plan_table_output
from
    target_cursor_plus a
union all
select b.*
from 
    target_cursor_plus a,
    table(dbms_xplan.display(
            table_name   => 'V$SQL_PLAN_STATISTICS_ALL',
            statement_id => null,
            format       => a.plan_options,
            filter_preds => a.filter_preds
    )) b
;

set termout off
spool .demo_explain_temp.sql replace
column explain_stmt format a250
select
    case
        when gen.n = 1 then
            sql.explain_1
        else
            sql.explain_2
    end as explain_stmt
from
    (select rownum as n from dual connect by level <= 2) gen,
    (select
        to_clob('explain plan set statement_id = ''sql_id:&&def_prev_sql_id'' for') as explain_1,
        sqa.sql_fulltext || ';' as explain_2
    from 
        v$sqlarea sqa,
        v$sqlcommand cmd
    where
        sqa.sql_id = '&&def_prev_sql_id'
        and sqa.command_type = cmd.command_type
        and /*
              if the target statement caused an error (e.g. unsupported SQL feature),
              &&def_prev_sql_id would be that of the PL/SQL anonymous block that was run
              prior to the target statement; in that case we don't emit the EXPLAIN PLAN
              for that statement.
             */
            cmd.command_name in ('DELETE', 'INSERT', 'SELECT', 'UPDATE', 'UPSERT')
    ) sql
order by
    gen.n;
column explain_stmt clear
spool off
@.demo_explain_temp.sql
host &&def_host_cmd_rm .demo_explain_temp.sql
set termout on

set heading on
set feedback on
set verify on

undefine def_host_cmd_cat
undefine def_host_cmd_rm

/* 
REMARK: purposely keeping the following substitution variables:
    . def_prev_sql_id
    . def_prev_child_number
*/
