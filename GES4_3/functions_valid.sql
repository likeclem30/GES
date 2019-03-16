--------------------------------------------------------
--  File created - Saturday-March-26-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function AGD_STOCK_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."AGD_STOCK_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number)
return number
is
    l_count number;
begin
-- First, check to see if the user is in the user table
begin
select s.stock_bal into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
where s.agrodealerid = f.dealerid
and   s.inputid = f.inputid
and f.msisdn = p_sourceaddress 
and f.keyword =p_input_keyword;
exception 
when others then
l_count :=0;
end;
     if l_count > 1 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function CUSTOM_AUTH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."CUSTOM_AUTH" (p_username in VARCHAR2, p_password in VARCHAR2)
return BOOLEAN
is
  l_password varchar2(4000);
  l_stored_password varchar2(4000);
  l_expires_on date;
  l_count number;
begin
-- First, check to see if the user is in the user table
select count(*) into l_count from g3_users where u_email = p_username;
if l_count > 0 then
  -- First, we fetch the stored hashed password & expire date
  select password, expires_on into l_stored_password, l_expires_on
   from g3_users where u_email = p_username;
 
  -- Next, we check to see if the user's account is expired
  -- If it is, return FALSE
  if l_expires_on > sysdate or l_expires_on is null then
 
    -- If the account is not expired, we have to apply the custom hash
    -- function to the password
    l_password := custom_hash(p_username, p_password);
 
    -- Finally, we compare them to see if they are the same and return
    -- either TRUE or FALSE
    if l_password = l_stored_password then
      return true;
    else
      return false;
    end if;
  else
    return false;
  end if;
else
  -- The username provided is not in the g3_users table
  return false;
end if;
end;

/
--------------------------------------------------------
--  DDL for Function G3_THIRD_P_REG_CHECK_3_1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."G3_THIRD_P_REG_CHECK_3_1" (p_sourceaddress in NUMBER)
return number
is
    l_dealerid number;
    l_dealerid_v number;
begin
    begin
-- First, check to see if the user is in the user table
    
select a.dealerid into l_dealerid from g3_agrodealers a,g3_fieldstaff f 
where a.dealerid = f.agrodealerid 
and (f.phonenumber = p_sourceaddress or a.phonenumber = p_sourceaddress);
     
if l_dealerid is not null then
     
     l_dealerid_v := l_dealerid ;
     
     
     else
         --if l_dealerid is null then
         
    ---select a.dealerid into l_dealerid from g3_agrodealers a,g3_fieldstaff f where a.dealerid = f.agrodealerid and f.phonenumber = p_sourceaddress;
   
    l_dealerid_v := 0 ;
    end if;
EXCEPTION
   WHEN others THEN
    l_dealerid_v := 0;
end;
return l_dealerid_v;
end;

/
--------------------------------------------------------
--  DDL for Function EX_FORAGD_BUNDLE_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."EX_FORAGD_BUNDLE_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number,p_serial_number in NUMBER)
return number
is
    l_count number;
    
    s_dealerid number;
    s_stateid number;
    s_lgaid number;
    s_fieldstaffid number;
    s_farmerid number;
--    fmers_farmerid number;
    s_input_sub number;
    
    
begin


begin
select s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid into s_input_sub,s_dealerid,s_stateid,s_lgaid,s_fieldstaffid 
from g3_subsidy_input_alloc s,g3_agrodealers f,g3_inputs i,g3_fieldstaff fs
where s.escrow_acct_id = f.stateid
and  s.inputid = i.inputid
and  f.dealerid = fs.agrodealerid
and  (f.phonenumber =p_sourceaddress or fs.phonenumber =p_sourceaddress)
and s.inputid in (select inputid from g3_inputs where upper(keyword) = upper(p_input_keyword))
and rownum = 1;


EXCEPTION

WHEN others THEN
--    s_input_sub := 0;
    s_dealerid := 0;
    s_stateid := 0;
--    s_fieldstaffid := 0;
END;

begin
select fr.farmerid into s_farmerid 
from g3_farmers_rollout fr,g3_rollout r,g3_farmers f,g3_agrodealers a,g3_fieldstaff fs
where fr.rolloutid = r.rolloutid
and fr.farmerid = f.farmerid
and  a.dealerid = r.dealerid
and  fs.fieldstaffid = r.fieldstaffid
and a.lgaid = s_lgaid
and a.dealerid = s_dealerid
--and (concat(s_state_lgaid,f.serial_number) =  p_serial_number or f.serial_number = p_serial_number);
and ((f.stateid = s_stateid AND f.serial_number = p_serial_number )
  or f.serial_number = p_serial_number);

