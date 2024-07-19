set termout off

declare
    l_optim_features_level_old v$parameter.value %type := :DEMO_OPTIM_FEATURES_LVL_OLD;
    l_optim_features_level_msg varchar2(100);
begin
    if l_optim_features_level_old is not null then
        execute immediate 'alter session set optimizer_features_enable = '
                || dbms_assert.enquote_name(l_optim_features_level_old, false);

        l_optim_features_level_msg := 'Note: optimizer_features_enable reset to '
            || dbms_assert.enquote_name(l_optim_features_level_old, false);
    end if;

    :DEMO_OPTIM_FEATURES_LVL_OLD := null;
    :DEMO_OPTIM_FEATURES_LVL_TXT := l_optim_features_level_msg;
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

set termout on