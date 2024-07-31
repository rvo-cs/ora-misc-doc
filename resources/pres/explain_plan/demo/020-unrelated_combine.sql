-- SPDX-FileCopyrightText: 2024 R.Vassallo
-- SPDX-License-Identifier: BSD Zero Clause License

whenever oserror exit failure rollback
@util/demo_sqlplus_init

------------------------------------------------------------------------------------------
column first_name      format a15
column last_name       format a15
column manager_name    format a15
column hire_date       format a11 truncate
column city            format a25
column department_name format a20
column job_title       format a20
column job_title_2     format a20
------------------------------------------------------------------------------------------
@util/run_demo HR 020-0010-plain-hash-join-sample.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Note that the inequality (emp.salary > mgr.salary) is being used
prompt ! as a FILTER condition: in HASH JOINs, ACCESS conditions are always 
prompt ! conjunctions of equalities; non-equality conditions always apply
prompt ! (subsequently) as filters.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0020-sample-hash-join-outer.sql
@util/demo_display_cursor

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0030-hash-join-outer-simple.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Note: the --+ full(loc) hint was used above in order to produce a
prompt ! simple plan using only outer HASH JOINs and full scans; here's what
prompt ! happens when that hint is removed
prompt !

@util/demo_pause

@util/run_demo_again HR 020-0030-hash-join-outer-wt-index-join.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! The optimizer has (expectedly) produced a different plan with one
prompt ! additional HASH JOIN between 2 indexes of the LOCATIONS table; the
prompt ! plan with that "index join" comes with a lower estimated cost, but
prompt ! in practice it may well turn out to use a few more logical reads
prompt ! than the simpler plan. ("Your mileage may vary.")
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0040-hash-join-right-anti.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! The expected operation above is HASH JOIN RIGHT ANTI, or perhaps
prompt ! just HASH JOIN ANTI if we didn't project enough columns to make it
prompt ! worth doing it that way, rather than the other way around. Inputs of
prompt ! hash joins can always be swapped, which means that for each asymmetric
prompt ! HASH JOIN XXX operation, a corresponding HASH JOIN RIGHT XXX exists.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
-- 23ai Free (23.4) does not correctly unnest the subquery in the following demo
-- query, unless the optimizer_features_enable parameter is lowered to 21.1.0
@util/demo_set_optim_features_level "21.1.0"

@util/run_demo HR 020-0050-hash-join-semi.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Expected operation: HASH JOIN SEMI, between:
prompt !   . EMPLOYEES (EMP@SEL$1), and:
prompt !   . the VW_SQ_1 inline view, created as a result
prompt !     of unnesting the subquery
prompt !