EXCEPTION
WHEN others THEN
    s_farmerid := 0;
END;



select count(*) into l_count
from g3_bundlecontents b,g3_bundles d,g3_farmers_rollout r,g3_inputs i
where b.bundleid = d.bundleid
and  b.bundleid = r.bundleid
and  i.inputid = b.inputid
and upper(i.keyword) = upper(p_input_keyword)
and r.farmerid = s_farmerid;

/*
-- First, check to see if the user is in the user table
--begin
select count(*) into l_count from FMERS_MAP_BUNDLE_INPUT_AGD_2
where (SERIAL_NUMBER_full = p_serial_number
or SERIAL_NUMBER = p_serial_number)
and (dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
and upper(keyword) = upper(p_input_keyword);
--exception 
--when others then
--l_count :=0;
--end;    


*/

---select count(*) into l_count from fmers_map_bundle_input_agd where msisdn = p_sourceaddress and keyword =p_input_keyword;
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function CUSTOM_HASH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."CUSTOM_HASH" (p_username in varchar2, p_password in varchar2)
return varchar2
is
  l_password varchar2(4000);
  l_salt varchar2(4000) := '6VZ24OLYP3QEVFU0LI67JGROEDQM66';
begin
 
-- This function should be wrapped, as the hash algorhythm is exposed here.
-- You can change the value of l_salt or the method of which to call the
-- DBMS_OBFUSCATOIN toolkit, but you much reset all of your passwords
-- if you choose to do this.
 
l_password := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5
  (input_string => p_password || substr(l_salt,10,13) || p_username ||
    substr(l_salt, 4,10)));
return l_password;
end;

/
--------------------------------------------------------
--  DDL for Function FORAGDREGISTN_CENTER_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."FORAGDREGISTN_CENTER_CHECK" (p_sourceaddress in NUMBER,p_serial_number in NUMBER)
return number
is
    l_count number;
begin
-- 
begin
select count(*) into l_count from FMERS_MAP_BUNDLE_INPUT_AGD_2
where (SERIAL_NUMBER_full = p_serial_number
or SERIAL_NUMBER = p_serial_number)
and (dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) );
exception 
when others then
l_count :=0;
end;    
    
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function FORAGD_STOCK_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."FORAGD_STOCK_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number,p_serial_number in NUMBER)
return number
is
    l_count number;
