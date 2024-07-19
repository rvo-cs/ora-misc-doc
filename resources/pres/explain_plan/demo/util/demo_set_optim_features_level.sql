define def_new_optim_features_lvl = "&1"

set termout off
set verify off

variable DEMO_OPTIM_FEATURES_LVL_OLD varchar2(20)
variable DEMO_OPTIM_FEATURES_LVL_TXT varchar2(100)

declare
    e_invalid_value exception;
    pragma exception_init(e_invalid_value, -96);
    
    l_optim_features_level_old v$parameter.value %type;
    l_optim_features_level_new v$parameter.value %type := '&&def_new_optim_features_lvl';
begin
    select
        par.value into l_optim_features_level_old
    from
        v$parameter par
    where
        par.name = 'optimizer_features_enable';
    
    execute immediate 'alter session set optimizer_features_enable = '
            || dbms_assert.enquote_name(l_optim_features_level_new, false);
    
    :DEMO_OPTIM_FEATURES_LVL_OLD := l_optim_features_level_old;
    :DEMO_OPTIM_FEATURES_LVL_TXT := 'Note: optimizer_features_enable set to '
            || dbms_assert.enquote_name(l_optim_features_level_new, false)
            || ' (was '
            || dbms_assert.enquote_name(l_optim_features_level_old, false) 
            || ')';
exception
    when e_invalid_value then
        /* 
           This is expected, e.g., if attempting to set optimizer_features_enable 
           to "21.1.0" on a 19c DB; we'll just ignore it.
         */
        null;
end;
/

define def_demo_remark_ind = ""  -- Reminder: "" is on, "--" is off 
define def_demo_remark = ""

column remark_ind noprint new_value def_demo_remark_ind
column remark_msg noprint new_value def_demo_remark
select
    case
        when :DEMO_OPTIM_FEATURES_LVL_TXT is null then
            '--'
    end as remark_ind,
    :DEMO_OPTIM_FEATURES_LVL_TXT as remark_msg
from
    dual;
column remark_ind clear
column remark_msg clear

set verify on
set termout on

undefine def_new_optim_features_lvl