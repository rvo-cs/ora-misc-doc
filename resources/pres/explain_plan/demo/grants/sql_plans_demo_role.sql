-- This script must be run with SYSDBA privileges

create role SQL_PLANS_DEMO_ROLE;

revoke SQL_PLANS_DEMO_ROLE from &&_USER;

grant CREATE SESSION                            to  SQL_PLANS_DEMO_ROLE;
grant CREATE TABLE                              to  SQL_PLANS_DEMO_ROLE;

grant SELECT on SYS.V_$SESSION                  to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.V_$PARAMETER                to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.V_$SQL                      to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.V_$SQLAREA                  to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.V_$SQLCOMMAND               to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.V_$SQL_PLAN                 to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.V_$SQL_PLAN_STATISTICS_ALL  to  SQL_PLANS_DEMO_ROLE;

grant SELECT on SYS.GV_$SESSION                 to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.GV_$PARAMETER               to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.GV_$SQL                     to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.GV_$SQLAREA                 to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.GV_$SQLCOMMAND              to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.GV_$SQL_PLAN                to  SQL_PLANS_DEMO_ROLE;
grant SELECT on SYS.GV_$SQL_PLAN_STATISTICS_ALL to  SQL_PLANS_DEMO_ROLE;

grant SELECT on HR.REGIONS                      to  SQL_PLANS_DEMO_ROLE;
grant SELECT on HR.LOCATIONS                    to  SQL_PLANS_DEMO_ROLE;
grant SELECT on HR.DEPARTMENTS                  to  SQL_PLANS_DEMO_ROLE;
grant SELECT, INSERT, UPDATE, DELETE on HR.EMPLOYEES  to  SQL_PLANS_DEMO_ROLE;
grant SELECT, INSERT, UPDATE, DELETE on HR.JOBS to  SQL_PLANS_DEMO_ROLE;
grant SELECT on HR.JOB_HISTORY                  to  SQL_PLANS_DEMO_ROLE;
grant SELECT on HR.COUNTRIES                    to  SQL_PLANS_DEMO_ROLE;

-- Remark: the DELETE and UPDATE privileges on HR.JOBS are required, not for 
-- the purpose of actually deleting or updating rows in that table, but simply
-- because it appears in inline views through which DELETE and UPDATE commands
-- are being run--even though the HR.JOBS table itself is not modified.

