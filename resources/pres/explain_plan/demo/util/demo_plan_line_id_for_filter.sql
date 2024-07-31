set echo off
set verify off
set feedback off
set termout off

column c3 noprint new_value 3
select
    3 as c3
from
    dual
where
    null is not null;
column c3 clear

define def_target_sqlid = "&1"
define def_filter_pred  = "&2"
define def_occ_number   = "&3"

define def_filter_plan_line_id = "0"

column plan_line_id noprint new_value def_filter_plan_line_id
select
    id as plan_line_id
from
    (select
        pln.id,
        row_number() over (order by pln.id) as rn
    from 
        (select
            sql1.*
        from
            (select
                sql0.sql_id,
                sql0.plan_hash_value
            from
                v$sql sql0
            where
                sql0.sql_id = '&&def_target_sqlid'
            order by
                sql0.last_active_time desc
            ) sql1
        where
            rownum = 1
        ) sql,          -- last active cursor with this sql_id
        v$sql_plan pln  -- corresponding plan
    where
        pln.sql_id = sql.sql_id
        and pln.plan_hash_value = sql.plan_hash_value
        and pln.filter_predicates = q'{&&def_filter_pred}'
        and pln.plan_hash_value = 
                -- verify that explain plan produced the same plan hash as this cursor
                (select 
                    regexp_substr(pto.plan_table_output, 
                            '^Plan hash value: (\d+)$', 1, 1, null, 1) as explain_plan_hash_value
                from 
                    table(dbms_xplan.display('PLAN_TABLE', 'sql_id:&&def_target_sqlid', 'basic')) pto
                where 
                    rownum = 1
                )
    )
where
    rn = to_number(nvl('&&def_occ_number', '1'));
column plan_line_id clear

undefine 1
undefine 2
undefine 3
undefine def_target_sqlid
undefine def_filter_pred
undefine def_occ_number