@util/demo_reset_optim_features_level
@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0060-emp-mgr-in-separate-dept-1.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Nothing fancy above: 1 HASH JOIN, and 2 HASH JOIN OUTER...
prompt ! Now, let's see a (bad) way of writing a similar query using
prompt ! MINUS. (Note: that version of the query is ugly and slower,
prompt ! don't do that! This is for demonstration purposes only.)
prompt !

@util/demo_pause

define def_cat_sqlfile = "Y"
@util/run_demo_again HR 020-0060-emp-mgr-in-separate-dept-2-minus.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! Note that MINUS has 2 child operations, which it runs in turn,
prompt ! and requires them to present their rows sorted and unique.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0070-sample-union-all.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! UNION ALL has as many children as there are subqueries put
prompt ! together in the UNION ALL query.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0080-merge-join-gnl-case.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! This is the general case of a MERGE JOIN, in which both inputs
prompt ! are sorted according to the join key, and read once. Note that
prompt ! the Starts column, in the case of plan lines 4 and 5, does not
prompt ! tell how many times either operation was started, but how many
prompt ! times the corresponding workarea was probed when merging. The
prompt ! underlying TABLE ACCESS FULL (line 6) happened only once.
prompt !

@util/demo_explain_projections "sql_id:&&def_prev_sql_id" "operation='SORT' and options='JOIN'"
@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0090-merge-join-wt-index.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! In this MERGE JOIN, rows from the first join input are already sorted,
prompt ! as the order is provided by the INDEX FULL SCAN at line 3; therefore 
prompt ! it is unnecessary to add a SORT step (+ the corresponding workarea) for
prompt ! processing that input. In that case, the 2nd input is read and sorted
prompt ! before finishing to read the 1st input (provided the 1st input returns
prompt ! at least one row). Processing is otherwise similar to the general case.
prompt !
prompt ! In particular, note how the join condition is always borne, in the plan
prompt ! readout, by the SORT operation of the 2nd join input.
prompt !

@util/demo_explain_projections "sql_id:&&def_prev_sql_id" "operation='SORT' and options='JOIN'"
@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0095-merge-join-cartesian.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! In MERGE JOIN CARTESIAN, not to be confused with MERGE JOIN, there isn't
prompt ! a join condition between the 2 join inputs, which entirely removes the
prompt ! need to sort rows. Meanwhile, a data structure is still needed to buffer
prompt ! rows from the 2nd join input, so it can be scanned only once. For some
prompt ! reason, the operation which gets rows from the 2nd join input and stores
prompt ! them into this data structure is named BUFFER SORT, though it does not
prompt ! actually sort.
prompt !
prompt ! For details about BUFFER SORT, please see:
prompt ! https://jonathanlewis.wordpress.com/2006/12/17/buffer-sorts/
prompt !
prompt ! Again, the Starts column for the BUFFER SORT plan operation records how
prompt ! many times its data structure was probed.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
column job_title format a35

@util/run_demo HR 020-0100-or-expansion-disabled.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! The above plan should be similar to the one produced on 11.2, or perhaps
prompt ! simpler because the hints prevent index joins from being used. Now let's
prompt ! see what happens if the same query is run without any hint.
prompt !

@util/demo_pause

define def_cat_sqlfile = "Y"
@util/run_demo_again HR 020-0100-or-expansion-unhinted.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! If using Oracle 12.2 and higher, expectedly the plan will have changed
prompt ! dramatically: the VIEW operation with VW_ORE_xxxxxxxx as its object name,
prompt ! followed by a UNION ALL operation as its single child, is characteristic
prompt ! of the OR-expansion transformation.
prompt !

@util/demo_pause

prompt ! If tested on Oracle 12.1 or earlier, the plan probably has the same
prompt ! global shape as before, perhaps with index joins added. On all versions
prompt ! it is still possible to use the CONCATENATION transformation, which is
prompt ! quite similar to OR-expansion, though not identical. Here's how the plan
prompt ! looks if forcing that transformation by adding the USE_CONCAT hint:
prompt !

@util/demo_pause

define def_cat_sqlfile = "Y"
@util/run_demo_again HR 020-0100-or-expansion-use_concat.sql
@util/demo_display_cursor

prompt
prompt !
prompt ! The CONCATENATION operation behaves similarly to UNION ALL. Here the
prompt ! plan readout shows that the estimated cost is not better than in the
prompt ! case of the unhinted query, which is why the optimizer did not choose
prompt ! to use that transformation in the first place. Here this plan also
prompt ! turns out to do more logical reads than the initial plan above.
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
@util/run_demo HR 020-0110-sample-full-outer-join.sql

@util/demo_display_cursor

prompt
prompt !
prompt ! Remarks:
prompt !
prompt ! 1) AFAIK, there isn't a "native Oracle syntax" for full outer joins
prompt !
prompt ! 2) The alternative plan, using a UNION ALL of an outer join and an
prompt !    anti-join (rather than the native HASH JOIN FULL OUTER operation)
prompt !    can be forced using the (documented) no_native_full_outer_join hint
prompt !

@util/demo_pause

------------------------------------------------------------------------------------------
-- As we used EXPLAIN PLAN, we have a pending transaction, so let's close it
set termout off
rollback;
set termout on

@util/demo_clear_columns
@util/demo_sqlplus_cleanup