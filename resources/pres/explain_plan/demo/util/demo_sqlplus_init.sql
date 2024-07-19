clear screen
set linesize 200

define def_demo_num = 0
define def_demo_remark_ind = "--"

-- Prevent from SQL*Plus making calls to dbms_application_info,
-- thereby changing v$session.prev_sql_id before we can fetch it
--
set appinfo off

-- Some queries in this demo may use SQL features available only
-- in recent releases of the RDBMS; running these queries against
-- prior versions will cause SQL errors
--
whenever sqlerror continue none

set termout off
alter session set nls_date_format = 'YYYY-MM-DD HH24:MI:SS';
set termout on