-- SPDX-FileCopyrightText: 2025 R.Vassallo
-- SPDX-License-Identifier: BSD Zero Clause License

whenever oserror exit failure rollback
@util/demo_sqlplus_init

------------------------------------------------------------------------------------------
column last_name       format a15
column comm_pct_compar format a15
column comm_pct_indic  format a15
column commission_pct  format 0.99
column avg_comm_pct    format 0.99
column reason          format a25
------------------------------------------------------------------------------------------

@util/run_demo HR 040-0010-subq-in-select-list-01.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! The scalar subquery is unnested (expectedly) and transformed into the
prompt ! VW_SSQ_1 inline view, outer-joined to the main query. Note the "ITEM_1"
prompt ! column name of the join key in predicate 1; column projections might
prompt ! help to figure out the originating columns or expressions.
prompt !

@util/demo_explain_projections "sql_id:&&def_prev_sql_id" "(id,operation) in ((4,'VIEW'), (5,'HASH'), (6,'TABLE ACCESS'))"

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 040-0020-subq-in-select-list-02-a.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Here the 2 scalar subqueries have not been unnested, therefore they appear
prompt ! as the first 2 children of the SELECT operation. The main query is the last
prompt ! child of the SELECT operation. Note that the scalar subquery cache is being
prompt ! used, saving a couple of starts of the 2 subqueries.
prompt !
prompt ! Also note that the Buffers column is (obviously) wrong for the SELECT
prompt ! operation: it counts only the buffer gets of the main query, ignoring
prompt ! those of the 2 subqueries. This is an old bug. The value is correct if
prompt ! an ORDER BY clause is used.
prompt !

@util/demo_pause

prompt ! Same query, with an ORDER BY clause added

define def_hide_results = 'Y'
@util/run_demo_again HR 040-0020-subq-in-select-list-02-b.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! In the above plan the buffer gets of the 2 nested subqueries are
prompt ! (expectedly) added to the total of the SORT ORDER BY operation in
prompt ! the main query, and to that of the top-level SELECT operation.
prompt ! 

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 040-0030-subq-in-update-stmt.sql
rollback;

@util/demo_display_cursor

prompt
prompt !
prompt ! Note how the "gap" nested subquery appears as the 2nd child of
prompt ! the UPDATE operation, while the "minsal" nested subquery is the
prompt ! 2nd child of the FILTER operation. Also note that the "minsal"
prompt ! subquery is started only 19 times, and the "gap" subquery only
prompt ! twice, thanks to the scalar subquery cache.
prompt !
prompt ! Remark: A-Rows is always 0 for the UPDATE and the UPDATE STATEMENT
prompt ! operations, even though actually we updated 3 rows; this is because
prompt ! no row is to be passed to the parent operation (or to the caller)
prompt ! from that point on. DELETE and MERGE behave similarly.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 040-0040-update-inline-view.sql
rollback;

@util/demo_display_cursor

prompt
prompt !
prompt ! Not only is this version of the UPDATE statement easier to
prompt ! understand; it also requires far fewer logical reads.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 040-0050-delete-inline-view.sql
rollback;

@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 040-0060-subq-in-delete-stmt-a.sql
rollback;

@util/demo_display_cursor

prompt
prompt !
prompt ! This version is (probably) not as efficient as the previous one.
prompt !
prompt ! Remark: in case you're wondering why the count of logical reads of these
prompt ! 2 DELETE statements is so high as compared to the UPDATE statements seen
prompt ! earlier, and you notice that the DELETE operation itself bears the largest
prompt ! part, remember that there are enabled foreign-key constraints referencing
prompt ! the EMPLOYEES table: running the recursive SQL queries required to enforce
prompt ! these constraints means doing many additional logical reads which must be
prompt ! accounted for, even though the recursive queries and the corresponding
prompt ! SQL plans are not visible in the readout.
prompt !
prompt ! (If you compare the 2 plans, usually you'll find that the DELETE operation
prompt ! makes the same amount of extra logical reads in addition to those made by
prompt ! its child operation.)
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 040-0060-subq-in-delete-stmt-b.sql
rollback;

@util/demo_display_cursor

prompt
prompt !
prompt ! This time (expectedly) the optimizer unnests the subquery, producing
prompt ! the same plan as the version using the inline view.
prompt !

@util/demo_pause

prompt !
prompt ! Using an EXIST subquery also results in an optimized plan, where the
prompt ! subquery is unnested and merged with the main query block.
prompt !
prompt

define def_cat_sqlfile = "Y"
@util/run_demo_again HR 040-0060-subq-in-delete-stmt-c.sql
rollback;

@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
set termout off
create global temporary table &_USER..salary_raises (
    employee_id, salary_incr_pct, reason
)
on commit preserve rows
as
    select 108 , 12   , 'Outstanding results'  from dual  union all
    select 109 ,  2.5 , 'Great results'        from dual  union all
    select 112 , 25   , 'Awesome results!'     from dual
;
set termout on

@util/run_demo HR 040-0070-merge-source-table-data.sql

@util/demo_pause

define def_cat_sqlfile = "Y"
@util/run_demo_again HR 040-0070-merge-subq-in-update-where-a.sql

rollback;

@util/demo_display_cursor

prompt
prompt !
prompt ! In this MERGE statement, the nested subquery in the WHERE clause
prompt ! of the merge_update_clause appears as the 2nd child of the MERGE
prompt ! operation. Remember that in the merge_update_clause, the WHERE
prompt ! clause always acts as a filter, never as an access criterion.
prompt ! Also note that the predicate used in that WHERE clause is omitted
prompt ! in the readout.
prompt !

@util/demo_pause

prompt !
prompt ! Another thing to know about MERGE statements is that all columns
prompt ! from the source and target tables are always projected, including
prompt ! columns which are not used at all in the statement.
prompt !

@util/demo_explain_projections "sql_id:&&def_prev_sql_id" "(id > 1 and lnnvl(qblock_name = 'SEL$2'))"

@util/demo_pause

prompt !
prompt ! Workaround: use inline views for both the source and the target
prompt ! of the MERGE statement, as follows:
prompt !
prompt

define def_cat_sqlfile = "Y"
@util/run_demo_again HR 040-0070-merge-subq-in-update-where-b.sql

rollback;

@util/demo_display_cursor

prompt
prompt !
prompt ! Note that the plan for this version is (expectedly) unchanged,
prompt ! even though column projections are different:
prompt !

@util/demo_explain_projections "sql_id:&&def_prev_sql_id" "(id > 1 and lnnvl(qblock_name = 'SEL$6'))"

prompt
prompt !
prompt ! This is yet another way in which distinct cursors can share the
prompt ! same plan: column projections are ignored in plan hash values,
prompt ! just as predicates are.
prompt !

set termout off
truncate table &&_USER..salary_raises;
drop table &&_USER..salary_raises purge;
set termout on

------------------------------------------------------------------------------------------
-- As we used EXPLAIN PLAN, we have a pending transaction, so let's close it
set termout off
rollback;
set termout on

@util/demo_clear_columns
@util/demo_sqlplus_cleanup
