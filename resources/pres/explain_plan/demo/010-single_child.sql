-- SPDX-FileCopyrightText: 2024 R.Vassallo
-- SPDX-License-Identifier: BSD Zero Clause License

whenever oserror exit failure rollback
@util/demo_sqlplus_init

------------------------------------------------------------------------------------------
column country_id   format a10
column country_name format a20

@util/run_demo HR 010-0010-simple-index-range-scan.sql
@util/demo_display_cursor

@util/demo_pause

prompt !
prompt ! This example illustrates the difference between ACCESS conditions
prompt ! and FILTER conditions in predicates. Also note the extra "IS NOT NULL"
prompt ! condition in FILTER predicates.
prompt !

@util/demo_explain_preds "sql_id:&&def_prev_sql_id" 1

@util/demo_pause
@util/demo_clear_columns

------------------------------------------------------------------------------------------
column country_id   format a10
column country_name format a20

define def_cat_sqlfile = "Y"
@util/run_demo_again HR 010-0010-simple-index-range-scan-wt-binary_ci.sql
@util/demo_display_cursor

@util/demo_pause
@util/demo_clear_columns

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0020-table-access-by-index-rowid.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0030-inlist-iterator.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Note how the predicate of operation 3 is (only) a convenient recount of
prompt ! the work driven by the INLIST INTERATOR: actually the INDEX RANGE SCAN
prompt ! was started 3 times, each time using a single key from the INLIST ITERATOR;
prompt ! so this predicate (in the form of a disjunction) decribes the work done
prompt ! through all iterations, not how each iteration was actually performed.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0040-index-range-scan-wt-child.sql
@util/demo_display_cursor

@util/demo_pause

prompt !
prompt ! Note the :B1 bind variable in predicates pertaining to the subquery
prompt ! Also note the bizarre filter( IS NOT NULL) condition at line 2: this
prompt ! is one of the conditions which dbms_xplan.display_cursor can not
prompt ! render properly; EXPLAIN PLAN must be used in order to see it.
prompt !

@util/demo_explain_preds 'sql_id:&&def_prev_sql_id' 2

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0050-group-by-having-sample.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
variable INDIC varchar2(1)

set termout off
exec :INDIC := 'X';
set termout on

@util/run_demo HR 010-0060-filter-wt-pre-eval.sql
@util/demo_display_cursor

@util/demo_pause

prompt !
prompt ! Above the value of :INDIC was 'X'. If we run the same query
prompt ! with :INDIC set to null, operations below the FILTER operation
prompt ! at line 3 are not being run
prompt !

set termout off
exec :INDIC := null;
set termout on

@util/run_demo_again HR 010-0060-filter-wt-pre-eval.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0070-count-stopkey-sample.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Note how the filter(ROWNUM<=5) condition appears on both lines 1 and 3
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/demo_set_optim_features_level "12.2.0.1"
@util/run_demo HR 010-0080-fetch-first-n-rows-sample.sql
@util/demo_display_cursor

@util/demo_internal_function
@util/demo_reset_optim_features_level
@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0090-window-sort-sample.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0090-window-sort-sample-21c.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0100-sample-model-clause.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 010-0110-sample-match_recognize.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
-- As we used EXPLAIN PLAN, we have a pending transaction, so let's close it
set termout off
rollback;
set termout on

@util/demo_sqlplus_cleanup