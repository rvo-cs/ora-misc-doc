-- SPDX-FileCopyrightText: 2024 R.Vassallo
-- SPDX-License-Identifier: BSD Zero Clause License

whenever oserror exit failure rollback
@util/demo_sqlplus_init

------------------------------------------------------------------------------------------
column first_name   format a15
column last_name    format a15
column hire_date    format a11 truncate
column city         format a15
column country_id   format a10
column country_name format a20
column region_name  format a15

------------------------------------------------------------------------------------------
set termout off
-- Prevent the optimizer from using a MERGE JOIN here
-- (which could actually be better than the NESTED LOOPS plan)
alter session set "_optimizer_sortmerge_join_enabled" = false;
set termout on

@util/run_demo HR 030-0010-pair-of-nested-loops.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Assuming the above plan uses NESTED LOOPS, a pair of NESTED LOOPS is
prompt ! expected to be used on all contemporary Oracle databases. Here's the
prompt ! alternative plan, as it used to be in, e.g., Oracle 10gR2:
prompt !

@util/demo_pause
@util/demo_set_optim_features_level "10.2.0.5"

@util/run_demo_again HR 030-0010-pair-of-nested-loops.sql
@util/demo_display_cursor

@util/demo_pause
@util/demo_reset_optim_features_level

prompt !
prompt ! Remark: the value of the OPTIMIZER_FEATURES_ENABLE parameter can be found
prompt ! in the outline data section of the plan.
prompt !

@util/demo_outline_hint "hint like 'OPTIMIZER_FEATURES_ENABLE%'"

set termout off
alter session set "_optimizer_sortmerge_join_enabled" = true;
set termout on

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 030-0020-sample-nested-loops-outer.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Note: in NESTED LOOPS OUTER, the row source whose rows are preserved
prompt ! is always the 1st child operation; the "null-generated" row source is
prompt ! always the 2nd child.
prompt !
prompt ! Side note: remember that the predicate for operation 3 is a recount of
prompt ! the whole work driven by the INLIST ITERATOR: an INDEX UNIQUE SCAN can
prompt ! only use a single key at a time.
prompt ! 

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 030-0020-sample-nested-loops-outer-b.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Note how the filter predicate of operation 5 has changed as compared
prompt ! to the previous example: the disjunction on loc.country_id has been
prompt ! buried into an INTERNAL_FUNCTION, and the condition (cou.region_id <> 20)
prompt ! now uses a funnily-looking case expression on loc.country_id, whose result
prompt ! is invariant and equal to 20; this is a by-product of how outer joins in
prompt ! ANSI syntax are rewritten internally into Oracle's native syntax.
prompt !
prompt ! Note, however, that the plan hash value did (probably) not change, though
prompt ! the predicates have: plan hash values don't take predicates into account.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 030-0020-sample-nested-loops-outer-c.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 030-0030-sample-nested-loops-anti.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 030-0030-sample-nested-loops-anti-b.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Expectedly the optimizer has used the same plan as in the prior example:
prompt ! this is a known anti-join pattern. Remark: the IS NULL test must be done
prompt ! on the join column for this to work; using another column could prevent
prompt ! using an anti-join, hence forcing to use an outer join instead, which
prompt ! might not be as efficient.
prompt ! 

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 030-0040-nested-loops-anti-regular.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Next is what happens if the same query is rewritten, by transforming
prompt ! the NOT EXISTS subquery into a NOT IN subquery, but failing to take
prompt ! into account that employees.department_id can be null:
prompt !

@util/demo_pause

define def_cat_sqlfile = "Y"
@util/run_demo_again HR 030-0040-nested-loops-anti-sna.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Note how NESTED LOOPS ANTI has turned into NESTED LOOPS ANTI SNA
prompt ! (SNA stands for: single-null aware), and how an additional full
prompt ! table scan on EMPLOYEES has been added to the plan in order to find
prompt ! rows where department_id is null. Actually, because such rows exist,
prompt ! the NESTED LOOPS ANTI SNA operation itself was not even started.
prompt !
prompt ! This is also an example of a FILTER operation whose 2nd child is
prompt ! processed before the 1st one.
prompt !

@util/demo_pause

prompt !
prompt ! The strange filter( IS NULL) condition for operation 1 is the result
prompt ! of a limitation in how cursor plans are rendered in V$SQL_PLAN. The
prompt ! corresponding predicate from EXPLAIN PLAN is as follows:
prompt !

@util/demo_explain_preds 'sql_id:&&def_prev_sql_id' 1

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 030-0050-sample-nested-loops-semi.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 030-0060-filter-as-nested-loops-semi.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Obviously, the NESTED LOOPS SEMI from the previous example has been
prompt ! changed into a FILTER operation, which turns out to behave similarly
prompt ! to NESTED LOOPS (in this case), in that it uses its 1st child operation
prompt ! as the driving row source, and its 2nd child as the inner row source.
prompt !
prompt ! Note, however, how the count of logical reads is far higher than before,
prompt ! due to operation 3 not pinning buffers anymore, whereas it did in the
prompt ! previous example. This could be verified by examining the deltas in
prompt ! session statistics when running both queries: in the previous example
prompt ! we would see an increase of the "buffer is pinned count" statistic,
prompt ! and the increase of the "session logical reads" statistic would be
prompt ! reduced by a corresponding amount.
prompt !

@util/demo_pause

prompt !
prompt ! Remark: again, we must turn to EXPLAIN PLAN to get the actual text of
prompt ! the filter predicate of operation 1:
prompt !

@util/demo_explain_preds 'sql_id:&&def_prev_sql_id' 1

@util/demo_pause

------------------------------------------------------------------------------------------
variable EMP_FIRST_NAME varchar2(15)

set termout off
exec :EMP_FIRST_NAME := 'Julia';
set termout on

@util/run_demo HR 030-0070-sample-nested-subqueries.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! The plan of the above query may vary, depending on version and optimizer
prompt ! configuration. In case the EXISTS subquery is not unnested, once again
prompt ! pseudo bind-variables (i.e. :B1) will appear in predicates of the nested
prompt ! subquery; their values are passed at runtime from the outer query.
prompt ! 
prompt ! And again, the strange filter( IS NOT NULL) condition would be seen, which
prompt ! only EXPLAIN PLAN could render correctly... assuming EXPLAIN PLAN produced
prompt ! the same plan as the actual cursor to begin with, which it sometimes doesn't.
prompt !

@util/demo_plan_line_id_for_filter '&&def_prev_sql_id' ' IS NOT NULL'

@util/demo_explain_preds 'sql_id:&&def_prev_sql_id' '&&def_filter_plan_line_id'

prompt !
prompt ! Side note: INDEX SKIP SCAN is usually not a desirable operation. In the
prompt ! present case, it's probably just as bad as INDEX FULL SCAN.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
-- As we used EXPLAIN PLAN, we have a pending transaction, so let's close it
set termout off
rollback;
set termout on

@util/demo_clear_columns
@util/demo_sqlplus_cleanup