begin
-- First, check to see if the user is in the user table
begin
select s.stock_bal into l_count from agd_stock_bal s,fmers_map_bundle_input_agd_2 f
where s.agrodealerid = f.dealerid
and   s.inputid = f.inputid
and (SERIAL_NUMBER_full = p_serial_number or SERIAL_NUMBER = p_serial_number)
and (dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
and upper(keyword) = upper(p_input_keyword);
exception 
when others then
l_count :=0;
end;
     if l_count > 1 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function EX_FORAGDFARMERS_CREDIT_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."EX_FORAGDFARMERS_CREDIT_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number,p_serial_number in NUMBER)
return number
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    
    s_dealerid number;
    s_stateid number;
    s_lgaid number;
    s_fieldstaffid number;
    s_farmerid number;
    fmers_farmerid number;
    
--    l_count number;
    
begin

begin
select s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid into s_input_sub,s_dealerid,s_stateid,s_lgaid,s_fieldstaffid 
from g3_subsidy_input_alloc s,g3_agrodealers f,g3_inputs i,g3_fieldstaff fs
where s.escrow_acct_id = f.stateid
and  s.inputid = i.inputid
and  f.dealerid = fs.agrodealerid
and  (f.phonenumber =p_sourceaddress or fs.phonenumber =p_sourceaddress)
and s.inputid in (select inputid from g3_inputs where upper(keyword) = upper(p_input_keyword));

/*
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and  upper(f.keyword) = upper(p_input_keyword)
and (f.SERIAL_NUMBER_full = p_serial_number or f.SERIAL_NUMBER = p_serial_number)
and (f.dealerid in (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid in (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) );
*/
EXCEPTION

WHEN others THEN
    s_input_sub := 0;
    s_dealerid := 0;
    s_stateid := 0;
--    s_fieldstaffid := 0;
END;


begin
select fr.farmerid into s_farmerid 
from g3_farmers_rollout fr,g3_rollout r,g3_farmers f,g3_agrodealers a,g3_fieldstaff fs
where fr.rolloutid = r.rolloutid
and fr.farmerid = f.farmerid
and  a.dealerid = r.dealerid
and  fs.fieldstaffid = r.fieldstaffid
and a.lgaid = s_lgaid
and a.dealerid = s_dealerid
and ((f.stateid = s_stateid AND f.serial_number = p_serial_number )
  or f.serial_number = p_serial_number);

EXCEPTION
WHEN others THEN
    s_farmerid := 0;
END;








begin
select s.amount into f_input_sub
from g3_subsidy_input_alloc s,g3_inputs i
where s.inputid = i.inputid
and s.escrow_acct_id =38
    and upper(i.keyword) = upper(p_input_keyword);

EXCEPTION
WHEN others THEN
    f_input_sub := 0;
END;

s_f_total_sub := f_input_sub + s_input_sub;
begin
select s_f_total_sub into f_s_input_sub from dual;
EXCEPTION
WHEN others THEN
    f_s_input_sub := 0;
END;


begin
select farmerid,sum(nvl(credit,0) - nvl(debit,0)) bal into fmers_farmerid,fmers_bal
from g3_account 
where farmerid = s_farmerid
group by farmerid;

EXCEPTION
WHEN others THEN
    fmers_bal := 0;
--    fmers_farmerid := 0;
END;



/*
begin
select bal into fmers_bal from farmers_account_bal_2 b,fmers_map_bundle_input_agd_2 f
where b.farmerid = f.farmerid
and (f.SERIAL_NUMBER_full = p_serial_number or f.SERIAL_NUMBER = p_serial_number)
and (f.dealerid in (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid in (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmers_bal := 0;
END;
*/
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
     if f_s_input_sub <= fmers_bal   then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
    
  end;

/
--------------------------------------------------------
--  DDL for Function BUNDLE_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."BUNDLE_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number)
return number
is
    l_count number;
begin
-- First, check to see if the user is in the user table
select count(*) into l_count from fmers_map_bundle_input_agd where msisdn = p_sourceaddress and keyword =p_input_keyword;
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function EX_FORAGDREGISTN_CENTER_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."EX_FORAGDREGISTN_CENTER_CHECK" (p_sourceaddress in NUMBER,p_serial_number in NUMBER)
return number
is
    l_count number;
    
    s_dealerid number;
    s_stateid number;
    s_lgaid number;
    s_fieldstaffid number;
--    s_farmerid number;
--    fmers_farmerid number;
    s_input_sub number;
    
begin

begin
select s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid into s_input_sub,s_dealerid,s_stateid,s_lgaid,s_fieldstaffid 
from g3_subsidy_input_alloc s,g3_agrodealers f,g3_inputs i,g3_fieldstaff fs
where s.escrow_acct_id = f.stateid
and  s.inputid = i.inputid
and  f.dealerid = fs.agrodealerid
and  (f.phonenumber =p_sourceaddress or fs.phonenumber =p_sourceaddress)
--and s.inputid in (select inputid from g3_inputs where upper(keyword) = upper(p_input_keyword))
and rownum = 1;


EXCEPTION

WHEN others THEN
--    s_input_sub := 0;
    s_dealerid := 0;
    s_stateid := 0;
--    s_fieldstaffid := 0;
END;

begin
select count(*) into l_count 
from g3_farmers_rollout fr,g3_rollout r,g3_farmers f,g3_agrodealers a,g3_fieldstaff fs
where fr.rolloutid = r.rolloutid
and fr.farmerid = f.farmerid
and  a.dealerid = r.dealerid
and  fs.fieldstaffid = r.fieldstaffid
and a.lgaid = s_lgaid
and a.dealerid = s_dealerid
and ((f.stateid = s_stateid AND f.serial_number = p_serial_number )
  or f.serial_number = p_serial_number);

EXCEPTION
WHEN others THEN
    l_count := 0;
END;

/*
-- 
begin
select count(*) into l_count from FMERS_MAP_BUNDLE_INPUT_AGD_2
where (SERIAL_NUMBER_full = p_serial_number
or SERIAL_NUMBER = p_serial_number)
and (dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) );
exception 
when others then
l_count :=0;
end;    
  */  
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function EX_FORAGD_STOCK_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."EX_FORAGD_STOCK_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number,p_serial_number in NUMBER)
return number
is
    l_count number;
    
    s_dealerid number;
    s_state_lgaid number;
    s_lgaid number;
    s_fieldstaffid number;
    s_farmerid number;
    fmers_farmerid number;
    s_input_sub number;
    
    
begin


begin
select s.amount,f.dealerid,concat(f.stateid,f.lgaid),f.lgaid,fs.fieldstaffid into s_input_sub,s_dealerid,s_state_lgaid,s_lgaid,s_fieldstaffid 
from g3_subsidy_input_alloc s,g3_agrodealers f,g3_inputs i,g3_fieldstaff fs
where s.escrow_acct_id = f.stateid
and  s.inputid = i.inputid
and  f.dealerid = fs.agrodealerid
and  (f.phonenumber =p_sourceaddress or fs.phonenumber =p_sourceaddress)
and s.inputid in (select inputid from g3_inputs where upper(keyword) = upper(p_input_keyword))
and rownum = 1;


EXCEPTION

WHEN others THEN
    s_lgaid := 0; 
    s_input_sub := 0;
    s_dealerid := 0;
    s_state_lgaid := 0;
    s_fieldstaffid := 0;
END;

begin
select stock_bal into l_count from agd_stock_bal
where agrodealerid = s_dealerid
and inputid in (select inputid from g3_inputs where upper(keyword) = upper(p_input_keyword));
EXCEPTION

WHEN others THEN
    l_count := 0; 
    
END;

/*

begin
select s.stock_bal into l_count from agd_stock_bal s,fmers_map_bundle_input_agd_2 f
where s.agrodealerid = f.dealerid
and   s.inputid = f.inputid
and (SERIAL_NUMBER_full = p_serial_number or SERIAL_NUMBER = p_serial_number)
and (dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
and upper(keyword) = upper(p_input_keyword);
exception 
when others then
l_count :=0;
end;
*/
     if l_count >= 1 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function FORAGDFARMERS_CREDIT_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."FORAGDFARMERS_CREDIT_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number,p_serial_number in NUMBER)
return number
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    
    l_count number;
    
begin

begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and  upper(f.keyword) = upper(p_input_keyword)
and (f.SERIAL_NUMBER_full = p_serial_number or f.SERIAL_NUMBER = p_serial_number)
and (f.dealerid in (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid in (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) );
EXCEPTION

WHEN others THEN
    s_input_sub := 0;
END;


begin
select s.amount into f_input_sub
from g3_subsidy_input_alloc s,g3_inputs i
where s.inputid = i.inputid
and s.escrow_acct_id =38
    and upper(i.keyword) = upper(p_input_keyword);

EXCEPTION
WHEN others THEN
    f_input_sub := 0;
END;

s_f_total_sub := f_input_sub + s_input_sub;
begin
select s_f_total_sub into f_s_input_sub from dual;
EXCEPTION
WHEN others THEN
    f_s_input_sub := 0;
END;


begin
select bal into fmers_bal from farmers_account_bal_2 b,fmers_map_bundle_input_agd_2 f
where b.farmerid = f.farmerid
and (f.SERIAL_NUMBER_full = p_serial_number or f.SERIAL_NUMBER = p_serial_number)
and (f.dealerid in (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid in (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmers_bal := 0;
END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
    
  end;

/
--------------------------------------------------------
--  DDL for Function G3_THIRD_P_ACT_CHECK_3_1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."G3_THIRD_P_ACT_CHECK_3_1" (p_dealerid in NUMBER, p_vcid in NUMBER)
return number
is
    l_bundleid number;
    l_bundleid_v number;
    
BEGIN
     BEGIN
--First, check to see if the user is in the user table
select distinct bundleid into l_bundleid from g3_rout_wards_mapping where dealerid = p_dealerid and vcid = p_vcid;
     
if l_bundleid is not null then
     
     l_bundleid_v := l_bundleid ;
     
     else
       
    l_bundleid_v := 0 ;
end if;
EXCEPTION
   WHEN others THEN
    l_bundleid_v := 0;
END;
RETURN l_bundleid_v;
END g3_third_p_act_check_3_1;   
    

/
--------------------------------------------------------
--  DDL for Function FORAGD_BUNDLE_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."FORAGD_BUNDLE_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number,p_serial_number in NUMBER)
return number
is
    l_count number;
begin
-- First, check to see if the user is in the user table
--begin
select count(*) into l_count from FMERS_MAP_BUNDLE_INPUT_AGD_2
where (SERIAL_NUMBER_full = p_serial_number
or SERIAL_NUMBER = p_serial_number)
and (dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
and upper(keyword) = upper(p_input_keyword);
--exception 
--when others then
--l_count :=0;
--end;    




---select count(*) into l_count from fmers_map_bundle_input_agd where msisdn = p_sourceaddress and keyword =p_input_keyword;
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function G3_FMER_ACCT_BAL_3_1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."G3_FMER_ACCT_BAL_3_1" (p_farmerid in number)
return number
is
    l_credit_bal number;
    l_credit_bal_v number;

BEGIN
     BEGIN





select sum(nvl(credit,0) - nvl(debit,0)) into l_credit_bal
from g3_account
where farmerid = p_farmerid;

     
if l_credit_bal > 0 then
     
     l_credit_bal_v := l_credit_bal ;
     
     else
       
    l_credit_bal_v := 0 ;

end if;


EXCEPTION
   WHEN others THEN
    l_credit_bal_v := 0;
END;
RETURN l_credit_bal_v;
END g3_fmer_acct_bal_3_1;

/
--------------------------------------------------------
--  DDL for Function ACTIVATION_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."ACTIVATION_CHECK" (p_sourceaddress in NUMBER)
return number
is
    l_count number;
begin
-- First, check to see if the user is in the user table
select count(*) into l_count from FARMERS_REDEMP where msisdn = p_sourceaddress;
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function FARMERS_CREDIT_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."FARMERS_CREDIT_CHECK" (p_input_keyword in varchar2,p_sourceaddress in Number)
return number
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    
    l_count number;
    
begin

begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and  upper(f.keyword) = upper(p_input_keyword)
and  f.msisdn = p_sourceaddress;
EXCEPTION

WHEN others THEN
    s_input_sub := 0;
END;


begin
select s.amount into f_input_sub
from g3_subsidy_input_alloc s,g3_inputs i
where s.inputid = i.inputid
and s.escrow_acct_id =38
    and upper(i.keyword) = upper(p_input_keyword);

EXCEPTION
WHEN others THEN
    f_input_sub := 0;
END;

s_f_total_sub := f_input_sub + s_input_sub;
begin
select s_f_total_sub into f_s_input_sub from dual;
EXCEPTION
WHEN others THEN
    f_s_input_sub := 0;
END;


begin
select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    fmers_bal := 0;
END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
    
  end;

/
--------------------------------------------------------
--  DDL for Function FUNCION_PRUEBA
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."FUNCION_PRUEBA" (OBJETO_ENTRADA VARCHAR2)
 RETURN JSON
	IS
	 
	mi_objeto_json json;
	 
	cadena varchar2(200);
	 
	BEGIN
	 
	mi_objeto_json :=json(OBJETO_ENTRADA);
	 
	cadena:=mi_objeto_json.get ('nombre_clave').get_string;
	 
	--Hacemos algo con el objeto json o sus datos.
	 
	RETURN mi_objeto_json;
	 
	EXCEPTION
	 WHEN NO_DATA_FOUND
	 THEN
	 NULL;
	 WHEN OTHERS
	 THEN
	 -- Consider logging the error and then re-raise
	 RAISE;
	END FUNCION_PRUEBA;

/
--------------------------------------------------------
--  DDL for Function G4_FARMER_BUNDLE_SUB
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."G4_FARMER_BUNDLE_SUB" (p_STATEID PLS_INTEGER,p_BUNDLEID in PLS_INTEGER,p_GES_YEAR PLS_INTEGER,p_vcid PLS_INTEGER)
return PLS_INTEGER
is
---PRAGMA AUTONOMOUS_TRANSACTION;
   x_inputid   PLS_INTEGER;
   x_amount  PLS_INTEGER;
   x_qty  PLS_INTEGER;
   x_esc  PLS_INTEGER;
   x_bundle_sub PLS_INTEGER := 0; 
   stmt_name varchar2(3000) ;
BEGIN
    
  stmt_name := '1.begin for i in select inputid,quantity from g4_bundlecontents'; 
    
  for i in (select inputid,quantity from g4_bundlecontents where bundleid = p_BUNDLEID)
  loop
    select inputid,sum(nvl(amount,0)* nvl(i.quantity,1)) into x_inputid,x_amount
  from g4_subsidy_input_alloc 
  where inputid is not null 
  and ges_year = p_ges_year
  and vcid     = p_vcid
  
  and inputid = i.inputid 
  and escrow_acct_id in (p_STATEID,38)
  group by inputid;
  
  ---dbms_output.put_line('inputid :'||i.inputid||'  Quantity '||i.quantity||'  Amount '||x_amount);
   
   x_bundle_sub := x_bundle_sub + x_amount;
  end loop;
  ---dbms_output.put_line('Total :'||x_bundle_sub);
  --- exception
   ---when others then
   ---x_bundle_sub := p_FARMERS_CON;
  ----end;
  return x_bundle_sub;
   exception
    when others then
    return 0;
    g4_write_log( SQLCODE,SQLERRM,stmt_name);
    ROLLBACK;
    RAISE;   
  end;

/
--------------------------------------------------------
--  DDL for Function GET_NUM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."GET_NUM" (
       p_highval   NUMBER,
       p_lowval    NUMBER := 0,
       p_scale     PLS_INTEGER := 0
    )
       RETURN NUMBER
    IS
       l_ret   NUMBER;
       PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
       l_ret := ROUND (DBMS_RANDOM.VALUE (p_lowval, p_highval), p_scale);
       RETURN l_ret;
    END;

/
--------------------------------------------------------
--  DDL for Function GET_XML_TO_JSON_STYLESHEET
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."GET_XML_TO_JSON_STYLESHEET" return varchar2 is
    l_xslt_string varchar2(32000);
  begin
    l_xslt_string := '
...
';
    return(l_xslt_string);
end;

/
--------------------------------------------------------
--  DDL for Function IS_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."IS_NUMBER" ( p_str IN VARCHAR2 )
  RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE
IS
  l_num NUMBER;
BEGIN
  l_num := to_number( p_str );
  RETURN 'Y';
EXCEPTION
  WHEN value_error THEN
    RETURN 'N';
END is_number;

/
--------------------------------------------------------
--  DDL for Function NEW_SEND_MAIL_FUN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."NEW_SEND_MAIL_FUN" (p_EMAIL_ADDRESS varchar2,p_password varchar2)
return varchar2
is
p_mail_body varchar2(150) := ' Please Click on : http://atms3.cellulant.com.ng/pls/apex/f?p=110:89:25745763095939::::: to set your password.Your password reset Token is :';
p_mail_body2 varchar2(250);
p_mail_body3 varchar2(250) := ' After Successful Password Reset Click http://atms3.cellulant.com.ng to login ';
v_message VARCHAR2(32000);
conn UTL_SMTP.CONNECTION;
v_sender_acct varchar2(100):='atms@cellulant.com.ng';
v_count number;
v_hostname varchar2(100):=' ';
v_displayhost varchar2(100);
BEGIN
v_message:='<center><h3><i><font color=#000099>Your Login Details </font></i></h3></center><br>'||utl_tcp.CRLF;
v_message:=v_message||'<table style="border: solid 0px #cccccc" cellspacing="0" cellpadding="0"><tr BGCOLOR=#000099>';
--v_message:=v_message||'<td><b><font color=white>Stateid</font></td>';
--v_message:=v_message||'<td><b><font color=white>Statename</font></td></tr>'||utl_tcp.CRLF;
--FOR i IN (select stateid, statename from g3_states)
--LOOP

v_message:=v_message||'<tr><td>'||'Dear..'||'</td><td>'||lower(p_EMAIL_ADDRESS)||'</td></tr>'||utl_tcp.CRLF;
v_message:=v_message||'<tr><br/><td>'||p_mail_body||'</td></tr>'||utl_tcp.CRLF;
v_message:=v_message||'<tr><br/><td><font color=red size=5>'||p_password||'</font></td><br/></tr>'||utl_tcp.CRLF;
v_message:=v_message||'<tr><br><br><br><td>'||p_mail_body3||'</td></tr>'||utl_tcp.CRLF;


--END LOOP;
v_message:=v_message||'</table><br><br><center><h2><i><font color=red>CELLULANT .......Life is Mobile </font></i></h2></center><br></body></html>'||utl_tcp.CRLF;
conn:= utl_smtp.open_connection('127.0.0.1');
utl_smtp.helo(conn,'127.0.0.1');
utl_smtp.mail(conn,v_sender_acct);
utl_smtp.rcpt(conn,lower(p_EMAIL_ADDRESS));
utl_smtp.rcpt(conn,'aaron@cellulant.com.ng');
utl_smtp.rcpt(conn,'bolaji@cellulant.com');
--utl_smtp.rcpt(conn,'patrick.gbenga@cellulant.com');
utl_smtp.open_data(conn);
utl_smtp.write_data(conn,'content-type: text/html;');
utl_smtp.write_data(conn,'MIME-Version: 1.0'||utl_tcp.CRLF);
utl_smtp.write_data(conn,'To: '||lower(p_EMAIL_ADDRESS)||utl_tcp.CRLF);
utl_smtp.write_data(conn,'Cc:'||'aaron@cellulant.com.ng,bolaji@cellulant.com,patrick.gbenga@cellulant.com'||utl_tcp.CRLF);
--utl_smtp.write_data(conn,'Cc:'||'bolaji@cellulant.com'||utl_tcp.CRLF);
utl_smtp.write_data(conn,'From: '||v_sender_acct||utl_tcp.CRLF);
utl_smtp.write_data(conn,'Subject: G.E.S AGRO DEALERS TRANSACTION SYSTEM'||utl_tcp.CRLF);
utl_smtp.write_data(conn,'<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="TEXT/HTML; ">'||
utl_tcp.CRLF||'<content="MSHTML 6.00.2800.1276" name=GENERATOR>'||utl_tcp.CRLF||'<HTML><BODY>');
utl_smtp.write_data(conn,v_message);
utl_smtp.close_data(conn);
utl_smtp.quit(conn);
END;

/
--------------------------------------------------------
--  DDL for Function PHPTEST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."PHPTEST" (  fNAME IN VARCHAR2 ) RETURN VARCHAR2 AS 
greeting VARCHAR2(100);
BEGIN
 greeting := 'Hello ' || fname;
return  greeting;
END ;

/
--------------------------------------------------------
--  DDL for Function REGISTER_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."REGISTER_CHECK" (p_sourceaddress in NUMBER)
return number
is
    l_count number;
begin
-- First, check to see if the user is in the user table
select count(*) into l_count from g3_farmers where msisdn = p_sourceaddress;
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
   
   EXCEPTION
WHEN NO_DATA_FOUND THEN
    l_count := 0;
    return 0;
--END; 
    
  end;

/
--------------------------------------------------------
--  DDL for Function REGISTRATION_CENTER_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."REGISTRATION_CENTER_CHECK" (p_sourceaddress in NUMBER,p_serial_number in NUMBER)
return number
is
    l_count number;
begin
-- 
begin
select count(*) into l_count from FMERS_MAP_BUNDLE_INPUT_AGD_2
where (SERIAL_NUMBER_full = p_serial_number
or SERIAL_NUMBER = p_serial_number)
and (dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) );
exception 
when others then
l_count :=0;
end;    
    
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function REGISTRATION_CHECK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."REGISTRATION_CHECK" (p_sourceaddress in NUMBER)
return number
is
    l_count number;
begin
-- First, check to see if the user is in the user table
select count(*) into l_count from g3_farmers where msisdn = p_sourceaddress;
     if l_count > 0 then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Function SPELL_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."SPELL_NUMBER" (p_number IN NUMBER)
   RETURN VARCHAR2
AS
   TYPE myArray IS TABLE OF VARCHAR2 (255);

   l_str myArray
         := myArray ('',
                     ' thousand ',
                     ' million ',
                     ' billion ',
                     ' trillion ',
                     ' quadrillion ',
                     ' quintillion ',
                     ' sextillion ',
                     ' septillion ',
                     ' octillion ',
                     ' nonillion ',
                     ' decillion ',
                     ' undecillion ',
                     ' duodecillion ');

   l_num      VARCHAR2 (50) DEFAULT TRUNC (p_number);
   l_return   VARCHAR2 (4000);
BEGIN
   FOR i IN 1 .. l_str.COUNT
   LOOP
      EXIT WHEN l_num IS NULL;

      IF (SUBSTR (l_num, LENGTH (l_num) - 2, 3) <> 0)
      THEN
         l_return :=
            TO_CHAR (TO_DATE (SUBSTR (l_num, LENGTH (l_num) - 2, 3), 'J'),
                     'Jsp')
            || l_str (i)
            || l_return;
      END IF;

      l_num := SUBSTR (l_num, 1, LENGTH (l_num) - 3);
   END LOOP;

   RETURN l_return;
END;

/
--------------------------------------------------------
--  DDL for Function SQL2XML
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."SQL2XML" (i_sql_string in varchar2) return xmltype is

    l_context_handle dbms_xmlgen.ctxhandle;

    l_xml            xmltype;

    l_rows           number;

begin

    -- returns a new context handle to be used in the following functions

    l_context_handle := dbms_xmlgen.newcontext(i_sql_string);

     

    -- if null, give a empty tag (e.g. )

    dbms_xmlgen.setnullhandling(l_context_handle, dbms_xmlgen.empty_tag);

     

    -- get the XML

    l_xml  := dbms_xmlgen.getxmltype(l_context_handle, dbms_xmlgen.none);

     

    -- get back the number of rows

    l_rows := dbms_xmlgen.getnumrowsprocessed(l_context_handle);

     

    -- close the handle

    dbms_xmlgen.closecontext(l_context_handle);

     

    if l_rows > 0 then

      return(l_xml);

    else

      return(null);

    end if;

end;

/
--------------------------------------------------------
--  DDL for Function STR2NUM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."STR2NUM" (p_string varchar2) RETURN NUMBER
IS
  v_decimal char;
BEGIN
  SELECT substr(VALUE, 1, 1)
  INTO v_decimal
  FROM NLS_SESSION_PARAMETERS
  WHERE PARAMETER = 'NLS_NUMERIC_CHARACTERS';
  return to_number(replace(p_string, '.', v_decimal));
END;

/
--------------------------------------------------------
--  DDL for Function TESTJAVECONN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."TESTJAVECONN" (param1 number, param2 number)
return number is 
param3 number;
begin
param3:=param1 + param2;
return param3;
end ;

/
--------------------------------------------------------
--  DDL for Function VERIFY_GENDER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."VERIFY_GENDER" (gender varchar2)
return varchar2
is

c_gender varchar2(11);

begin
     
     IF UPPER(gender) = 'F' THEN
        c_gender := 'FEMALE';
        return c_gender;
     ELSIF UPPER(gender) = 'M' THEN
         c_gender := 'MALE';
         return c_gender;
     ELSIF UPPER(gender) = 'MALE' THEN
         c_gender := 'MALE';
         return c_gender;
      ELSIF UPPER(gender) = 'FEMALE' THEN
        c_gender := 'FEMALE';
        return c_gender;
      ELSE
      c_gender := 'UNSPECIFIED';
      return c_gender;
      END IF;
   
     
END ;

/
--------------------------------------------------------
--  DDL for Function VERIFY_LGA
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."VERIFY_LGA" (l_stateID in NUMBER,l_lgaid in number)
return number
is

c_lgaID number;
f_stateID number;

begin
    select stateID into f_stateID  from g3_lga  where lgaID=l_lgaid;

   if l_stateID != f_stateID then
   select lgaID into c_lgaID  from g3_lga  where STATEID=l_stateID and rownum <2;
  
   return c_lgaID;
   else
   c_lgaID:=l_lgaid;
   return c_lgaID;
   
   end if;
     
 

     
  
     

   
  -- dbms_output.put_line( 'FARMERID : ' || f.FARMERID || 'MSISDN : ' || f.MSISDN || 'f_token : ' || f_token || ' f_NewfarmerID: ' || f_NewfarmerID );

END ;

/
--------------------------------------------------------
--  DDL for Function VERIFY_MSISDN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."VERIFY_MSISDN" (MSISDN in NUMBER)
return number
is

MSISDN_len number;
c_MSISDN number;

begin


    MSISDN_len :=length(MSISDN);

    IF MSISDN_len=10 then
    select concat('234',MSISDN) into  c_MSISDN  from dual;
    return c_MSISDN;
     
    ELSIF MSISDN_len=13 then
     c_MSISDN := MSISDN;
     return c_MSISDN;
     
     ELSIF MSISDN_len is null  then
     c_MSISDN := null;
     return c_MSISDN;
     else
     c_MSISDN := null;
     return c_MSISDN;
    end if;

END ;

/
--------------------------------------------------------
--  DDL for Function VERIFY_WARD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."VERIFY_WARD" (l_lgaID in NUMBER,l_wardID in number)
return number
is

c_wardID number;
f_lgaID number;

begin
    select lgaID into f_lgaID  from g3_wards  where wardID=l_wardID;

   if f_lgaID != l_lgaID then
   select wardid into c_wardID  from g3_wards  where lgaID= l_lgaID and rownum <2;
   return c_wardID;
   else
   c_wardID:=l_wardID;
   return c_wardID;
   
   end if;
     
END ;

/
--------------------------------------------------------
--  DDL for Function XML2JSON
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "UCELLULANT1"."XML2JSON" (i_xml in xmltype) return xmltype is
    l_json xmltype;
begin
    l_json := i_xml.transform(xmltype(get_xml_to_json_stylesheet));
    return(l_json);
end;

/
