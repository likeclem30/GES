--------------------------------------------------------
--  File created - Saturday-March-26-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_MORE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."ADD_MORE" ( p_text in varchar2 )
as
g_clob clob;
begin
    dbms_lob.writeappend( g_clob, length(p_text), p_text );
end;

/
--------------------------------------------------------
--  DDL for Procedure AGD_ACT_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_ACT_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 /*
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 
*/
 ----------------------------------------------------------------------------------------
 /*
    select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
*/
----------------------------------------------------------------------------------------
---- select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 ---dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 ---select inputname into f_inputname from g3_inputs where inputid = p_inputid;
select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 
 select 'Dear '||dealer_name||' you have not been activated for this value chain : '||f_vcname||' Request is: '||p_payload||'. Fmer id :'||p_f_serial_no into agd_msgcont from dual;
 
 
----------------------------------------------------------------------------------------
 /*
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,11       ,p_requestid ,0);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,11       ,0);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2     ,       11,p_farmerid  ,p_dealerid,f_msisdn   ,0          ,p_vcid,'AGD_FS_Fmers_Fail_Center'    ,p_payload ,p_sourceaddress);
   
   
            
 else
 */
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,21        ,p_requestid ,0);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
----                              values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,20        ,p_rolloutid);
  
insert into g3_transactions(REQUESTID  ,STATUSID,SERVICEID   ,DEALERID  ,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                    values(p_requestid ,2       ,        21  ,p_dealerid,0          ,p_vcid,'AGD_FS_Fail_Activation_vc'   ,p_payload,p_sourceaddress);
   
   
         
 ---end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := NULL;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END agd_act_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure AGD_FMER_ACT_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_FMER_ACT_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 /*
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 
 ----------------------------------------------------------------------------------------
 select f_f_sub + f_s_sub into f_f_s_sub from dual;
 */
 ----------------------------------------------------------------------------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
-- select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 select 'Dear '||dealer_name||' The farmer : '||farmer_name||' is not activated for this value chain :'||f_vcname||' Request :'||p_payload||'. Fmer id :'||f_serial_no into agd_msgcont from dual;
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
select 'Dear '||farmer_name||' You are not activated for this value chain :'||f_vcname||'. Request :'||p_payload||'. Fmer id :'||f_serial_no into f_msgcont from dual;
 ----------------------------------------------------------------------------------------
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
--insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
--                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,20        ,p_requestid ,p_rolloutid);
                          
 
--insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
--                                values(f_msgcont  ,f_msisdn        ,'GES'      ,p_request_total,p_requestid,dealer_name,7      ,20        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID    ,REQUESTID  ,STATUSID,SERVICEID   ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,        20  ,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Fail_Activation',p_payload,p_sourceaddress);
            
 else
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,20        ,p_requestid ,p_rolloutid);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
---                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,20        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID   ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,        20,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Fail_Activation',p_payload,p_sourceaddress);
   
   
         
 end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END agd_fmer_act_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure AGD_FMER_ACTN_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_FMER_ACTN_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 /*
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 
*/
 ----------------------------------------------------------------------------------------
 /*
    select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
*/
----------------------------------------------------------------------------------------
---- select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 ---dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 ---select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 
 select 'Dear '||dealer_name||' The farmer : '||farmer_name||' is not activated for this value chain :'||f_vcname||' Request :'||p_payload||'. Fmer id :'||f_serial_no into agd_msgcont from dual;
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
--select 'Dear '||farmer_name||' You are not allow to redeem this :'||p_payload||' input.AgroDealer:'||dealer_name||'. Fmer id :'||f_serial_no into f_msgcont from dual;
select 'Dear '||farmer_name||' You are not activated for this value chain :'||f_vcname||'. Request :'||p_payload||'. Fmer id :'||f_serial_no into f_msgcont from dual;

----------------------------------------------------------------------------------------
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,20       ,p_requestid ,p_rolloutid);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,20       ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2     ,       20,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Fail_Actn',p_payload,p_sourceaddress);
   
   
            
 else
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,20        ,p_requestid ,p_rolloutid);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
----                              values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,20        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID   ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,        20,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Fail_Actn',p_payload,p_sourceaddress);
   
   
         
 end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END agd_fmer_actn_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure AGD_FMER_CEN_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_FMER_CEN_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_bundleid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 /*
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 
*/
 ----------------------------------------------------------------------------------------
 /*
    select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
*/
----------------------------------------------------------------------------------------
---- select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 ---dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 ---select inputname into f_inputname from g3_inputs where inputid = p_inputid;
---- select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 
 select 'Dear '||dealer_name||' The farmer : '||farmer_name||' is not in your redemption center. '||' Request is: '||p_payload||'. Fmer id :'||f_serial_no into agd_msgcont from dual;
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
--select 'Dear '||farmer_name||' You are not allow to redeem this :'||p_payload||' input.AgroDealer:'||dealer_name||'. Fmer id :'||f_serial_no into f_msgcont from dual;
select 'Dear farmer You are not in same redemption center with the AGD :'||dealer_name||'. Request is :'||p_payload||'. Fmer id :'||f_serial_no into f_msgcont from dual;

----------------------------------------------------------------------------------------
 /*
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,11       ,p_requestid ,0);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,11       ,0);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2     ,       11,p_farmerid  ,p_dealerid,f_msisdn   ,0          ,p_vcid,'AGD_FS_Fmers_Fail_Center'    ,p_payload ,p_sourceaddress);
   
   
            
 else
 */
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,11        ,p_requestid ,0);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
----                              values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,20        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID   ,DEALERID  ,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,        11,p_dealerid,0          ,p_vcid,'AGD_FS_Fmers_Fail_Center',p_payload,p_sourceaddress);
   
   
         
 ---end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := NULL;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END agd_fmer_cen_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure AGD_INPUT_FAIL_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_INPUT_FAIL_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_inputid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 --select 'Dear '||dealer_name||' Your stock inventory for: '||f_inputname||' is 0.Requested by:'||farmer_name||' Fmer id :'||f_serial_no into agd_msgcont from dual;
 
 select 'Dear '||dealer_name||' The farmer is not allow to redeem this : '||p_payload||' input.Requested by:'||farmer_name||'. Fmer id :'||f_serial_no into agd_msgcont from dual;
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
--select 'Dear '||farmer_name||' The agro dealer :'||dealer_name||' has no stock inventory for '||f_inputname||'. Fmer id :'||f_serial_no into f_msgcont from dual;

select 'Dear '||farmer_name||' You are not allow to redeem this :'||p_payload||' input.Requested by:'||farmer_name||'. Fmer id :'||f_serial_no into f_msgcont from dual; 

 ----------------------------------------------------------------------------------------
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,10        ,p_requestid ,p_rolloutid);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,10        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,     10,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Fail_bundle',p_payload,p_sourceaddress);
   
   
            
 else
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,10        ,p_requestid ,p_rolloutid);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
----                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,10        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                    ,payload   ,sourceaddress)
                    values(p_bundleid,p_requestid,2       ,     10   ,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Fail_bundle',p_payload,p_sourceaddress);
   
   
  commit;       
 end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
END;

/
--------------------------------------------------------
--  DDL for Procedure AGD_PAYLOAD_REQUEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_PAYLOAD_REQUEST" is 
BEGIN

 execute immediate
 '  create table AGD_payload_request as 
  select s.stateName as STATENAME, l.lgaName as LGANAME, ag.DEALERNAME as DEALERNAME,
 ag.DEALERID as DEALERID ,ag.PHONENUMBER as PHONENUMBER, r.REDEMP_CENTER as REDEMP_CENTER,
 count(distinct i.messagecontent) as tt, count(distinct i.messagecontent) * 5500 as TTV
 from g3_agroDealers ag,g3_states s,g3_lga l,g3_inboundgesmessages i,g3_rollout r
where ag.stateID=s.stateID and ag.lgaID=l.lgaID and  r.dealerID=ag.dealerID and 
ag.PHONENUMBER =i.sourceAddress   
group by  s.STATENAME, l.LGANAME,  ag.DEALERNAME, ag.DEALERID , ag.PHONENUMBER, r.REDEMP_CENTER
order by  s.STATENAME, l.LGANAME,  ag.DEALERNAME, ag.DEALERID , ag.PHONENUMBER, r.REDEMP_CENTER
';
END;

/
--------------------------------------------------------
--  DDL for Procedure AGD_REG_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_REG_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_f_serial_no in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;

f_dealerid   number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
/*
    select translate(upper(DEALERNAME),'~1234567890','~'),dealerid into dealer_name,f_dealerid
 from g3_agrodealers  
 where phonenumber = p_sourceaddress;
 -----------------------------------------------------------------------------------------
 
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 
*/
 ----------------------------------------------------------------------------------------
 /*
    select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
*/
----------------------------------------------------------------------------------------
---- select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 ---dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 ---select inputname into f_inputname from g3_inputs where inputid = p_inputid;
select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 
 select 'Dear '||p_sourceaddress||' you are not a registered Agrodealer in the GES program. value chain : '||f_vcname||'. Payload: '||p_payload||'. Fmer id :'||p_f_serial_no into agd_msgcont from dual;
 
 
----------------------------------------------------------------------------------------
 /*
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,11       ,p_requestid ,0);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,11       ,0);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2     ,       11,p_farmerid  ,p_dealerid,f_msisdn   ,0          ,p_vcid,'AGD_FS_Fmers_Fail_Center'    ,p_payload ,p_sourceaddress);
   
   
            
 else
 */
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total  ,7     ,22        ,p_requestid ,0);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
----                              values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,20        ,p_rolloutid);
  
insert into g3_transactions(REQUESTID  ,STATUSID,SERVICEID   ,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                    values(p_requestid ,2       ,        22  ,0          ,p_vcid,'AGD_FS_Fail_Registration_vc'   ,p_payload,p_sourceaddress);
   
   
         
 ---end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := NULL;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END agd_reg_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure AGD_STOCK_FAIL_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_STOCK_FAIL_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_inputid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 select 'Dear '||dealer_name||' Your stock inventory for: '||f_inputname||' is 0.Requested by:'||farmer_name||' Fmer id :'||f_serial_no into agd_msgcont from dual;
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
select 'Dear '||farmer_name||' The agro dealer :'||dealer_name||' has no stock inventory for '||f_inputname||'. Fmer id :'||f_serial_no into f_msgcont from dual;
 ----------------------------------------------------------------------------------------
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,9        ,p_requestid ,p_rolloutid);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,9        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,        9,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Fail_Stock',p_payload,p_sourceaddress);
   
   
            
 else
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,9        ,p_requestid ,p_rolloutid);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
----                              values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,3        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,        9,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Fail_Stock',p_payload,p_sourceaddress);
   
   
         
 end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
END agd_stock_fail_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure AGD_SUCCESSFUL_3_1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_SUCCESSFUL_3_1" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_inputid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers 
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 select upper(inputname) into f_inputname from g3_inputs where inputid = p_inputid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 select 'Dear '||dealer_name||' pls give '||farmer_name||' 1Bag/vol of GES Approved size of : '||f_inputname||'. Fmer id :'||f_serial_no into agd_msgcont from dual;
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
select 'Dear '||farmer_name||' pls collect '||' 1Bag/vol of GES Approved size of : '||f_inputname||' From '||dealer_name||'. Fmer id :'||f_serial_no||' R_id :'||p_rolloutid into f_msgcont from dual; 
 ----------------------------------------------------------------------------------------
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,7        ,p_requestid ,p_rolloutid); 
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7     ,7        ,p_rolloutid);
  
insert into g3_transactions(DEBIT    ,BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(f_f_s_sub,p_bundleid,p_requestid,1       ,        7,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Successful_tran',p_payload,p_sourceaddress);
   
   
insert into g3_stocklevel(INPUTID ,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID  ,REMARKS                       ,requestid  ,serviceid)
                     values(p_inputid,p_dealerid  ,1           ,0       ,p_farmerid,'AGD_FS_Fmers_Successful_tran',p_requestid,        7);
  
  
  
insert into g3_account(DEBIT      ,credit ,FARMERID  ,F_MSISDN,DEALERID  ,D_MSISDN       ,ROLLOUTID  ,BUNDLEID   ,REMARKS                       ,serviceid)
                  values(f_f_s_sub,      0,p_farmerid,f_msisdn,p_dealerid,p_sourceaddress,p_rolloutid,p_bundleid ,'AGD_FS_Fmers_Successful_tran',        7);
                 
 else 
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME    ,status,serviceid,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'        ,p_request_total,p_requestid,dealer_name,7     ,7        ,p_rolloutid); 
                                
                                
---insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid ,rolloutid)
 ---                               values(f__msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7     ,7        ,p_rolloutid);
  
insert into g3_transactions(DEBIT    ,BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(f_f_s_sub,p_bundleid,p_requestid,1       ,        7,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_Fmers_Successful_tran',p_payload,p_sourceaddress);
   
   
insert into g3_stocklevel(INPUTID ,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID  ,REMARKS                       ,requestid  ,serviceid)
                       values(p_inputid,p_dealerid  ,1           ,0       ,p_farmerid,'AGD_FS_Fmers_Successful_tran',p_requestid,        7);
  
  
  
insert into g3_account(DEBIT     ,credit,FARMERID  ,F_MSISDN,DEALERID  ,D_MSISDN       ,ROLLOUTID  ,BUNDLEID   ,REMARKS                       ,serviceid)
                values(f_f_s_sub,      0,p_farmerid,f_msisdn,p_dealerid,p_sourceaddress,p_rolloutid,p_bundleid ,'AGD_FS_Fmers_Successful_tran',        7);

         
 end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
END;

/
--------------------------------------------------------
--  DDL for Procedure AGD_SYNTAX_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD_SYNTAX_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_f_serial_no in varchar2,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname    varchar2(100);
f_vkeyword  varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;

f_dealerid   number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 /*
 select translate(upper(DEALERNAME),'~1234567890','~'),dealerid into dealer_name,f_dealerid
 from g3_agrodealers  
 where phonenumber = p_sourceaddress;
 -----------------------------------------------------------------------------------------
 
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 
*/
 ----------------------------------------------------------------------------------------
 /*
    select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
*/
----------------------------------------------------------------------------------------
---- select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 ---dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 ---select inputname into f_inputname from g3_inputs where inputid = p_inputid;
select vcname,vkeyword into f_vcname,f_vkeyword from g3_value_chain where vcid = p_vcid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 
 select 'Dear '||p_sourceaddress||' your syntax for Agrodealer/Field staff Tran. is incorrect.The syntax :'||f_vkeyword||'3 U N R 1234 :Where 1234 is the farmer id. your wrong Payload: '||p_payload||'. Fmer id :'||p_f_serial_no into agd_msgcont from dual;
 
 
----------------------------------------------------------------------------------------
 /*
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,11       ,p_requestid ,0);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,11       ,0);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2     ,       11,p_farmerid  ,p_dealerid,f_msisdn   ,0          ,p_vcid,'AGD_FS_Fmers_Fail_Center'    ,p_payload ,p_sourceaddress);
   
   
            
 else
 */
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,8        ,p_requestid ,0);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
----                              values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,20        ,p_rolloutid);
  
insert into g3_transactions(REQUESTID  ,STATUSID,SERVICEID   ,DEALERID  ,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                    values(p_requestid ,2       ,        8  ,f_dealerid ,0          ,p_vcid,'AGD_FS_Fmers_Wrong_SyntaxFail'   ,p_payload,p_sourceaddress);
   
   
         
 ---end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := NULL;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END agd_syntax_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure AGD3STRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGD3STRTOKEN" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,line IN varchar2, tokenChar IN varchar2 default ';')
    is
      TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
        index by binary_integer;
      --
      tokens    tokenTableType;
      vCnt      integer := 1;
      myLine    varchar2(4000) := null;
      vPos      integer := 1;
      
      fmer_serial_no    varchar2(4000);
      test_fmer_serial_no    varchar2(4000);
      test_fun      integer := 1;
      
      
      --
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     
      ------------------------------------------------------------------ 
      
     for vCnt in tokens.first..tokens.last
     loop
       --dbms_output.put_line(vCnt||'  '||tokens(vCnt));
       if vCnt != tokens.last then
       continue;
       end if;
       
       begin
           test_fmer_serial_no := tokens(vCnt);
           if is_number(test_fmer_serial_no) = 'Y' then
           fmer_serial_no := test_fmer_serial_no;
            elsif is_number(test_fmer_serial_no) = 'N' then
           fmer_serial_no := 0;

           goto wrong_syntax;
           End if;
      exception 
      when others then
      fmer_serial_no :=0;
      goto wrong_syntax;
      end;   

       dbms_output.put_line(vCnt||'  '||fmer_serial_no);
     end loop;
     
     
     --------------------------------------------------------------------
        
      
      
      
      
      
      
      
     if foragdregistn_center_check(SOURCEADDRESS,fmer_serial_no) = 1 then
     
    dbms_output.put_line('Center Pass :The Farmer with ID  :'||fmer_serial_no||' is in your redemption center/is Activated');
    
         
    
    
     for vCnt in 1..tokens.count()
     loop
     if tokens(vCnt) = 'GES3' then
     CONTINUE;
     end if;
     
     
     if replace(tokens(vCnt),'',NULL) = fmer_serial_no then
     CONTINUE;
     end if;
     
     
  
      ---------------------------------BEGIN Check If Farmer is assign bundle--------------------------------
    if foragd_bundle_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
    
    dbms_output.put_line('Bundle Pass :The Farmer with ID  :'||fmer_serial_no||' is assign this bundle '||tokens(vCnt));
    -------------------------------------------BEGIN Check Agro dealer stock-------------------------------------------------
     if foragd_stock_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
    
    dbms_output.put_line('AGD Stock Pass :The Farmer with ID  :'||fmer_serial_no||' can redeem this input '||tokens(vCnt));
    ----------------------------------BEGIN Check credit Balance--------------------------------------------------------------
    if forAGDfarmers_credit_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
        
    g3_agd_tran_msg_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no);    
    dbms_output.put_line('Fmers Credit Bal Pass :The Farmer with ID  :'||fmer_serial_no||' has enough credit to redeem this input '||tokens(vCnt));
    else
        G3_AGD_TRAN_MSG_FAIL_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no); 
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
     dbms_output.put_line('Fmers Credit Bal FAIL :The Farmer with ID  :'||fmer_serial_no||' has no enough credit to redeem this input '||tokens(vCnt));
    
     continue;
     end if;
    ----------------------------------END Check credit Balance--------------------------------------------------------------
    else
        g3_agd_tran_stock_fail_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no); 
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
     dbms_output.put_line('AGD Stock Fail :The Farmer with ID  :'||fmer_serial_no||' cannot redeem this input '||tokens(vCnt));
    
     continue;
     end if;
   -----------------------------------END Check Agro dealer stock----------------------------------------
    
       else
           g3_agd_tran_bdles_fail_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no);
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
     dbms_output.put_line('Bundle Fail :The Farmer with ID  :'||fmer_serial_no||' is not assigned this bundle '||tokens(vCnt));
    
     continue;
     end if;
     ---------------------------------END Check If Farmer is assign bundle--------------------------------
       end loop;
    
  
    
     else
         G3_AGD_TRAN_CENTER_FAIL_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no);
     dbms_output.put_line('The Farmer with ID  :'||fmer_serial_no||' is not registered or not in your redemption center');
     end if;
     <<wrong_syntax>>
         
       g3_agd_tran_ivlid_req_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no);
     dbms_output.put_line('Request syntax failed:'||fmer_serial_no||' Format GES3 U N M 2143 '||test_fmer_serial_no);
    
     
     --
     --
--commit;
   end;

/
--------------------------------------------------------
--  DDL for Procedure AGDSTRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."AGDSTRTOKEN" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,line IN varchar2, tokenChar IN varchar2 default ' ')
    is
      TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
        index by binary_integer;
      --
      tokens    tokenTableType;
      vCnt      integer := 1;
      myLine    varchar2(4000) := null;
      vPos      integer := 1;
      v_total   number := 0;
     --
     begin
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     --select tokens.count() into v_total from dual;
      -----Total Count
     for vCnt in 1..tokens.count()
     loop
       v_total := v_total + 1;
     end loop;
     dbms_output.put_line('AGD'||'           '||'Input Name'||'        '||'No_Request'||'         '||'REQUEST ID');
     for vCnt in 1..tokens.count()
     loop
             
       dbms_output.put_line(vCnt||'                  '||tokens(vCnt)||'                 '||v_total||'                  '||requestid||'            '||SOURCEADDRESS);
     end loop;
     EXCEPTION
     
     WHEN Others THEN
      raise_application_error (-20001,'Your Request Syntax is wrong.');
      end;      
     --
   end;

/
--------------------------------------------------------
--  DDL for Procedure BROADCASTMSG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."BROADCASTMSG" as

BEGIN
  FOR item IN (
    SELECT MESSAGEID,MESSAGECONTENT,DESTADDRESS,STATUS,SOURCEADDRESS
from  g3_outmessages_unsent  where STATUS=7 and rownum <5
   
  ) LOOP
  sendsmsII(item.MESSAGECONTENT,item.DESTADDRESS,ITEM.SOURCEADDRESS);
  update g3_outmessages_unsent set status=11,DATEMODIFIED=systimestamp where MESSAGEID=item.MESSAGEID;
    END LOOP;
    commit;
END;

/
--------------------------------------------------------
--  DDL for Procedure BULK_INSERT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."BULK_INSERT" is

  
      cursor c_tab is
       select * from testcode_rout;
  
     type t__tab is table of c_tab%rowtype index by binary_integer;
     t_tab t__tab;
 
   begin
 
      open c_tab;
 
      loop
        fetch c_tab bulk collect
         into t_tab limit 10;
 
        exit when t_tab.count = 0;
 
        forall ii in t_tab.first .. t_tab.last
        
        ---DBMS_OUTPUT.put_line('LIMIT 100: ' ||t_tab(i).FARMERS_CON);
        
         insert into testcode_rout_ins 
         values t_tab(ii)  ;
 
        commit;
 
      end loop;
 
      close c_tab;
 
   end;

/
--------------------------------------------------------
--  DDL for Procedure BUNDLE_MSG_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."BUNDLE_MSG_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_name_bundle varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;



begin 
    select f_name into fmer_name_bundle from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name_bundle := NULL;
END;






begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword) ;
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
  
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := NULL;
END;

begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := NULL;
END;

begin
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := NULL;
END;

begin
select concat(concat(fmer_fullname,p_input_keyword),' : NOT_ENTITTLE') into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := NULL;
END;

insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);
begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
and  upper(keyword) = upper(p_input_keyword);

EXCEPTION
WHEN others THEN
    t_BUNDLEID := NULL;
t_INPUTID  := NULL;
t_FARMERID := NULL;
t_DEALERID := NULL;
t_PHONENUMBER := NULL;
t_ROLLOUTID := NULL;
t_FIELDSTAFFID := NULL;
t_VCID := NULL;
END;



insert into g3_transactions(DEBIT,BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID)
                     values(f_s_input_sub,t_BUNDLEID,p_requestid,1,1,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
  --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure CBNREPORT_I
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."CBNREPORT_I" is 
BEGIN

execute immediate ' create table O_REPORT_ROLLEDOUT AS 
 select s.stateName,l.lgaName,count(*) as TT from
g3_farmers_rollout fr,  g3_farmers f, g3_states s ,g3_lga l
where fr.farmerID = f.farmerID and f.stateID=s.stateID and f.lgaID=l.lgaID 
group by s.stateName,l.lgaName
order by s.stateName,l.lgaName
';
END;

/
--------------------------------------------------------
--  DDL for Procedure CIMPLAINT_GES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."CIMPLAINT_GES" (p_phonenumber in number, farmerid in number)
is
c_phone  number;
c_farmerid number;
c_complaint number;
d_phone number;
f_sourceaddress number;
t_source number;
l_count  number;
begin
select farmerdid into c_farmerid from  g3_complaintsges c
where c.phonenumber =  p_phonenumber
and complaintscode =1;
EXCEPTION
when others then
c_farmerid :=0;
end;
dbms_output.put_line('The phone number of farmers :'||c_farmerid);

begin
select f.msisdn into t_source  from g3_farmers f
where f.msisdn = p_phonenumber;
EXCEPTION
when others then
t_source :=0;
end;
dbms_output.put_line('The the phone number exist :'||t_source);
begin
select  sourceaddress into  c_phone from g3_outmessages o 
where o.sourceaddress = p_phonenumber;
EXCEPTION
when others then
c_phone := 0;
dbms_output.put_line('The the phone number exist :'||c_phone);
end;

/
--------------------------------------------------------
--  DDL for Procedure CREATE_FARMER_REDMPTION_COUNT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."CREATE_FARMER_REDMPTION_COUNT" is 
BEGIN

execute immediate 'drop table AGD_payload_request';

 execute immediate
 '  create table AGD_payload_request as 
 select s.stateName as STATENAME, l.lgaName as LGANAME, ag.DEALERNAME as DEALERNAME,
 ag.DEALERID as DEALERID ,ag.PHONENUMBER as PHONENUMBER, r.REDEMP_CENTER as REDEMP_CENTER,
 count(distinct i.messagecontent) as tt, count(distinct i.messagecontent) * 5500 as TTV
 from g3_agroDealers ag,g3_states s,g3_lga l,g3_inboundgesmessages i,g3_rollout r
where ag.stateID=s.stateID and ag.lgaID=l.lgaID and  r.dealerID=ag.dealerID and 
ag.PHONENUMBER =i.sourceAddress  
group by  s.stateName as STATENAME,l.lgaName as LGANAME, ag.DEALERNAME as DEALERNAME,
 ag.DEALERID as DEALERID ,ag.PHONENUMBER as PHONENUMBER,r.REDEMP_CENTER as REDEMP_CENTER
order by  s.stateName as STATENAME,l.lgaName as LGANAME, ag.DEALERNAME as DEALERNAME,
 ag.DEALERID as DEALERID ,ag.PHONENUMBER as PHONENUMBER,r.REDEMP_CENTER as REDEMP_CENTER
';
END;

/
--------------------------------------------------------
--  DDL for Procedure CREATE_TRANSACTION_TBS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."CREATE_TRANSACTION_TBS_PROC" IS



---EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN

execute immediate 'drop table total_agd_tran';
execute immediate 'drop table total_state_tran';

execute immediate 'create table total_agd_tran as 
select s.stateid, upper(s.statename) state,l.lgaid,upper(l.lganame) lga,a.dealerid,upper(a.dealername) dealername,
count(t.TRANSACTIONID) tt,sum(nvl(debit,0)) tran_vol

            
from g3_transactions t,g3_agrodealers a,g3_states s,g3_lga l
where t.dealerid =  a.dealerid
and  a.stateid = s.stateid
and  a.lgaid = l.lgaid
and statusid = 1
group by s.stateid,s.statename,l.lgaid,l.lganame,a.dealerid,a.dealername
order by 1,2,3,4';


execute immediate 'create table total_state_tran as select
s.stateid,upper(s.statename) state,
count(t.TRANSACTIONID) tt,sum(nvl(t.debit,0)) tran_vol
            
from g3_transactions t,g3_agrodealers a,g3_states s
where t.dealerid =  a.dealerid
and  a.stateid = s.stateid
and statusid = 1
group by s.stateid,s.statename
order by 1';


---execute immediate 'select stateid,lgaid,dealerid,dealername,phonenumber,count(distinct regexp_replace(replace(replace(replace(replace(replace(replace(replace(upper(messagecontent),"GES3",""),"GES2",""),"N",""),"U",""),"M",""),"-",""),"R",""),"[[:space:]]", "")) tt,count(distinct regexp_replace(replace(replace(replace(replace(replace(replace(replace(upper(messagecontent),"GES3",""),"GES2",""),"N",""),"U",""),"M",""),"-",""),"R",""),"[[:space:]]", "")) * 5500 ttv
----from g3_agrodealers a,g3_inboundgesmessages i
----where phonenumber = msisdn
----group by stateid,lgaid,dealerid,dealername,phonenumber;';

END;

/
--------------------------------------------------------
--  DDL for Procedure CREATE_VIEW_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."CREATE_VIEW_PROC" IS


var_FARMERS_CON      start_rout.FARMERS_CON%type; 

v_result number(30);

 

---EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN

execute immediate 'drop table total_rollout_tb';

execute immediate 'create table total_rollout_tb as
select count(o.FRID) total, count(o.FRID) total2
from g3_farmers_rollout o';
END;

/
--------------------------------------------------------
--  DDL for Procedure EX_AGD3STRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_AGD3STRTOKEN" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,line IN varchar2, tokenChar IN varchar2 default ';')
    is
      TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
        index by binary_integer;
      --
      tokens    tokenTableType;
      vCnt      integer := 1;
      myLine    varchar2(4000) := null;
      vPos      integer := 1;
      
      fmer_serial_no    varchar2(4000);
      test_fmer_serial_no    varchar2(4000);
      test_fun      integer := 1;
      
      
      --
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     
      ------------------------------------------------------------------ 
      
     for vCnt in tokens.first..tokens.last
     loop
  --dbms_output.put_line(vCnt||'  '||tokens(vCnt));
       if vCnt != tokens.last then
       continue;
       end if;
       
       begin
           test_fmer_serial_no := tokens(vCnt);
           if is_number(test_fmer_serial_no) = 'Y' then
           fmer_serial_no := test_fmer_serial_no;
            elsif is_number(test_fmer_serial_no) = 'N' then
           fmer_serial_no := 0;

           goto wrong_syntax;
           End if;
      exception 
      when others then
      fmer_serial_no :=0;
      goto wrong_syntax;
      end;   

     -- dbms_output.put_line(vCnt||'  '||fmer_serial_no);
     end loop;
     
     
     --------------------------------------------------------------------
        
      
      
      
      
      
      
      
     if ex_foragdregistn_center_check(SOURCEADDRESS,fmer_serial_no) = 1 then
     
   -- dbms_output.put_line('Center Pass :The Farmer with ID  :'||fmer_serial_no||' is in your redemption center/is Activated');
    
         
    
    
     for vCnt in 1..tokens.count()
     loop
     if tokens(vCnt) = 'GES3' then
     CONTINUE;
          end if;
     
     
     if replace(tokens(vCnt),'',NULL) = fmer_serial_no then
     CONTINUE;
end if;
    
     
     
  
      ---------------------------------BEGIN Check If Farmer is assign bundle--------------------------------
    if ex_foragd_bundle_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
    
   -- dbms_output.put_line('Bundle Pass :The Farmer with ID  :'||fmer_serial_no||' is assign this bundle '||tokens(vCnt));
    -------------------------------------------BEGIN Check Agro dealer stock-------------------------------------------------
     if ex_foragd_stock_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
    
   -- dbms_output.put_line('AGD Stock Pass :The Farmer with ID  :'||fmer_serial_no||' can redeem this input '||tokens(vCnt));
    ----------------------------------BEGIN Check credit Balance--------------------------------------------------------------
    if ex_forAGDfarmers_credit_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
        
    ex_g3_agd_tran_msg_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no);    
  --  dbms_output.put_line('Fmers Credit Bal Pass :The Farmer with ID  :'||fmer_serial_no||' has enough credit to redeem this input '||tokens(vCnt));
    else
        ex_G3_AGD_TRAN_MSG_FAIL_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no); 
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
   --  dbms_output.put_line('Fmers Credit Bal FAIL :The Farmer with ID  :'||fmer_serial_no||' has no enough credit to redeem this input '||tokens(vCnt));
    
     continue;
     end if;
    ----------------------------------END Check credit Balance--------------------------------------------------------------
    else
        ex_g3_agd_tran_stock_fail_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no); 
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
    -- dbms_output.put_line('AGD Stock Fail :The Farmer with ID  :'||fmer_serial_no||' cannot redeem this input '||tokens(vCnt));
    
     continue;
     end if;
   -----------------------------------END Check Agro dealer stock----------------------------------------
    
       else
           ex_g3_agd_tran_bdles_fail_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no);
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
   -- dbms_output.put_line('Bundle Fail :The Farmer with ID  :'||fmer_serial_no||' is not assigned this bundle '||tokens(vCnt));
    
     continue;
     end if;

     ---------------------------------END Check If Farmer is assign bundle--------------------------------
       end loop;
    
  
    
     else
         ex_G3_AGD_TRAN_CTER_FAIL_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no);
   --dbms_output.put_line('The Farmer with ID  :'||fmer_serial_no||' is not registered or not in your redemption center');
     end if;
 
     <<wrong_syntax>>
         
       ex_g3_agd_tran_ivlid_req_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total,fmer_serial_no);
    -- dbms_output.put_line('Request syntax failed:'||fmer_serial_no||' Format GES3 U N M 2143 '||test_fmer_serial_no);
    
     
     --
     --
--commit;
   end;

/
--------------------------------------------------------
--  DDL for Procedure EX_G3_AGD_STOCK_FAILED_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_G3_AGD_STOCK_FAILED_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_name_bundle varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
     
     s_dealerid number;
    s_state_lgaid number;
    s_fieldstaffid number;
    s_lgaid number;
    s_inputid number;
    
   
    
    l_count number;
    
begin
/*
begin
select s.amount,f.dealerid,concat(f.stateid,f.lgaid),f.lgaid,fs.fieldstaffid into s_input_sub,s_dealerid,s_state_lgaid,s_lgaid,s_fieldstaffid 
from g3_subsidy_input_alloc s,g3_agrodealers f,g3_inputs i,g3_fieldstaff fs
where s.escrow_acct_id = f.stateid
and  s.inputid = i.inputid
and  f.dealerid = fs.agrodealerid
and  (f.phonenumber =p_sourceaddress or fs.phonenumber =p_sourceaddress)
and   upper(i.keyword) = upper(p_input_keyword);
--and rownum = 1;

EXCEPTION

WHEN others THEN
    s_input_sub := 0;
    s_dealerid := 0;
    s_state_lgaid := 0;
    s_fieldstaffid := 0;
END;










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

*/

begin
select s.amount into s_input_sub
from g3_subsidy_input_alloc s,g3_farmers f
where s.escrow_acct_id = f.stateid
and f.msisdn = p_sourceaddress
and inputid in(select inputid from g3_inputs where upper(keyword) = upper(p_input_keyword));
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

select replace(replace(f_name,'_',' '),'<',' '),replace(replace(f_name,'_',' '),'<',' '),concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),s.inputid into fmer_name,fmer_name_bundle,fmer_id,s_inputid 
from g3_subsidy_input_alloc s,g3_farmers f
where s.escrow_acct_id = f.stateid
and f.msisdn = p_sourceaddress
and inputid in(select inputid from g3_inputs where upper(keyword) = upper(p_input_keyword))
and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name_bundle := NULL;
    fmer_name := NULL;
    fmer_id := 0;
    s_inputid :=0;
END;

/*

    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;


begin 
    select f_name into fmer_name_bundle from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name_bundle := NULL;
END;


begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;


begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
*/

begin
select upper(inputname) into f_input_name 
from g3_inputs
where inputid = s_inputid; 
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
    
begin
    select i.phonenumber,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_phone,agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
    agd_phone := NULL;
END;

/*
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
  */
      
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := NULL;
END;
begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := NULL;
END;
begin
        select concat(concat('Dear ',concat(concat(fmer_name_bundle,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := NULL;
END;
begin
    select concat(concat(concat(fmer_fullname,f_input_name),' : AGD HAS NO STOCK :'),agd_name) into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := NULL;
END;
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);
begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
and  upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID := NULL;
t_INPUTID  := NULL;
t_FARMERID := NULL;
t_DEALERID := NULL;
t_PHONENUMBER := NULL;
t_ROLLOUTID := NULL;
t_FIELDSTAFFID := NULL;
t_VCID := NULL;
END;
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,3,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_Stock_Failed',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure EX_G3_AGD_TRAN_BDLES_FAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_G3_AGD_TRAN_BDLES_FAIL_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
--    f_input_sub number;
--    f_s_input_sub number;
--    fmers_bal number;
--    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
--    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
--    l_count number;

    s_dealerid_2 number;
    s_dealerid number;
    s_dealerid_phone number;
    s_stateid number;
    s_lgaid number;
    s_fieldstaffid number;
--    s_farmerid number;
--    fmers_farmerid number;
    
    
begin

    
 begin
select f.phonenumber,s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid into s_dealerid_phone,s_input_sub,s_dealerid,s_stateid,s_lgaid,s_fieldstaffid 
from g3_subsidy_input_alloc s,g3_agrodealers f,g3_inputs i,g3_fieldstaff fs
where s.escrow_acct_id = f.stateid
and  s.inputid = i.inputid
and  f.dealerid = fs.agrodealerid
and  (f.phonenumber =p_sourceaddress or fs.phonenumber =p_sourceaddress)
and  upper(i.keyword) = upper(p_input_keyword);
--and rownum = 1;


EXCEPTION

WHEN others THEN
--    s_input_sub := 0;
--    s_dealerid := 0;
    s_stateid := 0;
--    s_fieldstaffid := 0;
--    s_dealerid_phone :=0;
END;   
    
    
    
    
/*    
begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
*/
    /*
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
*/
    
 begin 
    
--MN    select a.dealerid ,concat(concat(concat(concat(f.stateid,'-'),f.lgaid),'-'),f.serial_number) ,replace(replace(f_name,'_',' '),'null',' ')    ,replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(a.DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'')  ,a.phonenumber into s_dealerid_2,fmer_id,fmer_name,agd_name,agd_phone 
    select a.dealerid, f.stateid || '-' || f.lgaid || '-' || f.serial_number, replace(replace(f_name, '_', ' '), 'null', ' '), translate(upper(a.DEALERNAME), '~1234567890', '~'), a.phonenumber into s_dealerid_2, fmer_id, fmer_name, agd_name, agd_phone
    from g3_farmers_rollout fr,g3_rollout r,g3_farmers f,g3_agrodealers a
    where fr.rolloutid = r.rolloutid
    and fr.farmerid = f.farmerid
    and r.dealerid = a.dealerid
    and a.phonenumber = p_sourceaddress
  --  and (concat(concat(f.stateid,f.lgaid),f.serial_number) = p_serial_number or f.serial_number = p_serial_number);
    and ((f.stateid = s_stateid AND f.serial_number = p_serial_number )
      or f.serial_number = p_serial_number);
    
    
    
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
    fmer_name :=Null;
    agd_name :=null;
    agd_phone := null;
    s_dealerid_2 := null;
END;
    
    
    
    
 /*   
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;


begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
*/
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' Input Not Entitled :'),p_input_keyword),fmer_name),fmer_id),' :') into agd_details_full from dual;
select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Input Not Entitled :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
                       
begin                      
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and f.dealerid = s_dealerid_2 
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
--    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,10,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Fail_bundle',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
--commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure EX_G3_AGD_TRAN_CTER_FAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_G3_AGD_TRAN_CTER_FAIL_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
--    f_input_sub number;
--    f_s_input_sub number;
--    fmers_bal number;
--    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
    t_VCID number;
    S_DEALERID number;
    S_STATEID number;
    S_LGAID number;
    S_FIELDSTAFFID number;
    
   
    
--    l_count number;
    
begin
    
    
    
     begin
select s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid,upper(i.inputname),i.inputid   into s_input_sub,s_dealerid,s_stateid,s_lgaid,s_fieldstaffid,f_input_name,t_INPUTID 
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
    s_lgaid := 0;
    f_input_name := NULL;
    t_INPUTID :=Null;
END;
    
    
  
begin
--MN    select concat(concat(concat(concat(concat(f.stateid,'-'),f.lgaid),'-('),f.serial_number),')'),replace(replace(f_name,'_',' '),'null',' '),replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(a.DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,''),a.phonenumber,r.bundleid,r.vcid,r.dealerid,r.fieldstaffid,r.rolloutid,f.farmerid,f.msisdn   into fmer_id,fmer_name,agd_name,agd_phone,t_BUNDLEID,t_VCID,t_DEALERID,t_FIELDSTAFFID,t_ROLLOUTID,t_FARMERID,t_PHONENUMBER 
    select f.stateid || '-' || f.lgaid || '-(' || f.serial_number || ')', replace(replace(f_name, '_', ' '), 'null', ' '), translate(upper(a.DEALERNAME),'~1234567890','~'), a.phonenumber, r.bundleid, r.vcid, r.dealerid, r.fieldstaffid, r.rolloutid, f.farmerid, f.msisdn into fmer_id, fmer_name, agd_name, agd_phone, t_bundleid, t_vcid, t_dealerid, t_fieldstaffid, t_rolloutid, t_farmerid, t_phonenumber
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
    fmer_id := NULL;
    fmer_name := NULL;
    agd_name  := NULL;
    agd_phone := NULL;
    t_BUNDLEID :=NULL;
    t_VCID :=NULL;
    t_DEALERID :=NULL;
--    t_FIELDSTAFFID :=NULL;
    t_ROLLOUTID :=NULL;
    t_FARMERID :=NULL;
    t_PHONENUMBER :=NULL;
END;
    


    
    
    
    
/*
    begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
--s_f_total_sub := f_input_sub + s_input_sub;

begin
select s_f_total_sub into f_s_input_sub from dual;
EXCEPTION
WHEN others THEN
    f_s_input_sub := 0;
END;

begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;

*/
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' Not In Your Center :'),f_input_name),fmer_name),p_serial_number),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Not In Your Center :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
/*                       
begin                      
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 */
 
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,11,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Fail_Center',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure EX_G3_AGD_TRAN_IVLID_REQ_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_G3_AGD_TRAN_IVLID_REQ_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
--    f_input_sub number;
--    f_s_input_sub number;
--    fmers_bal number;
--    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
     S_DEALERID number;
     S_STATEID number;
     S_FIELDSTAFFID number;
     S_LGAID number;
    
   
    
--    l_count number;
    
begin
    
    
   begin
select s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid,upper(i.inputname),i.inputid   into s_input_sub,s_dealerid,S_STATEID,s_lgaid,s_fieldstaffid,f_input_name,t_INPUTID 
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
--    S_STATEID := 0;
--    s_fieldstaffid := 0;
    s_lgaid := 0;
    f_input_name := NULL;
    t_INPUTID :=Null;
END; 
    
   
    
    
    
    
    
  begin
--MN    select concat(concat(concat(concat(concat(f.stateid,'-'),f.lgaid),'-('),f.serial_number),')'),replace(replace(f_name,'_',' '),'null',' '),replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(a.DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,''),a.phonenumber,r.bundleid,r.vcid,r.dealerid,r.fieldstaffid,r.rolloutid,f.farmerid,f.msisdn   into fmer_id,fmer_name,agd_name,agd_phone,t_BUNDLEID,t_VCID,t_DEALERID,t_FIELDSTAFFID,t_ROLLOUTID,t_FARMERID,t_PHONENUMBER 
    select f.stateid || '-' || f.lgaid || '-(' || f.serial_number || ')', replace(replace(f_name, '_', ' '), 'null', ' '), translate(upper(a.DEALERNAME),'~1234567890','~'), a.phonenumber, r.bundleid, r.vcid, r.dealerid, r.fieldstaffid, r.rolloutid, f.farmerid, f.msisdn into fmer_id, fmer_name, agd_name, agd_phone, t_bundleid, t_vcid, t_dealerid, t_fieldstaffid, t_rolloutid, t_farmerid, t_phonenumber
from g3_farmers_rollout fr,g3_rollout r,g3_farmers f,g3_agrodealers a,g3_fieldstaff fs
where fr.rolloutid = r.rolloutid
and fr.farmerid = f.farmerid
and  a.dealerid = r.dealerid
and  fs.fieldstaffid = r.fieldstaffid
and a.lgaid = s_lgaid
and a.dealerid = s_dealerid
--and (concat(S_STATEID,f.serial_number) =  p_serial_number or f.serial_number = p_serial_number)
and rownum = 1;

EXCEPTION
WHEN others THEN
    fmer_id := NULL;
    fmer_name := NULL;
    agd_name  := NULL;
    agd_phone := NULL;
    t_BUNDLEID :=NULL;
    t_VCID :=NULL;
    t_DEALERID :=NULL;
--    t_FIELDSTAFFID :=NULL;
    t_ROLLOUTID :=NULL;
    t_FARMERID :=NULL;
    t_PHONENUMBER :=NULL;
END;
    
    
    
    /*
    begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
-- s_f_total_sub := f_input_sub + s_input_sub;

begin
select s_f_total_sub into f_s_input_sub from dual;
EXCEPTION
WHEN others THEN
    f_s_input_sub := 0;
END;

begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and rownum = 1;
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and rownum = 1;
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
*/
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' Format is GES3 U N M 1-1-2312 Invalid Syntax.:'),f_input_name),fmer_name),fmer_id),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') No/Low Credit for :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);

/*
 begin                      
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and rownum = 1;
    
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 */
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,8,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Wrong_SyntaxFail',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
  --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure EX_G3_AGD_TRAN_MSG_FAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_G3_AGD_TRAN_MSG_FAIL_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
--    f_input_sub number;
--    f_s_input_sub number;
--    fmers_bal number;
--    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    s_dealerid number;
    S_STATEID number;
    S_LGAID number;
    S_FIELDSTAFFID number;
    
   
    
--    l_count number;
    
begin
    
begin
select s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid,upper(i.inputname),i.inputid   into s_input_sub,s_dealerid,S_STATEID,s_lgaid,s_fieldstaffid,f_input_name,t_INPUTID 
from g3_subsidy_input_alloc s,g3_agrodealers f,g3_inputs i,g3_fieldstaff fs
where s.escrow_acct_id = f.stateid
and  s.inputid = i.inputid
and  f.dealerid = fs.agrodealerid
and  (f.phonenumber =p_sourceaddress or fs.phonenumber =p_sourceaddress)
and  upper(i.keyword) = upper(p_input_keyword);
--and rownum = 1;
EXCEPTION
WHEN others THEN
--    s_input_sub := 0;
    s_dealerid := 0;
    S_STATEID := 0;
--    s_fieldstaffid := 0;
    s_lgaid := 0;
    f_input_name := NULL;
    t_INPUTID :=Null;
END;

/*
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

*/

begin
--MN    select concat(concat(concat(concat(concat(f.stateid,'-'),f.lgaid),'-('),f.serial_number),')'),replace(replace(f_name,'_',' '),'null',' '),replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(a.DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,''),a.phonenumber,r.bundleid,r.vcid,r.dealerid,r.fieldstaffid,r.rolloutid,f.farmerid,f.msisdn   into fmer_id,fmer_name,agd_name,agd_phone,t_BUNDLEID,t_VCID,t_DEALERID,t_FIELDSTAFFID,t_ROLLOUTID,t_FARMERID,t_PHONENUMBER 
    select f.stateid || '-' || f.lgaid || '-(' || f.serial_number || ')', replace(replace(f_name, '_', ' '), 'null', ' '), translate(upper(dealername),'~1234567890','~'), a.phonenumber, r.bundleid, r.vcid, r.dealerid, r.fieldstaffid, r.rolloutid, f.farmerid, f.msisdn into fmer_id, fmer_name, agd_name, agd_phone, T_BUNDLEID, T_VCID, T_DEALERID, T_FIELDSTAFFID, T_ROLLOUTID, T_FARMERID, T_PHONENUMBER
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
    fmer_id := NULL;
    fmer_name := NULL;
    agd_name  := NULL;
    agd_phone := NULL;
    t_BUNDLEID :=NULL;
    t_VCID :=NULL;
    t_DEALERID :=NULL;
--    t_FIELDSTAFFID :=NULL;
    t_ROLLOUTID :=NULL;
    t_FARMERID :=NULL;
    t_PHONENUMBER :=NULL;
END;
    
    

/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;

    
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;

*/
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' No/Low Credit for :'),f_input_name),fmer_name),fmer_id),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') No/Low Credit for :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);

/*
begin                       
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
    EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 */
 
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,8,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Fail_Credit',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure EX_G3_AGD_TRAN_MSG_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_G3_AGD_TRAN_MSG_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
--    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
--    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
--    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   

    s_dealerid number;
    s_stateid number;
    s_lgaid number;
    s_fieldstaffid number;
--    s_farmerid number;
--    fmers_farmerid number;
    
--    l_count number;
    
begin
    
    begin
select s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid,upper(i.inputname),i.inputid   into s_input_sub,s_dealerid,s_stateid,s_lgaid,s_fieldstaffid,f_input_name,t_INPUTID 
from g3_subsidy_input_alloc s,g3_agrodealers f,g3_inputs i,g3_fieldstaff fs
where s.escrow_acct_id = f.stateid
and  s.inputid = i.inputid
and  f.dealerid = fs.agrodealerid
and  (f.phonenumber =p_sourceaddress or fs.phonenumber =p_sourceaddress)
and s.inputid in (select inputid from g3_inputs where upper(keyword) = upper(p_input_keyword))
and rownum = 1;

EXCEPTION

WHEN others THEN
    s_input_sub := 0;
    s_dealerid := 0;
    s_stateid := 0;
--    s_fieldstaffid := 0;
    s_lgaid := 0;
    f_input_name := NULL;
    t_INPUTID :=Null;

END;
    
    
    
    

    /*
    begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    s_input_sub := 0;
END;
*/
    
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
/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;

*/
    
    begin
--MN    select concat(concat(concat(concat(concat(f.stateid,'-'),f.lgaid),'-('),f.serial_number),')'),replace(replace(f_name,'_',' '),'null',' '),replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(a.DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,''),a.phonenumber,r.bundleid,r.vcid,r.dealerid,r.fieldstaffid,r.rolloutid,f.farmerid,f.msisdn   into fmer_id,fmer_name,agd_name,agd_phone,t_BUNDLEID,t_VCID,t_DEALERID,t_FIELDSTAFFID,t_ROLLOUTID,t_FARMERID,t_PHONENUMBER 
    select f.stateid || '-' || f.lgaid || '-(' || f.serial_number || ')', replace(replace(f_name, '_', ' '), 'null', ' '), translate(upper(a.DEALERNAME),'~1234567890','~'), a.phonenumber, r.bundleid, r.vcid, r.dealerid, r.fieldstaffid, r.rolloutid, f.farmerid, f.msisdn into fmer_id, fmer_name, agd_name, agd_phone, t_bundleid, t_vcid, t_dealerid, t_fieldstaffid, t_rolloutid, t_farmerid, t_phonenumber
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
    fmer_id := NULL;
    fmer_name := NULL;
    agd_name  := NULL;
    agd_phone := NULL;
    t_BUNDLEID :=NULL;
    t_VCID :=NULL;
    t_DEALERID :=NULL;
--    t_FIELDSTAFFID :=NULL;
    t_ROLLOUTID :=NULL;
    t_FARMERID :=NULL;
    t_PHONENUMBER :=NULL;
END;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
/*    
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;

begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;

    
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
    
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual;
EXCEPTION
WHEN others THEN
    agd_details := null;    
END;*/
begin
select concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' Give Farmer :'),fmer_name),fmer_id),' :') into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := null;    
END;
/*
begin
select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := null;    
END;
*/        
begin        
select concat(agd_details_full,f_input_name) into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := null;    
END;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
/*                       
begin                       
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
*/ 
 
insert into g3_transactions(DEBIT,BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(f_s_input_sub,t_BUNDLEID,p_requestid,1,7,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Successful_tran',p_input_keyword,p_sourceaddress);
insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
--  commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure EX_G3_AGD_TRAN_STOCK_FAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_G3_AGD_TRAN_STOCK_FAIL_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
--    f_input_sub number;
--    f_s_input_sub number;
--    fmers_bal number;
--    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
     S_DEALERID number;
     S_STATEID number;
     S_FIELDSTAFFID number;
     S_LGAID number;
    
   
    
--    l_count number;
    
begin
    
    begin
select s.amount,f.dealerid,f.stateid,f.lgaid,fs.fieldstaffid,upper(i.inputname),i.inputid   into s_input_sub,s_dealerid,S_STATEID,s_lgaid,s_fieldstaffid,f_input_name,t_INPUTID 
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
    S_STATEID := 0;
--    s_fieldstaffid := 0;
    s_lgaid := 0;
    f_input_name := NULL;
    t_INPUTID :=Null;
END;
    
    
    
    
    /*
begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    s_input_sub := 0;
END;
*/
    
/*    
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

*/

begin
-- MN    select concat(concat(concat(concat(concat(f.stateid,'-'),f.lgaid),'-('),f.serial_number),')'),replace(replace(f_name,'_',' '),'null',' '),replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(a.DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,''),a.phonenumber,r.bundleid,r.vcid,r.dealerid,r.fieldstaffid,r.rolloutid,f.farmerid,f.msisdn   into fmer_id,fmer_name,agd_name,agd_phone,t_BUNDLEID,t_VCID,t_DEALERID,t_FIELDSTAFFID,t_ROLLOUTID,t_FARMERID,t_PHONENUMBER 
    select f.stateid || '-' || f.lgaid || '-(' || f.serial_number || ')', replace(replace(f_name, '_', ' '), 'null', ' '), translate(upper(a.DEALERNAME),'~1234567890','~'), a.phonenumber, r.bundleid, r.vcid, r.dealerid, r.fieldstaffid, r.rolloutid, f.farmerid, f.msisdn into fmer_id, fmer_name, agd_name, agd_phone, T_BUNDLEID, T_VCID, T_DEALERID, T_FIELDSTAFFID, T_ROLLOUTID, T_FARMERID, T_PHONENUMBER
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
    fmer_id := NULL;
    fmer_name := NULL;
    agd_name  := NULL;
    agd_phone := NULL;
    t_BUNDLEID :=NULL;
    t_VCID :=NULL;
    t_DEALERID :=NULL;
--    t_FIELDSTAFFID :=NULL;
    t_ROLLOUTID :=NULL;
    t_FARMERID :=NULL;
    t_PHONENUMBER :=NULL;
END;





/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;

*/
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' No Stock for :'),f_input_name),fmer_name),fmer_id),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') No/Low Credit for :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);


/*
begin                       
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 */
     
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,9,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Fail_Stock',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure EX_G4_ROUT_DETAILS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_G4_ROUT_DETAILS_PROC" IS
/*
var_ROLLOUTID        start_rout.ROLLOUTID%type;
var_ROLLOUTNAME      start_rout.ROLLOUTNAME%type;
var_REDEMP_CENTER    start_rout.REDEMP_CENTER%type;
var_ROLLOUTDATE      start_rout.ROLLOUTDATE%type;

var_BUNDLEID         start_rout.BUNDLEID%type;
var_VCID             start_rout.VCID%type;
var_STATEID          start_rout.STATEID%type;
var_LGAID            start_rout.LGAID%type;

var_DEALERID         start_rout.DEALERID%type;
var_FIELDSTAFFID     start_rout.FIELDSTAFFID%type;
var_ROLLOUTSTATUS    start_rout.ROLLOUTSTATUS%type;
var_WARDID           start_rout.WARDID%type;
var_FARMERS_CON      start_rout.FARMERS_CON%type; 
var_RES_TYPEID       start_rout.RES_TYPEID%type;

*/

var_ROLLOUTID        PLS_INTEGER;
var_ROLLOUTNAME      varchar2(500);
var_REDEMP_CENTER    varchar2(1000);
var_ROLLOUTDATE      TIMESTAMP(6);

var_BUNDLEID         PLS_INTEGER;
var_VCID             PLS_INTEGER;
var_STATEID          PLS_INTEGER;
var_LGAID            PLS_INTEGER;

var_DEALERID         PLS_INTEGER;
var_FIELDSTAFFID     PLS_INTEGER;
var_ROLLOUTSTATUS    varchar2(500);
var_WARDID           PLS_INTEGER;
var_FARMERS_CON      PLS_INTEGER; 
var_RES_TYPEID       PLS_INTEGER;
var_GES_YEAR         PLS_INTEGER;


v_result PLS_INTEGER;
----v_result number(30);

 

---//declaring a cursor
---CURSOR ROUT_CURSOR IS select FARMERS_CON,ROLLOUTID,ROLLOUTNAME,REDEMP_CENTER,ROLLOUTDATE,BUNDLEID,VCID,STATEID,LGAID,DEALERID,FIELDSTAFFID,ROLLOUTSTATUS,WARDID,RES_TYPEID from start_rout;

CURSOR ROUT_CURSOR IS select r.ges_year,r.FARMERS_CON,r.ROLLOUTID,r.ROLLOUTNAME,r.REDEMP_CENTER,r.ROLLOUTDATE,r.BUNDLEID,r.VCID,r.STATEID,r.LGAID,r.DEALERID,r.FIELDSTAFFID,r.ROLLOUTSTATUS,m.WARDID,r.RES_TYPEID
from G4_ROUT_WARDS_MAPPING m,G4_ROLLOUT  r
where r.ROLLOUTID = m.ROLLOUTID 
and    m.processedid is null
and   r.ROLLOUTDATE < systimestamp
---and   m.wardid in( 1,2,3,4,5)
and    rownum < 10;


--EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN
---/opening a cursor//
open ROUT_CURSOR;
LOOP
--//fetching records from a cursor//
fetch ROUT_CURSOR into var_GES_YEAR,var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID;
--//testing exit conditions//
EXIT when ROUT_CURSOR%NOTFOUND;

----Update_fmer_4rout (var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID);



DBMS_OUTPUT.put_line(var_FARMERS_CON||'--- '||var_ROLLOUTID||'---- '||var_ROLLOUTNAME||'--- '||var_REDEMP_CENTER||'--- '||var_ROLLOUTDATE||'---- '||var_BUNDLEID);

END LOOP;
--//closing the cursor//
close ROUT_CURSOR;
--DBMS_OUTPUT.put_line('DONE');
END;

/
--------------------------------------------------------
--  DDL for Procedure EX_UPDATE_FMER_4ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."EX_UPDATE_FMER_4ROUT" (p_FARMERS_CON PLS_INTEGER,p_ROLLOUTID PLS_INTEGER,p_ROLLOUTNAME varchar2,p_REDEMP_CENTER varchar2,p_ROLLOUTDATE timestamp,p_BUNDLEID PLS_INTEGER,p_VCID PLS_INTEGER,p_STATEID PLS_INTEGER,p_LGAID PLS_INTEGER,p_DEALERID PLS_INTEGER,p_FIELDSTAFFID PLS_INTEGER,p_ROLLOUTSTATUS varchar2,p_WARDID PLS_INTEGER,p_RES_TYPEID PLS_INTEGER )
IS
f_exist PLS_INTEGER;
r_completed PLS_INTEGER;
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;

----TYPE dept_tab_type IS TABLE OF farmers_4_rout%ROWTYPE;

TYPE dept_tab_type IS TABLE OF g4_ROLLOUT_reftb%ROWTYPE;

TYPE dept_tab_type2 IS TABLE OF g4_rout_wards_mapping%ROWTYPE;

-----FARMERID,NIM,REGNUM,STATE,WARD,F_NAME,FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX,GENDERID,AGE,DOB,EDU,F_SIZE,LANG,LANGUAGEID,PHONE1,PHONE2,MSISDN,MSISDN2,VILLAGE_HEAD,VILLAGE_PHONE,CROP1,CROP2,LIVES1,LIVES2,FISH1,FISH2,F_TYPE,F_ID_TYP,F_IDENT,F_BANKC,F_BANK,F_GROUP,F_WARD,MAT_USED,GES,REASON,INF,IMG_DIR,FILNO,STATEID,LGAID,WARDID,SERIAL_NUMBER,PROCESSEDID,LASTROLLOUTID,NUMBEROFROLLOUTS,DATE_CREATED,DATEMODIFIED 

CURSOR c1 IS select * 
from g4_farmers f,G4_FARMERTYPES t 
where f.farmerid = t.farmerid
and t.processedid is null
and f.wardid = p_wardid 
and t.vcid   = p_VCID;
   


fmerids dept_tab_type;
fmerids2 dept_tab_type2;
rows PLS_INTEGER := 20;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids LIMIT rows;
/*
begin
SELECT 1 into f_exist 
from g4_farmers f,G4_FARMERTYPES t

where f.farmerid = t.farmerid
and t.processedid is null
and f.wardid = p_wardid 
and rownum < 2;
EXCEPTION

WHEN others THEN
    f_exist := 0;
    
END;



if f_exist < 1 then

update g3_rout_wards_mapping
set processedid = 1,
    datemodified = systimestamp
where wardid    = p_wardid
and   vcid      = p_VCID;



update G4_FARMERTYPES
----update farmers_4_rout
set processedid = 1,
  ----  lastrolloutid = p_ROLLOUTID,
    DATEMODIFIED = systimestamp
   ---- NUMBEROFROLLOUTS = (nvl(fmerids(i).NUMBEROFROLLOUTS,0) + 1)
where wardid = p_wardid
and   vcid   = p_VCID;


end if;
*/



begin
    select count(*) into r_completed 
    from g4_rout_wards_mapping m
    
where  m.rolloutid   = p_ROLLOUTID
and    m.processedid is null;
    
 EXCEPTION

WHEN others THEN
    r_completed := 0;
    
END;

if r_completed < 1 then

update g4_rollout
set rolloutstatus = 'COMPLETED',
    datemodified = systimestamp
where ROLLOUTID    = p_ROLLOUTID;

end if;


EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP

DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);


--commit;

--update G3_ROUT_WARDS_MAPPING
--set PROCESSEDID = 1
--where WARDID = fmerids(i).wardid;
--commit;
---Insert_2_fmer_rout(p_FARMERS_CON,fmerids(i).REDEMP_FARMERID,fmerids(i).MSISDN,fmerids(i).farmerid,fmerids(i).SERIALNUMBER,p_wardid,p_ROLLOUTID,p_ROLLOUTNAME,p_REDEMP_CENTER,p_ROLLOUTDATE,p_BUNDLEID,p_VCID,p_STATEID,p_LGAID,p_DEALERID,p_FIELDSTAFFID,p_ROLLOUTSTATUS,p_RES_TYPEID);


END LOOP;

update g3_rout_wards_mapping
set processedid = 1,
    datemodified = systimestamp
where wardid    = p_wardid
and   vcid      = p_VCID;



update G4_FARMERTYPES
----update farmers_4_rout
set processedid = 1,
  ----  lastrolloutid = p_ROLLOUTID,
    DATEMODIFIED = systimestamp
   ---- NUMBEROFROLLOUTS = (nvl(fmerids(i).NUMBEROFROLLOUTS,0) + 1)
where wardid = p_wardid
and   vcid   = p_VCID;

END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure FARMER_REGISTRATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FARMER_REGISTRATION" as

--FARMERID number;

f_STATEID number;
f_LGAID number;
f_WARDID number;
f_FULLNAME varchar2(500);
f_MSISDN number;
f_GENDER varchar2(11);
f_NewfarmerID VARCHAR2(10) ;
f_token VARCHAR2(8);

BEGIN
  FOR f IN
  (
 -- SELECT FARMERID,MSISDN  FROM g3_kano_ges_for_reg2   where  PROCESSEDID is null  and rownum <101
 select  FARMERS_REGISTRATIONID,FULLNAME,GENDER,TELNO1 as MSISDN,STATEID,LGAID,WARDID
from farmers_registration where  processed =0  and rownum <2
  )
  
  LOOP
  f_LGAID:=Verify_lga(f.stateID,f.lgaID);
  f_WARDID :=Verify_ward(f_LGAID,f.WARDID);
  f_MSISDN:=Verify_MSISDN(f.MSISDN);
  f_GENDER:=Verify_Gender(f.GENDER);


--if length(f_MSISDN) is null then
--  f_MSISDN:=NULL;
 --   end if;
  
 
        
    select TOKEN into f_token  from farmers_token_token  where PROCESSID is null and rownum < 2;
    update farmers_token_token set PROCESSID=1 where TOKEN=f_token;
    select FARMERID into f_NewfarmerID  from farmers_token_FID  where PROCESSID is null and rownum < 2;
    update farmers_token_FID set PROCESSID=1 where  FARMERID= f_NewfarmerID;
     
  --  insert into G3_FARMERS_KANO_TOKEN2 (F_TOKEN,NEW_FARMERID,MSISDN)
  --  values(f_token,f_NewfarmerID,f_MSISDN);
     
     insert into vc_art_farmers_2015_redemp(FULLNAME,STATEID,LGAID,WARDID,TELNO1,NEW_FARMERID,F_TOKEN,GENDER)
     values(f.fullname,f.STATEID,f_LGAID,f_WARDID,f_MSISDN,f_NewfarmerID,f_token,f_GENDER);
  
    update farmers_registration set PROCESSED=1 where  FARMERS_REGISTRATIONID= f.FARMERS_REGISTRATIONID;
     
   
  --dbms_output.put_line( 'NAPIFARMERSID : ' || f.NAPIFARMERSID || 'f_LGAID : ' || f_LGAID || 'f_WARDID : ' || f_WARDID || ' f_MSISDN: ' || F.MSISDN || ' f_GENDER: ' || f_GENDER );
   
  END LOOP;
commit;
END FARMER_REGISTRATION;

/
--------------------------------------------------------
--  DDL for Procedure FARMER_REGISTRATIONII
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FARMER_REGISTRATIONII" as

f_NewfarmerID VARCHAR2(10) ;
f_token VARCHAR2(8);

BEGIN
  FOR f IN
  (
 select  FARMERID,MSISDN from g3_kano_ges_for_reg2 where  PROCESSEDID is null   and rownum <201 
 )
  
  LOOP
     
    select FS_TOKEN into f_token  from G3_farmer_tokenII  where PROCESSEDID is null and rownum < 2;
    update G3_farmer_tokenII set PROCESSEDID=1 where FS_TOKEN=f_token;
    select F_ID_10CP into f_NewfarmerID  from g3_New_farmerIDII  where PROCESSEDID is null and rownum < 2;
    update g3_New_farmerIDII set PROCESSEDID=1 where  F_ID_10CP= f_NewfarmerID;
     
    insert into G3_FARMERS_ID_TOKEN (F_TOKEN,NEW_FARMERID,MSISDN,G3_FARMERID)
    values(f_token,f_NewfarmerID,f.MSISDN,f.FARMERID);
   
   update   g3_kano_ges_for_reg2 set PROCESSEDID=1 where FARMERID=f.FARMERID;
   
 -- dbms_output.put_line( 'f_token : ' || f_token || 'f_NewfarmerID : ' || f_NewfarmerID || 'f.MSISDN : ' || f.MSISDN || ' f.FARMERID: ' || f.FARMERID );
   
  END LOOP;
--commit;
END ;

/
--------------------------------------------------------
--  DDL for Procedure FARMER_REGISTRATIONIII
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FARMER_REGISTRATIONIII" as


TYPE farmer_rec is record (FARMERID g3_kano_ges_for_reg2.FARMERID%type,MSISDN g3_kano_ges_for_reg2.MSISDN%type);

my_farmer farmer_rec;

f_NewfarmerID VARCHAR2(10) ;
f_token VARCHAR2(8);

begin
 select  FARMERID,MSISDN  into my_farmer from g3_kano_ges_for_reg2 
 where  PROCESSEDID is null   and rownum <101 ;
 
     
  --  select FS_TOKEN into f_token  from G3_farmer_token  where PROCESSEDID is null and rownum < 2;
 --   update G3_farmer_token set PROCESSEDID=1 where FS_TOKEN=f_token;
 --   select F_ID_10CP into f_NewfarmerID  from g3_New_farmerID  where PROCESSEDID is null and rownum < 2;
   -- update g3_New_farmerID set PROCESSEDID=1 where  F_ID_10CP= f_NewfarmerID;
     
    --insert into G3_FARMERS_ID_TOKEN (F_TOKEN,NEW_FARMERID,MSISDN,G3_FARMERID)
    --values(f_token,f_NewfarmerID,f.MSISDN,f.FARMERID);
   
   --update   g3_kano_ges_for_reg2 set PROCESSEDID=1 where FARMERID=f.FARMERID;
   
 -- dbms_output.put_line( 'f_token : ' || f_token || 'f_NewfarmerID : ' || f_NewfarmerID || 'f.MSISDN : ' || f.MSISDN || ' f.FARMERID: ' || f.FARMERID );
   
 
--commit;
END ;

/
--------------------------------------------------------
--  DDL for Procedure FARMERS_CREDIT_CHECK_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FARMERS_CREDIT_CHECK_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number)
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
and  f.keyword = p_input_keyword
and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    s_input_sub := 0;
END;
dbms_output.put_line('The value of  s_input_sub :'|| s_input_sub);
begin
select s.amount into f_input_sub
from g3_subsidy_input_alloc s,g3_inputs i
where s.inputid = i.inputid
and s.escrow_acct_id =38
and i.keyword = p_input_keyword;
EXCEPTION
WHEN others THEN
    f_input_sub := 0;
END;
dbms_output.put_line('The value of  f_input_sub :'||f_input_sub);
s_f_total_sub := f_input_sub + s_input_sub;
dbms_output.put_line('The value of  s_f_total_sub :'||s_f_total_sub);
begin
select s_f_total_sub into f_s_input_sub from dual;
EXCEPTION
WHEN others THEN
    f_s_input_sub := 0;
END;
dbms_output.put_line('The value of  f_s_input_sub :'||f_s_input_sub);
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
 dbms_output.put_line('The value of  fmers_bal :'||fmers_bal);
 
    /** if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
    **/
    
  end;

/
--------------------------------------------------------
--  DDL for Procedure FARMERS_CREDIT_CHECK_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FARMERS_CREDIT_CHECK_TEST" (p_input_keyword in varchar2,p_sourceaddress in Number)

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
and  f.keyword = p_input_keyword
and  f.msisdn = p_sourceaddress;
EXCEPTION

WHEN others THEN
    s_input_sub := 0;
END;
dbms_output.put_line('The value of  s_input_sub :'|| s_input_sub);

begin
select s.amount into f_input_sub
from g3_subsidy_input_alloc s,g3_inputs i
where s.inputid = i.inputid
and s.escrow_acct_id =38
and i.keyword = p_input_keyword;

EXCEPTION
WHEN others THEN
    f_input_sub := 0;
END;
dbms_output.put_line('The value of  f_input_sub :'||f_input_sub);

s_f_total_sub := f_input_sub + s_input_sub;

dbms_output.put_line('The value of  s_f_total_sub :'||s_f_total_sub);

begin
select s_f_total_sub into f_s_input_sub from dual;
EXCEPTION
WHEN others THEN
    f_s_input_sub := 0;
END;

dbms_output.put_line('The value of  f_s_input_sub :'||f_s_input_sub);

begin
select bal into fmers_bal from farmers_account_bal;
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
 dbms_output.put_line('The value of  fmers_bal :'||fmers_bal);
 
    /** if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
          return 1;
                else
                  return 0;
                  ----  l_count := 0;
    end if;
    **/
    
  end;

/
--------------------------------------------------------
--  DDL for Procedure FARMERS_TOKEN_REQ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FARMERS_TOKEN_REQ" 
IS
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF G3_INBOUNDGESMESSAGES%ROWTYPE;
CURSOR c1 IS SELECT * FROM G3_INBOUNDGESMESSAGES 
where serviceid = 2 and processedid is null and rownum < 5;
 ---where rownum < 10 order by 1 desc;
fmerids dept_tab_type;
rows PLS_INTEGER := 9;
v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids;
 ----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
-- strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,replace(replace(replace(replace(fmerids(i).MESSAGECONTENT,'-',null),'_',null),'(',null),')',null),';., ');
  g3_vpos2015.Insert_fmer_req(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,regexp_replace(fmerids(i).MESSAGECONTENT, '[^[:digit:]]', null ) );

    -----REDEMP_START_TYPES.strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,TRANSLATE(fmerids(i).MESSAGECONTENT,'~-_()','~'), ';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
update G3_INBOUNDGESMESSAGES
     set processedid  = 1,
         serviceid    = 3,
       datemodified = systimestamp
     where inboundgesmessageid = fmerids(i).INBOUNDGESMESSAGEID;
END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure FMER_ACTN_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER_ACTN_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_farmerid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 ---select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
 ----------------------------------------------------------------------------------------
 select 'Dear '||farmer_name||' You are not activated for this value chain :'||f_vcname||'. Request :'||p_payload||'. Fmer id :'||f_serial_no into f_msgcont from dual;

              
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,status,serviceid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid ,7      ,1      );
  
insert into g3_transactions(REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,PHONENUMBER,VCID  ,remarks             ,payload   ,sourceaddress)
                       values(p_requestid,2     ,          1,p_farmerid  ,f_msisdn   ,p_vcid,'Fmer_Bundle_Failed',p_payload,p_sourceaddress);
   
   
            
 
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END fmer_actn_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure FMER_CEN_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER_CEN_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub   number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin

 begin
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where msisdn = p_sourceaddress;
 
 exception 
 when others then
 
 f_msisdn    := NULL;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_serial_no :=NULL;
    farmer_name := NULL;
    end;
 ----------------------------------------------------------------------------------------
 /*
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 
*/
 ----------------------------------------------------------------------------------------
 /*
    select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
*/
----------------------------------------------------------------------------------------
---- select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 ---dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 ---select inputname into f_inputname from g3_inputs where inputid = p_inputid;
begin
select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
exception
when others then
f_vcname    :=NULL;
end;

 ----------------------------------------------------------------------------------------
 
 select 'Dear '||farmer_name||' You are not in a redemption center for '||f_vcname||'Value chain. Request is: '||p_payload||'. Fmer id :'||f_serial_no into f_msgcont from dual;
 

----------------------------------------------------------------------------------------
 /*
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,11       ,p_requestid ,0);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,11       ,0);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2     ,       11,p_farmerid  ,p_dealerid,f_msisdn   ,0          ,p_vcid,'AGD_FS_Fmers_Fail_Center'    ,p_payload ,p_sourceaddress);
   
   
            
 else
 */
 --------No farmer sms----------------------
 dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,status,serviceid,rolloutid)
                              values(f_msgcont   ,f_msisdn        ,'GES'       ,p_request_total,p_requestid,7      ,32        , 0     );
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID   ,DEALERID  ,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(0       ,p_requestid,2       ,        32  ,  0       ,0          ,p_vcid,'Fmers_Fail_Center'         ,p_payload,p_sourceaddress);
   
   
         
 ---end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := NULL;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END fmer_cen_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure FMER_FAIL_CDIT_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER_FAIL_CDIT_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_inputid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2,p_c_bal in number)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 
 ----------------------------------------------------------------------------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 ----------------------------------------------------------------------------------------
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
select 'Dear '||farmer_name||' your Ewallet Sub.bal.is low for '||' 1Bag/vol : '||f_inputname||' Ewallet Bal.:N '||p_c_bal||'. Fmer id :'||f_serial_no||' R_id :'||p_rolloutid into f_msgcont from dual;
 ----------------------------------------------------------------------------------------
 
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'Ewallet Bal :N'||p_c_bal);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
                        
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,2        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID   ,remarks            ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,       2,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'Fmers_Fail_Credit',p_payload,p_sourceaddress);
   
   
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
END fmer_fail_cdit_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure FMER_INVALID_INPUT_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER_INVALID_INPUT_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_farmerid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_inputid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);
f_dealerid  number;

f_inputname varchar2(100);
f_serial_no varchar2(50);
f_vcname    varchar2(100);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin

select translate(upper(DEALERNAME),'~1234567890','~'),dealerid into dealer_name,f_dealerid
 from g3_agrodealers  
 where dealerid = p_dealerid;


-----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
  select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
  
---------------------------------------------------------------------------------------- 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
select 'Dear '||farmer_name||' You are not allow to redeem this :'||p_payload||' input.Value chain is:'||f_vcname||'. Fmer id :'||f_serial_no into f_msgcont from dual;
----------------------------------------------------------------------------------------
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,4       ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID    ,inputid   ,REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_inputid,p_requestid ,2       ,        4,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_FS_bundle_Fail'         ,p_payload,p_sourceaddress);
   
   
            
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
END fmer_invalid_input_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure FMER_REG_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER_REG_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_vcname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;

f_dealerid   number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
/*
    select translate(upper(DEALERNAME),'~1234567890','~'),dealerid into dealer_name,f_dealerid
 from g3_agrodealers  
 where phonenumber = p_sourceaddress;
 -----------------------------------------------------------------------------------------
 
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 
*/
 ----------------------------------------------------------------------------------------
 /*
    select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
*/
----------------------------------------------------------------------------------------
---- select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 ---dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 ---select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 begin
select vcname into f_vcname from g3_value_chain where vcid = p_vcid;
exception
when others then
f_vcname    :=NULL;
end;

 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 
 select 'Dear '||p_sourceaddress||' you are not a registered Farmer in the GES program. value chain : '||f_vcname||'. Payload: '||p_payload into f_msgcont from dual;
 
 
----------------------------------------------------------------------------------------
 /*
 if f_msisdn is not null then
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,p_sourceaddress,'GES'         ,p_request_total ,dealer_name ,7     ,11       ,p_requestid ,0);
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,11       ,0);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2     ,       11,p_farmerid  ,p_dealerid,f_msisdn   ,0          ,p_vcid,'AGD_FS_Fmers_Fail_Center'    ,p_payload ,p_sourceaddress);
   
   
            
 else
 */
 --------No farmer sms----------------------
 --dbms_output.put_line('No farmer sms');
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
 
 insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,status,serviceid,requestid   ,rolloutid)
                                values(f_msgcont   ,p_sourceaddress,'GES'         ,p_request_total  ,7     ,6        ,p_requestid ,0);
                          
 
----insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
----                              values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,22        ,p_rolloutid);
  
insert into g3_transactions(REQUESTID  ,STATUSID,SERVICEID   ,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                    values(p_requestid ,2       ,        6  ,0          ,p_vcid,'Fmer_Reg_Failed'   ,p_payload,p_sourceaddress);
   
   
         
 ---end if;
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := NULL;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
    f_vcname    :=NULL;
END fmer_reg_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure FMER_STOCK_FAIL_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER_STOCK_FAIL_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_inputid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers
 where farmerid = p_farmerid;
 ---------------------------------------------------------------------------------------
 select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 ----------------------------------------------------------------------------------------
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
select 'Dear '||farmer_name||' The agro dealer :'||dealer_name||' has no stock inventory for '||f_inputname||'. Fmer id :'||f_serial_no into f_msgcont from dual;
 ----------------------------------------------------------------------------------------
 
 --------insert farmer sms-------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn);
 
 dbms_output.put_line('agd_msg :'||agd_msgcont);
 
 dbms_output.put_line('fmer_msg :'||f_msgcont);
 
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7      ,3        ,p_rolloutid);
  
insert into g3_transactions(BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks          ,payload   ,sourceaddress)
                       values(p_bundleid,p_requestid,2       ,      3,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'AGD_Stock_Fail_',p_payload,p_sourceaddress);
   
   
            
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
END fmer_stock_fail_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure FMER_SUCCESSFUL_3_1_0
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER_SUCCESSFUL_3_1_0" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_farmerid in number,p_inputid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
dealer_phone number;
farmer_name varchar2(50);
agd_msgcont varchar2(300);
f_msgcont   varchar2(300);

f_inputname varchar2(100);
f_serial_no varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;



---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~'),phonenumber into dealer_name, dealer_phone
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid,concat(stateid||'-'||lgaid||'-('||serial_number,')') into farmer_name,f_msisdn,f_stateid,f_lgaid,f_serial_no
 from g3_farmers 
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||' fmer state sub :'||f_s_sub||' fmer_fed_sub :'||f_f_sub||' fed and state sub :'||f_f_s_sub||'Fmer serial No :'||f_serial_no);
 ----------------------------------------------------------------------------------------
 select inputname into f_inputname from g3_inputs where inputid = p_inputid;
 ----------------------------------------------------------------------------------------
 ---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you
 select 'Dear '||dealer_name||' pls give '||farmer_name||' 1Bag/vol of GES Approved size of : '||f_inputname||'. Fmer id :'||f_serial_no into agd_msgcont from dual;
 
 ---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
select 'Dear '||farmer_name||' pls collect '||' 1Bag/vol of GES Approved size of : '||f_inputname||' From '||dealer_name||'. Fmer id :'||f_serial_no into f_msgcont from dual; 
 ----------------------------------------------------------------------------------------
 
 
 
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT  ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL   ,AGD_NAME    ,status,serviceid,requestid   ,rolloutid)
                                values(agd_msgcont   ,dealer_phone    ,'GES'         ,p_request_total ,dealer_name ,7     ,1        ,p_requestid ,p_rolloutid); 
                          
 
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT ,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL  ,REQUESTID  ,AGD_NAME   ,status,serviceid,rolloutid)
                                values(f_msgcont   ,f_msisdn        ,'GES'    ,p_request_total,p_requestid,dealer_name,7     ,1        ,p_rolloutid);
  
insert into g3_transactions(DEBIT    ,BUNDLEID  ,REQUESTID  ,STATUSID,SERVICEID,INPUTID  ,FARMERID    ,DEALERID  ,PHONENUMBER,ROLLOUTID  ,VCID  ,remarks                      ,payload   ,sourceaddress)
                       values(f_f_s_sub,p_bundleid,p_requestid,1       ,        1,p_inputid,p_farmerid  ,p_dealerid,f_msisdn   ,p_rolloutid,p_vcid,'Fmers_Successful_tran',p_payload,p_sourceaddress);
   
   
insert into g3_stocklevel(INPUTID ,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID     ,REMARKS       ,requestid  ,serviceid)
                     values(p_inputid,p_dealerid  ,1           ,0       ,p_farmerid,'Farmer_Tran',p_requestid,        1);
  
  
  
insert into g3_account(DEBIT      ,credit ,FARMERID  ,F_MSISDN,DEALERID  ,D_MSISDN       ,ROLLOUTID  ,BUNDLEID   ,REMARKS      ,serviceid)
                  values(f_f_s_sub,      0,p_farmerid,f_msisdn,p_dealerid,dealer_phone,p_rolloutid,p_bundleid ,'Farmer_Tran',        1);
                 
 
 
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
    agd_msgcont := NULL;
    f_msgcont   := NULL;
    f_inputname := NULL;
    f_serial_no :=NULL;
END fmer_successful_3_1_0;

/
--------------------------------------------------------
--  DDL for Procedure FMER2STRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER2STRTOKEN" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,line IN varchar2, tokenChar IN varchar2 default ';')
    is
      TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
        index by binary_integer;
      --
      tokens    tokenTableType;
      vCnt      integer := 1;
      myLine    varchar2(4000) := null;
      vPos      integer := 1;
     --
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     
     if registration_check(SOURCEADDRESS) = 1 then
        if activation_check(SOURCEADDRESS) = 1 then
     dbms_output.put_line(SOURCEADDRESS);
     for vCnt in 1..tokens.count()
     loop
     if tokens(vCnt) = 'GES2' then
     CONTINUE;
     end if;
    ---------------------------------Check If Farmer is assign bundle--------------------------------
     if bundle_check(tokens(vCnt),SOURCEADDRESS) = 1 then
     
    ----------------------------------------Check AGD Stock Inventory--------------------------------
        if AGD_Stock_check(tokens(vCnt),SOURCEADDRESS) = 1 then
    ----------------------------------------Check Farmer's Credit Bal--------------------------------
        if farmers_credit_check(tokens(vCnt),SOURCEADDRESS) = 1 then
       dbms_output.put_line(vCnt||'  '||tokens(vCnt));
       continue;
       else
     dbms_output.put_line('Dear xxxx you do not have sufficent credit or you have redeemed this Input');
     continue;
     end if;
    ----------------------------------------Check Farmer's Credit Bal--------------------------------
       else
     dbms_output.put_line('Dear xxxx your AGD does not have enough stock for this transaction');
     continue;
     end if;
    ----------------------------------Check AGD Stock Inventory--------------------------------
       
       else
     dbms_output.put_line('Dear xxxx you are not assigned this bundle');
     continue;
     end if;
     ---------------------------------Check If Farmer is assign bundle--------------------------------
     
     end loop;
     else
     dbms_output.put_line('This phone number is not activated');
     
     end if;
     
     else
     dbms_output.put_line('This phone number is not a registered farmer');
     
     end if;
     
     
     --
   end;

/
--------------------------------------------------------
--  DDL for Procedure FMER3STRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER3STRTOKEN" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,line IN varchar2, tokenChar IN varchar2 default ';')
    is
      TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
        index by binary_integer;
      --
      tokens    tokenTableType;
      vCnt      integer := 1;
      myLine    varchar2(4000) := null;
      vPos      integer := 1;
     --
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     
     if registration_check(SOURCEADDRESS) = 1 then
     --dbms_output.put_line('Registration Pass :The Farmer with phone  :'||SOURCEADDRESS||' is Registered in GES');
    
      
        if activation_check(SOURCEADDRESS) = 1 then
     --dbms_output.put_line('Activation Pass :The Farmer with phone  :'||SOURCEADDRESS||' is Activated in GES Redemption');
    
     for vCnt in 1..tokens.count()
     loop
     if tokens(vCnt) = 'GES2' then
     CONTINUE;
     end if;
    ---------------------------------Check If Farmer is assign bundle--------------------------------
     if bundle_check(tokens(vCnt),SOURCEADDRESS) = 1 then
     --dbms_output.put_line('Bundle Pass :The Farmer with phone  :'||SOURCEADDRESS||' is Assigned this bundle in GES :'||tokens(vCnt));
    
    
    ----------------------------------------Check AGD Stock Inventory--------------------------------
        if AGD_Stock_check(tokens(vCnt),SOURCEADDRESS) = 1 then
      --  dbms_output.put_line('AGD Stock Pass :The Farmer with phone  :'||SOURCEADDRESS||' can redeem :'||tokens(vCnt));
    
      
    ----------------------------------------Check Farmer's Credit Bal--------------------------------
        if farmers_credit_check(tokens(vCnt),SOURCEADDRESS) = 1 then
       -- dbms_output.put_line('Fmer Credit Pass :The Farmer with phone  :'||SOURCEADDRESS||' has sufficient credit to redeem :'||tokens(vCnt));
    
         
       g3_fmer_tran_msg_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
       

     -- dbms_output.put_line('Dear xxxx your Transaction is successful  :'||tokens(vCnt));
      ---- dbms_output.put_line(vCnt||'  '||tokens(vCnt));
       else
       
       G3_FMER_TRAN_FAILED_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
       
      -- dbms_output.put_line('Fmer Credit fail :The Farmer with phone  :'||SOURCEADDRESS||' has no sufficient credit to redeem :'||tokens(vCnt));
    
     ---dbms_output.put_line('Dear xxxx you do not have sufficent credit or you have redeemed this Input :'||tokens(vCnt));
     continue;
     end if;
    ----------------------------------------Check Farmer's Credit Bal--------------------------------
       else
      g3_agd_stock_failed_proc(tokens(vCnt),SOURCEADDRESS,requestid,request_total);

      -- dbms_output.put_line('AGD Stock fail :The Farmer with phone  :'||SOURCEADDRESS||' cannot redeem :'||tokens(vCnt));
    
     --dbms_output.put_line('Dear xxxx your AGD does not have enough stock for this transaction');
     continue;
     end if;
    ----------------------------------End Check AGD Stock Inventory--------------------------------
      
       --dbms_output.put_line(vCnt||'  '||tokens(vCnt)||' '||requestid||' '||request_total);
       --continue;
       else
      G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
    -- dbms_output.put_line('Bundle fail :The Farmer with phone  :'||SOURCEADDRESS||' is not Assigned this bundle in GES :'||tokens(vCnt));
    
     continue;
     end if;
     ---------------------------------Check If Farmer is assign bundle--------------------------------
     
     end loop;
     else
         G3_FMER_ACTTION_FAILED_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
    -- dbms_output.put_line('This phone number is not activated');
     end if;
     
     else
         G3_FMER_REG_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
     --    dbms_output.put_line('This phone number is not a registered farmer');
     end if;
     
     
--commit;
     --
   end;

/
--------------------------------------------------------
--  DDL for Procedure FMER3STRTOKEN_3_1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMER3STRTOKEN_3_1" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,rToken IN varchar2, l_req_item varchar2,l_vcid number) IS
 
 fmerstr g3_Redemption_3_1_0.t_array;  
 
 l_req_item2       varchar2(30);
 l_req_item_n2     number;
 fmerid_reg         number;
 agdid_reg_did     number;

 fmer_agdid_cen     number;
 l_req_item_n       number;
 agdid_cen_fid      number;  
 fmer_act_bid       number;
 agd_f_act_rid      number;
 fmer_b_input_chk   number;
 agd_stock_bal      number;
 agd_fmer_cdit_bal  number;

 l_stateid         number;
 l_lgaid           number;
 l_full_sn         number;
 l_kword           varchar2(10);
 l_inputid         number;

BEGIN
    
     fmerstr         := g3_Redemption_3_1_0.split_3_1_0(rToken,' ');
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
     
if is_number(l_req_item) = 'N' then
    
     --l_req_item_n   := g3_Redemption_3_1_0.str2num_3_1_0(l_req_item);
    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
    
for i in 1..fmerstr.count
    loop
    
l_req_item2 := regexp_replace(fmerstr(i) ,'[[:space:]]*','');
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

if i = 1 then
    dbms_output.put_line('This is a Transaction type keyword '||fmerstr(i)||' PROCESSING ABORTED');
    continue;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

else
    dbms_output.put_line('This is not a Transaction type keyword '||fmerstr(i)||' check if is farmerid PROCESSING CONTINUE');     
  /*
   if l_req_item2 = l_req_item then
       dbms_output.put_line('This is a Farmer id : '||fmerstr(i)||'Not an Input. ABORTED');
    continue;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

else
    dbms_output.put_line('Processing can continue because this is not a farmer id but input '||fmerstr(i)||'Valid input pass! processing Inprogress');
*/
fmerid_reg      := g3_Redemption_3_1_0.g3_fmer_Reg_check_3_1(SOURCEADDRESS);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

if  fmerid_reg = 0 then
    
    dbms_output.put_line('The farmer is not available\Registered in GES for Processing :'||fmerstr(i)||' ABORTED! Farmer Registration Fail');
--agd_reg_3_1_0(SOURCEADDRESS,request_total,requestid,l_req_item_n,l_vcid,l_req_item2);   


    
continue;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

else
    
 dbms_output.put_line('The Farmer is Registered/ available for Processing :'||fmerstr(i)||' Farmer Registration pass! Continue Processing ');
 fmer_agdid_cen      := g3_Redemption_3_1_0.g3_fmer_cen_check_3_1(fmerid_reg,l_vcid);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

if fmer_agdid_cen  = 0 then
    
 dbms_output.put_line('The Farmer is not in any center for this value chain :'||fmerstr(i)||' ABORTED! Farmer center fail ');
dbms_output.put_line('The Farmer id is  fmerid_reg:'||fmerid_reg||' and Agrodealer id : '||fmer_agdid_cen||'value chain id '||l_vcid);
--agd_act_3_1_0(SOURCEADDRESS,request_total,requestid,agdid_reg,l_req_item_n,l_vcid,l_req_item2);    

continue;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

else
    fmer_act_bid  := g3_Redemption_3_1_0.g3_fmer_act_check_3_1(fmerid_reg,l_vcid);
   dbms_output.put_line('The farmer has a center for this value chain Farmer id :'||fmerid_reg||' RC  pass! vcid :'||l_vcid ||' Continue Processing ');

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

if fmer_act_bid = 0 then
    dbms_output.put_line('The Farmer is not activated for this value chain. value chain id :'||l_vcid||' ABORT! Activation  Fail ');

--agd_fmer_cen_3_1_0(SOURCEADDRESS,request_total,requestid,agdid_reg,l_req_item_n,agdid_act ,l_vcid,l_req_item2);    
    
continue;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

else
  dbms_output.put_line('The Farmer is activated value chain id :'||l_vcid||' Activation pass! bundle id : '||fmer_act_bid||' Continue Processing ');
/*
 agd_f_act_rid := g3_Redemption_3_1_0.g3_third_p_f_act_check_3_1 (agdid_cen_fid,agdid_act,l_vcid);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

if agd_f_act_rid = 0 then
 dbms_output.put_line('The Farmer IS NOT ACTIVATED for this Value chain. Farmer id :'||agdid_cen_fid||'value chain key :'|| l_vcid||' ABORT.Activation for the requested VC fail ');
--agd_fmer_actn_3_1_0(SOURCEADDRESS,request_total,requestid,agdid_reg,l_req_item_n,agdid_cen_fid,agdid_act ,agd_f_act_rid,l_vcid,l_req_item2);    

continue;    
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

else
 dbms_output.put_line('The Farmer IS ACTIVATED for this Value chain. Farmer id :'||agdid_cen_fid||'value chain key :'|| l_vcid||'Rollout id :'||agd_f_act_rid ||' Continue Processing');
*/
begin
select distinct inputid into l_inputid from g3_inputs where keyword = l_req_item2;
exception
    when others then
    l_inputid := 0;
end;
dbms_output.put_line('This is the inputid :'||l_inputid);
    
    
 fmer_b_input_chk := g3_Redemption_3_1_0.g3_fmer_b_input_check_3_1(fmer_act_bid,l_inputid);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

if fmer_b_input_chk = 0 then
    dbms_output.put_line('There is no such input in the Farmer bundle :'||fmerstr(i)||' Same as '||l_req_item2||' ABORT! Invalid Bundle input ');

--agd_invalid_input_3_1_0(SOURCEADDRESS,request_total,requestid,agdid_reg,l_req_item_n,agdid_cen_fid,agdid_act ,agd_f_act_rid,l_vcid,l_req_item2);    

dbms_output.put_line('Bundle id :'||fmer_act_bid||' No of request :'||request_total||' Request id :'||requestid||' Seria No :'||l_req_item ||' Dealer id'||fmerid_reg ||'Payload :'||l_req_item2||' ABORT! Invalid Bundle input ');

dbms_output.put_line('Farmer id :'||fmerid_reg||' Input id  :'||l_inputid||' bundle id :'||fmer_act_bid||' vc id :'||l_vcid ||' input id function'||fmer_b_input_chk||' ABORT! Invalid Bundle input ');

continue;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

else
    dbms_output.put_line('This input is in the Farmer bundle :'||fmerstr(i)||' Same as'||l_req_item2||'Bundle pass! Continue Processing');
agd_stock_bal := g3_Redemption_3_1_0.g3_fmers_stock_check_3_1(fmer_agdid_cen,l_inputid);
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

if agd_stock_bal <=0 then
    dbms_output.put_line('The Agrodealer input stock bal is insufficient the inventory bal is :'||agd_stock_bal||' The input is '||l_inputid||'Abort! Stock Inventory Fail');

--agd_stock_fail_3_1_0(SOURCEADDRESS,request_total,requestid,agdid_reg,l_req_item_n,agdid_cen_fid,l_inputid,agdid_act ,agd_f_act_rid,l_vcid,l_req_item2);    
continue;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
   
else
    dbms_output.put_line('The Agrodealer input stock bal is enough.The inventory bal is :'||agd_stock_bal||' The input is '||l_inputid||'Stock pass! Continue Processing');

   agd_fmer_cdit_bal := g3_Redemption_3_1_0.g3_third_p_acct_bal_3_1(agdid_cen_fid);  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

if agd_fmer_cdit_bal <= 0 then
    dbms_output.put_line('The Farmer has insufficient credit bal.Bal is :'||agd_fmer_cdit_bal||' The inputid is '||l_inputid||' Farmer id :'||agd_fmer_cdit_bal||'Abort Credit Fail');

  ---  agd_fail_cdit_3_1_0(SOURCEADDRESS,request_total,requestid,agdid_reg,l_req_item_n,agdid_cen_fid,l_inputid,agdid_act ,agd_f_act_rid,l_vcid,l_req_item2,agd_fmer_cdit_bal);    
continue;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
else
    dbms_output.put_line('The Farmer has sufficient credit bal.Bal is :'||agd_fmer_cdit_bal||' The input is '||l_inputid||' Farmer id :'||agdid_cen_fid||' Credit Pass Continue Processing');
     --agd_successful_3_1_0(SOURCEADDRESS,request_total,requestid,agdid_reg,l_req_item_n,agdid_cen_fid,l_inputid,agdid_act ,agd_f_act_rid,l_vcid,l_req_item2);    
    
    
end if;    
end if;
end if;
end if;
end if;    
end if;    
end if;    
--end if;
--end if;

--*/
   
end loop;

else
    
    agd_syntax_3_1_0(SOURCEADDRESS,request_total,requestid,l_req_item,l_vcid,rToken);   

   dbms_output.put_line('The Farmer Id is incorrect.Return Syntax error');
end if;
    
END fmer3strToken_3_1;

/
--------------------------------------------------------
--  DDL for Procedure FMERSTRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."FMERSTRTOKEN" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,line IN varchar2, tokenChar IN varchar2 default ' ')
    is
      TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
        index by binary_integer;
      --
      tokens    tokenTableType;
      vCnt      integer := 1;
      myLine    varchar2(4000) := null;
      vPos      integer := 1;
      v_total   number := 0;
      check_phonenumber   number;
     --
     begin
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     --select tokens.count() into v_total from dual;
      -----Total Count
     for vCnt in 1..tokens.count()
     loop
       v_total := v_total + 1;
     end loop;
     
      begin
    select msisdn into check_phonenumber from farmers_redemp;
    dbms_output.put_line('FMER'||'           '||'Input Name'||'        '||'No_Request'||'         '||'REQUEST ID');
     
        
     for vCnt in 1..tokens.count()
     loop
     
          
             
       dbms_output.put_line(vCnt||'                  '||tokens(vCnt)||'                 '||v_total||'                  '||requestid||'            '||SOURCEADDRESS);
     end loop;
     EXCEPTION
     
     
     
    WHEN Others THEN
    check_phonenumber := null;
    --raise_application_error (-20001,'Your Request Syntax is wrong.');
    --dbms_output.put_line('This Phone number does not exist');
    goto end_proc;
    end;      
     <<con_process>> 
     
     <<end_proc>>
     dbms_output.put_line('This Phone number does not exist');
     null;
   end;

/
--------------------------------------------------------
--  DDL for Procedure G3_AGD_STOCK_FAILED_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_AGD_STOCK_FAILED_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_name_bundle varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select f_name into fmer_name_bundle from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name_bundle := NULL;
END;
begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
  
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := NULL;
END;
begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := NULL;
END;
begin
        select concat(concat('Dear ',concat(concat(fmer_name_bundle,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := NULL;
END;
begin
    select concat(concat(concat(fmer_fullname,f_input_name),' : AGD HAS NO STOCK :'),agd_name) into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := NULL;
END;
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);
begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
and  upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID := NULL;
t_INPUTID  := NULL;
t_FARMERID := NULL;
t_DEALERID := NULL;
t_PHONENUMBER := NULL;
t_ROLLOUTID := NULL;
t_FIELDSTAFFID := NULL;
t_VCID := NULL;
END;
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,3,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_Stock_Failed',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_AGD_TRAN_BDLES_FAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_AGD_TRAN_BDLES_FAIL_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
    l_count number;
    
begin
begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;*/
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' Input Not Entitled :'),p_input_keyword),fmer_name),p_serial_number),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Input Not Entitled :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
                       
begin                      
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,10,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Fail_bundle',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
--commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_AGD_TRAN_CENTER_FAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_AGD_TRAN_CENTER_FAIL_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
    l_count number;
    
begin
begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;*/
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' Not In Your Center :'),f_input_name),fmer_name),p_serial_number),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Not In Your Center :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
                       
begin                      
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,11,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Fail_Center',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_AGD_TRAN_IVLID_REQ_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_AGD_TRAN_IVLID_REQ_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
    l_count number;
    
begin
    
    begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;*/
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and rownum = 1;
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and rownum = 1;
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' Format is GES3 U N M 1-1-2312 Invalid Syntax.:'),f_input_name),fmer_name),fmer_id),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') No/Low Credit for :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
                       
 begin                      
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and rownum = 1;
    
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,8,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Wrong_SyntaxFail',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
  --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_AGD_TRAN_MSG_FAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_AGD_TRAN_MSG_FAIL_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
    l_count number;
    
begin
begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;*/
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' No/Low Credit for :'),f_input_name),fmer_name),fmer_id),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') No/Low Credit for :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
                       
begin                       
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
    EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,8,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Fail_Credit',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_AGD_TRAN_MSG_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_AGD_TRAN_MSG_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
    l_count number;
    
begin
begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;*/
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
    
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual;
EXCEPTION
WHEN others THEN
    agd_details := null;    
END;

begin
select concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' Give Farmer :'),fmer_name),fmer_id),' :') into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := null;    
END;

begin
select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := null;    
END;

        
begin        
select concat(agd_details_full,f_input_name) into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := null;    
END;


insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
                       
begin                       
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 

insert into g3_transactions(DEBIT,BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(f_s_input_sub,t_BUNDLEID,p_requestid,1,7,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Successful_tran',p_input_keyword,p_sourceaddress);

insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);

insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
--  commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_AGD_TRAN_STOCK_FAIL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_AGD_TRAN_STOCK_FAIL_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number,p_serial_number in NUMBER)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
    l_count number;
    
begin
    

begin
select s.amount into s_input_sub from g3_subsidy_input_alloc s,fmers_map_bundle_input_agd_2 f
where s.inputid = f.inputid
and  s.escrow_acct_id = f.stateid
    and (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
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
/*
begin 
    select f_name into fmer_name from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;*/
begin 
    select concat(concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number),')'),f_name  into fmer_id,fmer_name 
    from fmers_map_bundle_input_agd_2 f 
    where (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd_2 f
    where i.inputid = f.inputid
     and  (f.SERIAL_NUMBER_full = p_serial_number
    or f.SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name 
    from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd_2 f
    where i.DEALERID = f.DEALERID
    and  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat(concat(concat(concat(concat(concat('Dear AGD: ',agd_name),' No Stock for :'),f_input_name),fmer_name),fmer_id),' :') into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') No/Low Credit for :') into fmer_fullname from dual;
        
        
select agd_details_full into msg_content from dual;
insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_name);
                       
begin                       
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd_2 f
where  (SERIAL_NUMBER_full = p_serial_number
    or SERIAL_NUMBER = p_serial_number)
    and (f.dealerid = (select dealerid from g3_agrodealers where phonenumber =p_sourceaddress) or f.fieldstaffid = (select fieldstaffid from g3_fieldstaff where phonenumber = p_sourceaddress) )
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
 
 
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,9,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'AGD_FS_Fmers_Fail_Stock',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'AGD_Fmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'AGD_Fmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_FARMERS_KANO_TOKEN_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_FARMERS_KANO_TOKEN_PROC" is
    
BEGIN
FOR Lc IN 1..30
loop
 
 MULTIPLE_CURSORS_PROC;
 end loop; 
END;

/
--------------------------------------------------------
--  DDL for Procedure G3_FMER_ACTIVATION_CHECK_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_FMER_ACTIVATION_CHECK_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_name_bundle varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select f_name into fmer_name_bundle from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name_bundle := NULL;
END;
begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
  
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := NULL;
END;
begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := NULL;
END;
begin
        select concat(concat('Dear ',concat(concat(fmer_name_bundle,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := NULL;
END;
begin
select concat(concat(fmer_fullname,p_input_keyword),' : NOT ENTITLED') into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := NULL;
END;
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);
begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
and  upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID := NULL;
t_INPUTID  := NULL;
t_FARMERID := NULL;
t_DEALERID := NULL;
t_PHONENUMBER := NULL;
t_ROLLOUTID := NULL;
t_FIELDSTAFFID := NULL;
t_VCID := NULL;
END;
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks)
                     values(t_BUNDLEID,p_requestid,12,1,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'Fmer_Bundle_Failed');
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
--commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_FMER_ACTTION_FAILED_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_FMER_ACTTION_FAILED_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_name_bundle varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select f_name into fmer_name_bundle from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name_bundle := NULL;
END;
begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
  
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := NULL;
END;
begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := NULL;
END;
begin
        select concat(concat('Dear ',concat(concat(fmer_name_bundle,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := NULL;
END;
begin
select concat(concat(fmer_fullname,p_input_keyword),' : NOT ACTIVATED') into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := NULL;
END;
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);
begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
and  upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID := NULL;
t_INPUTID  := NULL;
t_FARMERID := NULL;
t_DEALERID := NULL;
t_PHONENUMBER := NULL;
t_ROLLOUTID := NULL;
t_FIELDSTAFFID := NULL;
t_VCID := NULL;
END;
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,5,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'Fmer_Bundle_Failed',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
--  commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_FMER_BDLE_MSG_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_FMER_BDLE_MSG_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_name_bundle varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;


begin 
    select f_name into fmer_name_bundle from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name_bundle := NULL;
END;

begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;


begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;


begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;


begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
  

begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := NULL;
END;


begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := NULL;
END;


begin
        select concat(concat('Dear ',concat(concat(fmer_name_bundle,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := NULL;
END;
begin
select concat(concat(fmer_fullname,p_input_keyword),' : NOT ENTITLED') into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := NULL;
END;
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);
begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
and  upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID := NULL;
t_INPUTID  := NULL;
t_FARMERID := NULL;
t_DEALERID := NULL;
t_PHONENUMBER := NULL;
t_ROLLOUTID := NULL;
t_FIELDSTAFFID := NULL;
t_VCID := NULL;
END;


insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,4,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'Fmer_Bundle_Failed',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 -- commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_FMER_REG_MSG_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_FMER_REG_MSG_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_name_bundle varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;
    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;

/*
begin 
    select f_name into fmer_name_bundle from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_name_bundle := NULL;
END;
begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and msisdn in (select msisdn from g3_farmers) and ROWNUM = 1;
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;
  
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := NULL;
END;
begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := NULL;
END;

begin
        select concat(concat('Dear ',concat(concat(fmer_name_bundle,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := NULL;
END;
*/
begin
select concat(concat('Dear Farmer ',p_sourceaddress),' : NOT REGISTERED') into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := NULL;
END;
insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);
begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
and  upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID := NULL;
t_INPUTID  := NULL;
t_FARMERID := NULL;
t_DEALERID := NULL;
t_PHONENUMBER := NULL;
t_ROLLOUTID := NULL;
t_FIELDSTAFFID := NULL;
t_VCID := NULL;
END;
insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks,payload,sourceaddress)
                     values(t_BUNDLEID,p_requestid,2,6,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'Fmer_Reg_Failed',p_input_keyword,p_sourceaddress);
--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);
--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
  --commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_FMER_TRAN_FAILED_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_FMER_TRAN_FAILED_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    

    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;

    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;


begin
select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    fmers_bal := 0;
END;
 
begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := null;
END;

begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := null;
END;

begin
select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := null;
END;

begin
select concat(concat(concat(concat(concat(fmer_fullname,f_input_name),' Ewallet Bal :'),fmers_bal),' INSUFFICIENT for :'),s_f_total_sub) into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := null;
END;

insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);

begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
 and  upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;

insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID)
                     values(t_BUNDLEID,p_requestid,2,2,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID);

--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);

--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');

--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
--  commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_FMER_TRAN_MSG_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_FMER_TRAN_MSG_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
    t_VCID number;
    agd_details_msg varchar2(300);
    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;

begin
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
EXCEPTION
WHEN others THEN
    agd_details := NULL;
END;


begin
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
EXCEPTION
WHEN others THEN
    agd_details_full := NULL;
END;


begin
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
EXCEPTION
WHEN others THEN
    fmer_fullname := NULL;
END;



begin
    
    select concat(concat(concat(concat(concat(concat(concat('Dear ',agd_name),' Give '),fmer_name),'('),fmer_id),') '),f_input_name) into agd_details_msg from dual;

    
---select concat('Dear ',concat(concat(agd_name,' (Giver :'),agd_phone)) into agd_details_msg from dual;
EXCEPTION
WHEN others THEN
    agd_details_msg := NULL;
END;




begin
select concat(concat(fmer_fullname,f_input_name),' SUCCESSFUL') into msg_content from dual;
EXCEPTION
WHEN others THEN
    msg_content := NULL;
END;


insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);



insert into G3_OUTMESSAGES_BUFFER_agd(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(agd_details_msg   ,agd_phone,'GES',request_total,p_requestid,agd_details_full);






begin
select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
 and  upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    t_BUNDLEID  := null;
    t_INPUTID   := null;
    t_FARMERID  := null;
    t_DEALERID  := null;
    t_PHONENUMBER := null;
    t_ROLLOUTID      := null;
    t_FIELDSTAFFID   := null;
    t_VCID := null;    
END;
insert into g3_transactions(DEBIT,BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID,remarks)
                     values(f_s_input_sub,t_BUNDLEID,p_requestid,1,1,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID,'Fmers_Successful_tran');

insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,QUANTITY,FARMERID,REMARKS,requestid)
    values(t_INPUTID,t_DEALERID,1,0,t_FARMERID,'Farmer_Tran',p_requestid);

insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');
--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
 -- commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure G3_OUTMESSAGES_BUFFER_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_OUTMESSAGES_BUFFER_PROC" (
       p_MESSAGECONTENT           IN         g3_outmessages.MESSAGECONTENT%TYPE,
       p_DESTADDRESS              IN         g3_outmessages.DESTADDRESS%TYPE,
       p_SOURCEADDRESS            IN         g3_outmessages.SOURCEADDRESS%TYPE)
IS
BEGIN
 
  INSERT INTO g3_outmessages     (MESSAGECONTENT  ,DESTADDRESS  ,SOURCEADDRESS)
                          VALUES(p_MESSAGECONTENT,p_DESTADDRESS,p_SOURCEADDRESS);



 
END;

/
--------------------------------------------------------
--  DDL for Procedure G3_REG_TOKEN_FID10
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_REG_TOKEN_FID10" 
IS
/*
var_lvcid        g3_load_value_chain.lvcid%type;
var_vcid         g3_load_value_chain.vcid%type;
var_vc_tb        g3_load_value_chain.vc_tb%type;
*/
check_vc  number;
v_result number(30);
v_farmerid number;
v_token varchar2(20);
v_new_f_id varchar2(20);
begin
select farmerid into v_farmerid 
from g3_farmers 
where farmerid not in(select farmerid from g3_farmers_token)
and rownum < 2;
select fs_token into v_token 
from fs_token2
where processedid is null
and   fs_token not in(select f_token from g3_farmers_token)
    and rownum < 2;
select f_id_10cp into v_new_f_id 
from g3_farmers_10_id_cp 
where processedid is null
and f_id_10cp not in(select new_farmerid from g3_farmers_token)
    and rownum < 2;
insert into g3_farmers_token(f_token,farmerid,new_farmerid)
values(v_token,v_farmerid,v_new_f_id);
update fs_token2
set processedid = 1
where fs_token = v_token;
update g3_farmers_10_id_cp
set processedid = 1
where f_id_10cp = v_new_f_id;
commit;
END g3_reg_token_fid10;

/
--------------------------------------------------------
--  DDL for Procedure G3_REG_VALUE_CHAIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_REG_VALUE_CHAIN" 
IS

var_lvcid        g3_load_value_chain.lvcid%type;
var_vcid         g3_load_value_chain.vcid%type;
var_vc_tb        g3_load_value_chain.vc_tb%type;

check_vc  number;

v_result number(30);



--if check_vc > 0 then
---//declaring a cursor
CURSOR load_cursor IS select lvcid,vcid,vc_tb from g3_load_value_chain where processedid is null;





BEGIN
---/opening a cursor//
    
open load_cursor;

---if load_cursor = null then

LOOP
--//fetching records from a cursor//
fetch load_cursor into var_lvcid,var_vcid,var_vc_tb;
--//testing exit conditions//
EXIT when load_cursor%NOTFOUND;

insert_g3_farmers(var_lvcid,var_vcid,var_vc_tb);


END LOOP;
---end if;
--//closing the cursor//
close load_cursor;
--DBMS_OUTPUT.put_line('DONE');

--end if;

END g3_reg_value_chain;

/
--------------------------------------------------------
--  DDL for Procedure G3_REG_VALUE_CHAIN_2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_REG_VALUE_CHAIN_2" 
IS
-- TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE reg_vc_type IS TABLE OF g3_load_value_chain%ROWTYPE;
CURSOR c1 IS SELECT * FROM g3_load_value_chain where processedid is null and rownum < 81; -- ORDER BY DATECREATED ASC;
fmerids reg_vc_type;
--rows PLS_INTEGER := 10;
--v_results number;
query_str varchar2(3000);

v_processedid number;
desk_top NUMBER;

BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids;
    -----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;

FOR i IN 1..fmerids.COUNT LOOP


begin
     --sql_stm := 'select count(stateid) into'||v_processedid||'from'||p_vc_tb||'where rownum < 2 and processedid is null';
     
  -- EXECUTE IMMEDIATE 'select count(stateid) from '||p_vc_tb||' where processedid is null' into v_processedid;
    

EXECUTE IMMEDIATE 'Select 1 into'||v_processedid||' from dual where exists (select 1 
                   from all_tab_columns 
                  where lower(table_name) = '||fmerids(i).VC_TB||' 
                    and lower(column_name) = processedid)';

   exception
   when others then
   v_processedid := 0;
   end;

if v_processedid = 0 then
begin
EXECUTE IMMEDIATE 'alter table '||fmerids(i).VC_TB||' add processedid number';

exception
when others then
--dbms_output.put_line('invalid table');
desk_top := 0;
    end;
    
    --query_str := 'CURSOR c1 IS SELECT * from ' || fmerids(i).VC_TB || ' WHERE processedid is null and rownum < 51';
    
    
    insert_g3_farmers_2(fmerids(i).LVCID,fmerids(i).VCID,fmerids(i).VC_TB);

else

insert_g3_farmers_2(fmerids(i).LVCID,fmerids(i).VCID,fmerids(i).VC_TB);

end if;    

END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure G3_SSUB_EACCT_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_SSUB_EACCT_PROC" (
       p_HOLDER            IN         G3_Statutory_sub_alloc.HOLDER%TYPE,
       p_AMOUNT            IN         G3_Statutory_sub_alloc.AMOUNT%TYPE,
       p_TRAN_REMARKS      IN         G3_Statutory_sub_alloc.TRAN_REMARKS%TYPE,
       p_GES_YEAR          IN         G3_Statutory_sub_alloc.GES_YEAR%TYPE,
       p_SSAID             IN         G3_Statutory_sub_alloc.SSAID%TYPE)
IS
BEGIN
 
  INSERT INTO G3_ESCROW_ACCOUNTS (ESCROW_ACCT_ID  ,CREDIT  ,TRAN_REMARKS  ,GES_YEAR,ssaid )
                          VALUES(p_HOLDER ,p_AMOUNT,p_TRAN_REMARKS,p_GES_YEAR, p_SSAID );
--commit;

END;

/
--------------------------------------------------------
--  DDL for Procedure G3_STOCKLEVEL_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_STOCKLEVEL_PROC" (
       p_INPUTID           IN         g3_stocklevel.INPUTID%TYPE,
       p_AGRODEALERID      IN         g3_stocklevel.AGRODEALERID%TYPE,
       p_INPUTALLOCATIONID IN         g3_stocklevel.INPUTALLOCATIONID%TYPE,
       p_QUANTITY          IN         g3_stocklevel.QUANTITY%TYPE,
       p_QTY_DECREASE      IN         g3_stocklevel.QTY_DECREASE%TYPE)
IS
BEGIN
 
  INSERT INTO g3_stocklevel     (INPUTID  ,AGRODEALERID  ,INPUTALLOCATIONID  ,QUANTITY  ,QTY_DECREASE,DATE_CREATED,DATE_MODIFIED)
                          VALUES(p_INPUTID,p_AGRODEALERID,p_INPUTALLOCATIONID,p_QUANTITY,p_QTY_DECREASE,systimestamp,systimestamp);



 
END;

/
--------------------------------------------------------
--  DDL for Procedure G3_TOKEN_NEW_FID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_TOKEN_NEW_FID" (p_old_FARMERID in number,p_old_MSISDN in number,p_token in varchar2)
is 

BEGIN
  
    
    FOR rec_cx IN (SELECT f_id_10cp,processedid 
       FROM g3_farmers_10_id_cp where processedid is null or processedid < 2 and rownum < 2)
    LOOP
      
      
      insert into G3_FARMERS_KANO_TOKEN(F_TOKEN         ,FARMERID       ,MSISDN       ,NEW_FARMERID)
                            values(p_token              ,p_old_FARMERID,p_old_MSISDN  ,rec_cx.f_id_10cp);
    END LOOP;
    
    update g3_farmers_10_id_cp 
  set processedid = 2
  where f_id_10cp = rec_cx.f_id_10cp;
    
    update g3_kano_ges_for_reg 
    set processedid = 2
    where FARMERID = p_old_FARMERID;
    
    
    update fs_token2 
      set processedid = 2
      where fs_token = p_token;
    
END;

/
--------------------------------------------------------
--  DDL for Procedure G3_TOKEN_NEW_FID_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_TOKEN_NEW_FID_PROC" (p_old_FARMERID in number,p_old_MSISDN in number,p_token in varchar2)
is 

BEGIN
  
    
    FOR rec_cx IN (SELECT f_id_10cp,processedid 
       FROM g3_farmers_10_id_cp where processedid is null or processedid < 2 and rownum < 2)
    LOOP
      
      
      insert into G3_FARMERS_KANO_TOKEN(F_TOKEN         ,FARMERID       ,MSISDN       ,NEW_FARMERID)
                            values(p_token              ,p_old_FARMERID,p_old_MSISDN  ,rec_cx.f_id_10cp);
                            
  update g3_farmers_10_id_cp 
  set processedid = 2
  where f_id_10cp = rec_cx.f_id_10cp;
    END LOOP;
    
    
    
    update g3_kano_ges_for_reg 
    set processedid = 2
    where FARMERID = p_old_FARMERID;
    
    
    update fs_token2 
      set processedid = 2
      where fs_token = p_token;
    
END;

/
--------------------------------------------------------
--  DDL for Procedure G3_TOKEN_OLD_FID
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_TOKEN_OLD_FID" is
BEGIN
  FOR rec_c1 IN (select fs_token from fs_token2 where processedid is null and rownum < 2)
  LOOP
    dbms_Output.Put_Line(rec_c1.fs_token);
    
    FOR rec_c2 IN (SELECT FARMERID,MSISDN
       FROM g3_kano_ges_for_reg where  processedid is null and rownum < 2)
    LOOP
      dbms_Output.Put_Line(rec_c2.FARMERID||rec_c1.fs_token);
    END LOOP;
    
    dbms_Output.Put_Line('---------------');
  END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure G3_TOKEN_OLD_FID_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G3_TOKEN_OLD_FID_PROC" is
BEGIN
  FOR rec_c1 IN (select fs_token from fs_token2 where processedid is null and rownum < 2)
  LOOP
  ----  dbms_Output.Put_Line(rec_c1.fs_token);
    
    FOR rec_c2 IN (SELECT FARMERID,MSISDN
       FROM g3_kano_ges_for_reg where  processedid is null and rownum < 2)
    LOOP
     ---- dbms_Output.Put_Line(rec_c2.FARMERID||rec_c1.fs_token);
      
      g3_token_new_fid_proc(rec_c2.FARMERID,rec_c2.MSISDN,rec_c1.fs_token);
    END LOOP;
    
   -------- dbms_Output.Put_Line('---------------');
  END LOOP;
END;

/
--------------------------------------------------------
--  DDL for Procedure G4_INSERT_2_FMER_ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_INSERT_2_FMER_ROUT" (p_ges_year PLS_INTEGER,p_FARMERS_CON PLS_INTEGER,p_REDEMP_FARMERID varchar2,p_MSISDN PLS_INTEGER,p_farmerid PLS_INTEGER,p_serial_number PLS_INTEGER,p_wardid PLS_INTEGER,p_ROLLOUTID PLS_INTEGER,p_ROLLOUTNAME varchar2,p_REDEMP_CENTER varchar2,p_ROLLOUTDATE timestamp,p_BUNDLEID PLS_INTEGER,p_VCID PLS_INTEGER,p_STATEID PLS_INTEGER,p_LGAID PLS_INTEGER,p_DEALERID PLS_INTEGER,p_FIELDSTAFFID PLS_INTEGER,p_ROLLOUTSTATUS varchar2,p_RES_TYPEID PLS_INTEGER )
is

    PRAGMA AUTONOMOUS_TRANSACTION;

v_result PLS_INTEGER;
msg_response PLS_INTEGER;
v_bundle_total PLS_INTEGER;


v_first_msg varchar2(500);
v_second_msg varchar2(500);
v_third_msg varchar2(500);

v_first_msg_sent varchar2(500);
v_second_msg_sent varchar2(500);
v_third_msg_sent varchar2(500);

x_bundle_sub PLS_INTEGER;
stmt_name varchar2(3000) ;

begin
   
 stmt_name := '1.select g4_farmer_bundle_sub(p_STATEID,p_BUNDLEID) into x_bundle_sub from dual ';

 select g4_farmer_bundle_sub(p_STATEID,p_BUNDLEID,p_ges_year,p_vcid) into x_bundle_sub from dual;
 

stmt_name := '2.insert into g4_farmers_rollout ';

insert into g4_farmers_rollout(farmerid,rolloutid,bundleid,vcid,rolloutdate)
                        values(p_farmerid,p_ROLLOUTID,p_BUNDLEID,p_VCID,p_ROLLOUTDATE);
                        --commit;
                  
                          
            -------if length(nvl(p_MSISDN,0)) = 13 then
                
                stmt_name := '3.g4_response_rout (p_FARMERS_CON ,p_MSISDN,p_farmerid ';
                
               

                g4_response_rout (p_FARMERS_CON ,p_REDEMP_FARMERID,p_MSISDN,p_farmerid,p_serial_number ,p_wardid ,p_ROLLOUTID ,p_ROLLOUTNAME,p_REDEMP_CENTER,p_ROLLOUTDATE,p_BUNDLEID,p_VCID,p_STATEID,p_LGAID,p_DEALERID,p_FIELDSTAFFID,p_ROLLOUTSTATUS,p_RES_TYPEID,x_bundle_sub );

             
           ------- end if;
        
 exception
    when others then
    g4_write_log( SQLCODE,SQLERRM,stmt_name);
    ROLLBACK;
    RAISE; 
END;

/
--------------------------------------------------------
--  DDL for Procedure G4_REG_DETAILS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_REG_DETAILS_PROC" (var_lvcid       number,var_vcid         Number,var_vc_tb        varchar2) 
    
    
    IS
    PRAGMA AUTONOMOUS_TRANSACTION;

 TYPE cur_typ IS REF CURSOR;
 ROUT_CURSOR cur_typ;


var_WARDID             TEMP_ABIA.WARDID%type;


    

stmt_name varchar2(3000) := '1.SELECT wardid from var_vc_tb WHERE (processed < 1 or processed is null) and rownum < 2' ;


query_str varchar2(4000) ;


--query_str 
    

    
BEGIN
 
   
   

    EXECUTE IMMEDIATE 'alter table '||var_vc_tb||' PARTITION BY HASH(wardid) PARTITIONS 5'; 
    EXECUTE IMMEDIATE 'alter table '||var_vc_tb||' PARALLEL 5';
    EXECUTE IMMEDIATE 'alter table '||var_vc_tb||' PARALLEL ( DEGREE 5 )';

     query_str := 'SELECT /*+ parallel(s,5) */ wardid from '||var_vc_tb||' s WHERE (processed < 1 or processed is null) and rownum < 2';

  
---/opening a cursor//
open ROUT_CURSOR for query_str ;
LOOP
--//fetching records from a cursor//
stmt_name := '2.fetch ROUT_CURSOR  into var_WARDID';
fetch ROUT_CURSOR  into var_WARDID;
--//testing exit conditions//



EXIT when ROUT_CURSOR%NOTFOUND;

stmt_name := '3.g4_Registration (var_WARDID,var_lvcid,var_vcid,var_vc_tb )';

g4_Registration (var_WARDID,var_lvcid,var_vcid,var_vc_tb );
    
END LOOP;
--//closing the cursor//
close ROUT_CURSOR;

stmt_name := '4.update g3_load_value_chain set processedid = 1 where vc_tb = var_vc_tb';

update g3_load_value_chain
    set processedid = 1
    where vc_tb = var_vc_tb;
commit;

--DBMS_OUTPUT.put_line('DONE');
exception
    when others then
    g4_write_log( SQLCODE,SQLERRM,stmt_name);
    ROLLBACK;
    RAISE;
END;

/
--------------------------------------------------------
--  DDL for Procedure G4_REG_VALUE_CHAIN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_REG_VALUE_CHAIN" 
IS
---PRAGMA AUTONOMOUS_TRANSACTION;
var_lvcid        g3_load_value_chain.lvcid%type;
var_vcid         g3_load_value_chain.vcid%type;
var_vc_tb        g3_load_value_chain.vc_tb%type;
check_vc  number;
v_result number(30);
stmt_name varchar2(3000) := '1.CURSOR load_cursor IS select lvcid,vcid,vc_tb from g3_load_value_chain where processedid is null and rownum < 2' ;
--if check_vc > 0 then
---//declaring a cursor
CURSOR load_cursor IS select lvcid,vcid,vc_tb from g3_load_value_chain where processedid is null and rownum < 2;
BEGIN
---/opening a cursor//
    
open load_cursor;
---if load_cursor = null then
LOOP
--//fetching records from a cursor//
stmt_name := '2.fetch load_cursor into var_lvcid,var_vcid,var_vc_tb' ;
fetch load_cursor into var_lvcid,var_vcid,var_vc_tb;
--//testing exit conditions//
EXIT when load_cursor%NOTFOUND;

if var_vcid = 1 then
stmt_name := '3.g4_reg_value_chain:G4_REGISTRATION_4_0_0.g4_Reg_details_proc(var_lvcid,var_vcid,var_vc_tb)' ;
G4_REGISTRATION_4_0_0.g4_Reg_details_proc(var_lvcid,var_vcid,var_vc_tb);
stmt_name := '4.update  g3_load_value_chain' ;
 
 else
 
 G4_VC_REGISTRATION_4_0_0.g4_Reg_details_proc(var_lvcid,var_vcid,var_vc_tb);
 
 end if;
 

END LOOP;
commit;
--//closing the cursor//
close load_cursor;
exception
    when others then
    g4_write_log( SQLCODE,SQLERRM,stmt_name);
    ROLLBACK;
    ---RAISE;
END g4_reg_value_chain;

/
--------------------------------------------------------
--  DDL for Procedure G4_REGISTRATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_REGISTRATION" ( p_WARDID number,var_lvcid       number,var_vcid         Number,var_vc_tb        varchar2 )
IS
PRAGMA AUTONOMOUS_TRANSACTION;

  TYPE cursor_ref IS REF CURSOR;
  c1 cursor_ref;
 
  TYPE fmer_tab IS TABLE OF TEMP_ABIA%ROWTYPE;
  rec_fmer_tab fmer_tab;
  rows_fetched NUMBER;
  
  sql_stmt VARCHAR2(2000);

  r_rout_wards number;
  R_COMPLETED number;

stmt_name varchar2(3000);

l_FARMERID number;
l_STATEID  number;
l_FARMERTYPEID number;
BEGIN

    stmt_name  := '1.sql_stmt := select * from var_vc_tb WHERE processed <> 1 and wardid = :j' ;

    sql_stmt := 'select /*+ parallel(s,5) */ * from '||var_vc_tb||' s where processed <> 1 and wardid = :j';

OPEN c1 FOR sql_stmt USING p_WARDID;

 ----- OPEN c1 FOR 'select FARMERID,STATEID,LGAID,WARDID,SERIAL_NUMBER,PROCESSEDID,LASTROLLOUTID,NUMBEROFROLLOUTS from g3_farmers WHERE wardid = p_wardid';
  FETCH c1 BULK COLLECT INTO rec_fmer_tab;
  rows_fetched := c1%ROWCOUNT;  ------use this to determine number of farmers rollout per ward and rollout or rc
  
  if rows_fetched = 0 then
  EXECUTE IMMEDIATE 'update '||var_vc_tb||'set processed  = 1,datemodified = systimestamp where wardid   ='|| p_wardid;
 
 else
 stmt_name  := '2.for i in rec_fmer_tab.first .. rec_fmer_tab.last' ;

  for i in rec_fmer_tab.first .. rec_fmer_tab.last
  loop
  
 --- g4_Insert_2_fmer_rout(p_FARMERS_CON,rec_fmer_tab(i).MSISDN,rec_fmer_tab(i).farmerid,rec_fmer_tab(i).SERIAL_NUMBER,p_wardid,p_ROLLOUTID,p_ROLLOUTNAME,p_REDEMP_CENTER,p_ROLLOUTDATE,p_BUNDLEID,p_VCID,p_STATEID,p_LGAID,p_DEALERID,p_FIELDSTAFFID,p_ROLLOUTSTATUS,p_RES_TYPEID);
select G4_FARMERS_SEQ.nextval into l_FARMERID from dual;
select G4_FARMERTYPES_SEQ.nextval into l_FARMERTYPEID from dual;

select stateid into l_STATEID from g4_lga where lgaid = rec_fmer_tab(i).LGAID ;

INSERT INTO /*+ parallel(s,5) */ G4_FARMERS s (    FARMERID ,STATEID, LGAID               , WARDID               , LANGUAGEID               , SALUTATION               , FIRSTNAME                                                        , SECONDNAME                                                       , THIRDNAME                                                       , FOURTHNAME                                                      , SPOUSENAME                                                        , DOB               ,     GENDERID               , FARMSIZE                , ADDRESS                , MSISDN                  , SECONDARYMSISDN               , FARMERID22             , SERIALNUMBER               , CROPTYPE               , STATCODE               , NUMBEROFROLLOUTS               , LASTROLLOUTID               , PROCESSED              , NUMBEROFSENDS                , BUCKETID                    , ACTIVE               , OLDFARMERID                 )
                 VALUES(l_FARMERID ,l_STATEID,rec_fmer_tab(i).LGAID,rec_fmer_tab(i).WARDID,rec_fmer_tab(i).LANGUAGEID,rec_fmer_tab(i).SALUTATION,replace(replace(rec_fmer_tab(i).FIRSTNAME,'null',''),'(null)','') ,replace(replace(rec_fmer_tab(i).SECONDNAME,'null',''),'(null)',''),replace(replace(rec_fmer_tab(i).THIRDNAME,'null',''),'(null)',''),replace(replace(rec_fmer_tab(i).FOURTHNAME,'null',''),'(null)',''),replace(replace(rec_fmer_tab(i).SPOUSENAME,'null',''),'(null)',''),rec_fmer_tab(i).DOB,rec_fmer_tab(i).GENDERID  ,rec_fmer_tab(i).FARMSIZE ,rec_fmer_tab(i).ADDRESS ,rec_fmer_tab(i).MSISDN   ,rec_fmer_tab(i).SECONDARYMSISDN,rec_fmer_tab(i).FARMERID,rec_fmer_tab(i).SERIALNUMBER,rec_fmer_tab(i).CROPTYPE,rec_fmer_tab(i).STATCODE,rec_fmer_tab(i).NUMBEROFROLLOUTS,rec_fmer_tab(i).LASTROLLOUTID,rec_fmer_tab(i).PROCESSED,rec_fmer_tab(i).NUMBEROFSENDS,rec_fmer_tab(i).BUCKETID     ,rec_fmer_tab(i).ACTIVE,rec_fmer_tab(i).OLDFARMERID);
 
 INSERT INTO /*+ parallel(s,5) */ G4_FARMERTYPES s (    FARMERID , VCID , GESYEAR                    , REDEMP_FARMERID            , REDEMP_TOKEN)
                      VALUES(l_FARMERID, var_vcid  ,TO_CHAR(SYSDATE,'YYYY'),g4_unique_farmerid(var_vcid),g4_unique_token(var_vcid)  );
   EXIT WHEN rec_fmer_tab.COUNT = 0;
  end loop;
  
  end if;
  CLOSE c1;


stmt_name  := '3.update var_vc_tb set processed  = 1,datemodified = systimestamp where wardid   = p_wardid' ;

EXECUTE IMMEDIATE 'update '||var_vc_tb||'set processed  = 1,datemodified = systimestamp where wardid   ='|| p_wardid;






commit;

exception
    when others then
    g4_write_log( SQLCODE,SQLERRM,stmt_name);
    ROLLBACK;
    RAISE;
END;

/
--------------------------------------------------------
--  DDL for Procedure G4_RESPONSE_ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_RESPONSE_ROUT" (p_FARMERS_CON PLS_INTEGER,REDEMP_FARMERID varchar2,p_MSISDN PLS_INTEGER,p_farmerid PLS_INTEGER,p_serial_number PLS_INTEGER,p_wardid PLS_INTEGER,p_ROLLOUTID PLS_INTEGER,p_ROLLOUTNAME varchar2,p_REDEMP_CENTER varchar2,p_ROLLOUTDATE timestamp,p_BUNDLEID PLS_INTEGER,p_VCID PLS_INTEGER,p_STATEID PLS_INTEGER,p_LGAID PLS_INTEGER,p_DEALERID PLS_INTEGER,p_FIELDSTAFFID PLS_INTEGER,p_ROLLOUTSTATUS varchar2,p_RES_TYPEID PLS_INTEGER,x_bundle_sub PLS_INTEGER )
is 
PRAGMA AUTONOMOUS_TRANSACTION;

TYPE cursor_ref IS REF CURSOR;
  c1 cursor_ref;
  TYPE fmer_msg_tab IS TABLE OF g4_RESPONSES%ROWTYPE;
  msg_fmer_tab fmer_msg_tab;
  rows_fetched NUMBER;
  
  sql_stmt VARCHAR2(2000);


x_inputid   number;
   x_amount  number;
   x_qty  number;
   x_esc  number;
  ----- x_bundle_sub number := 0; 

stmt_name varchar2(3000) ;

BEGIN
    
     
    
    
stmt_name := '2.select * from g4_RESPONSES WHERE res_typeid '; 

  
sql_stmt := 'select * from g4_RESPONSES WHERE res_typeid = :j';

OPEN c1 FOR sql_stmt USING p_RES_TYPEID;

  FETCH c1 BULK COLLECT INTO  msg_fmer_tab;
 -- rows_fetched := c1%ROWCOUNT;
  
  
 
  for i in msg_fmer_tab.first .. msg_fmer_tab.last 
  loop
  
  stmt_name := '3.msg_fmer_tab(i).MSG_SEQ = 1 then '; 

 if msg_fmer_tab(i).MSG_SEQ = 1 then
      
  insert into g4_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(msg_fmer_tab(i).RESMSG||' '||REDEMP_FARMERID||' Ewallet Bal :'||x_bundle_sub,p_MSISDN,7,7,1,'GES',p_ROLLOUTID); 
  elsif msg_fmer_tab(i).MSG_SEQ = 2 then
  
   insert into g4_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(msg_fmer_tab(i).RESMSG,p_MSISDN,7,7,1,'GES',p_ROLLOUTID); 
     
   elsif msg_fmer_tab(i).MSG_SEQ = 3 then  
    insert into g4_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(replace(replace(replace(replace(msg_fmer_tab(i).RESMSG,'amount_value',p_FARMERS_CON),'amount_total1',p_FARMERS_CON + 200),'amount_total2',p_FARMERS_CON + 310),'redemption_center',p_REDEMP_CENTER),p_MSISDN,7,7,1,'GES',p_ROLLOUTID); 

                              
  else
    insert into g4_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(msg_fmer_tab(i).RESMSG,p_MSISDN,7,7,1,'GES',p_ROLLOUTID); 
   
     end if;
 
              
              
              
                              
              
   EXIT WHEN msg_fmer_tab.COUNT = 0;
 end loop;


CLOSE c1;

             stmt_name := '4.msg_fmer_tab(i).MSG_SEQ = 1 then ';

                        
                        g4_update_account_rout (p_VCID,p_farmerid,p_ROLLOUTID,p_BUNDLEID,p_DEALERID,x_bundle_sub);
     
  exception
    when others then
    g4_write_log( SQLCODE,SQLERRM,stmt_name);
    ROLLBACK;
    RAISE;                                
END;

/
--------------------------------------------------------
--  DDL for Procedure G4_ROUT_DETAILS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_ROUT_DETAILS_PROC" IS

----var_ROLLOUTID        start_rout.ROLLOUTID%type;

var_GES_YEAR         g4START_ROUT.GES_YEAR%type;
var_ROLLOUTID        g4START_ROUT.ROLLOUTID%type;
var_ROLLOUTNAME      g4START_ROUT.ROLLOUTNAME%type;
var_REDEMP_CENTER    g4START_ROUT.REDEMP_CENTER%type;
var_ROLLOUTDATE      g4START_ROUT.ROLLOUTDATE%type;

var_BUNDLEID         g4START_ROUT.BUNDLEID%type;
var_VCID             g4START_ROUT.VCID%type;
var_STATEID          g4START_ROUT.STATEID%type;
var_LGAID            g4START_ROUT.LGAID%type;

var_DEALERID         g4START_ROUT.DEALERID%type;
var_FIELDSTAFFID     g4START_ROUT.FIELDSTAFFID%type;
var_ROLLOUTSTATUS    g4START_ROUT.ROLLOUTSTATUS%type;
var_WARDID           g4START_ROUT.WARDID%type;
var_FARMERS_CON      g4START_ROUT.FARMERS_CON%type; 
var_RES_TYPEID       g4START_ROUT.RES_TYPEID%type;

v_result number(30);

 

---//declaring a cursor
---CURSOR ROUT_CURSOR IS select FARMERS_CON,ROLLOUTID,ROLLOUTNAME,REDEMP_CENTER,ROLLOUTDATE,BUNDLEID,VCID,STATEID,LGAID,DEALERID,FIELDSTAFFID,ROLLOUTSTATUS,WARDID,RES_TYPEID from start_rout;

CURSOR ROUT_CURSOR IS select r.GES_YEAR,r.FARMERS_CON,r.ROLLOUTID,r.ROLLOUTNAME,r.REDEMP_CENTER,r.ROLLOUTDATE,r.BUNDLEID,r.VCID,r.STATEID,r.LGAID,r.DEALERID,r.FIELDSTAFFID,r.ROLLOUTSTATUS,m.WARDID,r.RES_TYPEID
from G4_ROUT_WARDS_MAPPING m,G4_ROLLOUT  r
where r.ROLLOUTID = m.ROLLOUTID 
and    m.processedid is null
and   r.ROLLOUTDATE < systimestamp
and    rownum < 10;


--EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN
---/opening a cursor//
open ROUT_CURSOR;
LOOP
--//fetching records from a cursor//
fetch ROUT_CURSOR into var_GES_YEAR,var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID;
--//testing exit conditions//
EXIT when ROUT_CURSOR%NOTFOUND;

--Update_fmer_4rout (var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID);

g4_Update_fmer_4rout (var_GES_YEAR,var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID);

--IF (var_sal > 1000) then
--DBMS_OUTPUT.put_line(var_empno || ' ' || var_ename || ' ' || var_sal);
--ELSE
--DBMS_OUTPUT.put_line(var_ename || ' sal is less then 1000');
--END IF;
END LOOP;
--//closing the cursor//
close ROUT_CURSOR;
--DBMS_OUTPUT.put_line('DONE');
END;

/
--------------------------------------------------------
--  DDL for Procedure G4_SSUB_EACCT_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_SSUB_EACCT_PROC" (
       p_HOLDER            IN         g4_Stat_sub_alloc.HOLDER%TYPE,
       p_AMOUNT            IN         g4_Stat_sub_alloc.SUB_AMOUNT%TYPE,
       p_TRAN_REMARKS      IN         g4_Stat_sub_alloc.TRAN_REMARKS%TYPE,
       p_GES_YEAR          IN         g4_Stat_sub_alloc.GES_YEAR%TYPE,
       p_SSAID             IN         g4_Stat_sub_alloc.SSAID%TYPE,
       p_vcid              IN         g4_Stat_sub_alloc.VCID%TYPE)
IS

----PRAGMA AUTONOMOUS_TRANSACTION;

acct_exist   PLS_INTEGER;
acct_credit  PLS_INTEGER;

BEGIN

begin

  select 1,SUB_AMOUNT  into acct_exist,acct_credit 
  from g4_Stat_sub_alloc
  where  holder = p_HOLDER
  and    vcid   = p_vcid;
  
exception
when others then
acct_exist  := 0;
acct_credit := 0;
end;


if acct_exist = 0 then
 
  INSERT INTO g4_ESCROW_ACCOUNTS (ESCROW_ACCT_ID  ,CREDIT  ,TRAN_REMARKS  ,GES_YEAR  ,ssaid ,vcid)
                          VALUES(p_HOLDER         ,p_AMOUNT,p_TRAN_REMARKS,p_GES_YEAR, p_SSAID,p_vcid );
--commit;
else

update g4_ESCROW_ACCOUNTS
set CREDIT       = (acct_credit + p_AMOUNT),
    DATEMODIFIED = systimestamp
where  ESCROW_ACCT_ID = p_HOLDER
and    vcid   = p_vcid;

end if;


END;

/
--------------------------------------------------------
--  DDL for Procedure G4_START_ROUT_CREATE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_START_ROUT_CREATE" 
is

----TYPE EmpTabTyp IS TABLE OF Number index by PLS_INTEGER;

cn number;

CURSOR ROUT_CURSOR IS select r.FARMERS_CON,r.ROLLOUTID,r.ROLLOUTNAME,r.REDEMP_CENTER,r.ROLLOUTDATE,r.BUNDLEID,r.VCID,r.STATEID,r.LGAID,r.DEALERID,r.FIELDSTAFFID,r.ROLLOUTSTATUS,m.WARDID,r.RES_TYPEID from G3_ROUT_WARDS_MAPPING m,G3_ROLLOUT  r where r.ROLLOUTID = m.ROLLOUTID and    m.processedid is null and   r.ROLLOUTDATE < systimestamp;

begin 
 
EXECUTE IMMEDIATE 'create table g3_start_rout as select r.FARMERS_CON,r.ROLLOUTID,r.ROLLOUTNAME,r.REDEMP_CENTER,r.ROLLOUTDATE,r.BUNDLEID,r.VCID,r.STATEID,r.LGAID,r.DEALERID,r.FIELDSTAFFID,r.ROLLOUTSTATUS,m.WARDID,r.RES_TYPEID from G3_ROUT_WARDS_MAPPING m,G3_ROLLOUT  r where r.ROLLOUTID = m.ROLLOUTID and    m.processedid is null and   r.ROLLOUTDATE < systimestamp';

exception
when others then
cn := 0;
end;

/
--------------------------------------------------------
--  DDL for Procedure G4_UPDATE_ACCOUNT_ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_UPDATE_ACCOUNT_ROUT" (p_VCID PLS_INTEGER,p_farmerid PLS_INTEGER,p_ROLLOUTID PLS_INTEGER,p_BUNDLEID PLS_INTEGER,p_DEALERID PLS_INTEGER,x_bundle_sub PLS_INTEGER )
is 
PRAGMA AUTONOMOUS_TRANSACTION;

TYPE cursor_ref IS REF CURSOR;
  c1 cursor_ref;
  TYPE fmer_msg_tab IS TABLE OF G3_RESPONSES%ROWTYPE;
  msg_fmer_tab fmer_msg_tab;
  rows_fetched NUMBER;
  
  sql_stmt VARCHAR2(2000);


   x_inputid   number;
   x_amount  number;
   x_qty  number;
   x_esc  number;
  ----- x_bundle_sub number := 0; 

stmt_name varchar2(3000) ;

BEGIN
    
  stmt_name := '1.g4_update_account_rout=> select credit,debit,farmerid from g4_account where farmerid = p_farmerid '; 
  
 begin for x in(select credit,debit,farmerid from g4_account where farmerid = p_farmerid)
loop

stmt_name := '2.g4_update_account_rout=> update g4_account set credit = (x.credit + x_bundle_sub) '; 
  
update g4_account
set credit       = (x.credit + x_bundle_sub),
    rolloutid    = p_ROLLOUTID,
    bundleid     = p_BUNDLEID,
    dealerid     = p_DEALERID,
    datemodified = systimestamp
    
where farmerid = x.farmerid;

end loop;

exception
when others then
stmt_name := '3.g4_update_account_rout=> update g4_account set credit = (x.credit + x_bundle_sub) '; 
end;
    


  exception
    when others then
    g4_write_log( SQLCODE,SQLERRM,stmt_name);
    ROLLBACK;
    RAISE;                                
END;

/
--------------------------------------------------------
--  DDL for Procedure G4_UPDATE_FMER_4ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_UPDATE_FMER_4ROUT" (P_GES_YEAR PLS_INTEGER,p_FARMERS_CON PLS_INTEGER,p_ROLLOUTID PLS_INTEGER,p_ROLLOUTNAME varchar2,p_REDEMP_CENTER varchar2,p_ROLLOUTDATE timestamp,p_BUNDLEID PLS_INTEGER,p_VCID PLS_INTEGER,p_STATEID PLS_INTEGER,p_LGAID PLS_INTEGER,p_DEALERID PLS_INTEGER,p_FIELDSTAFFID PLS_INTEGER,p_ROLLOUTSTATUS varchar2,p_WARDID PLS_INTEGER,p_RES_TYPEID PLS_INTEGER )
IS
f_exist PLS_INTEGER;
r_completed PLS_INTEGER;
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
----TYPE dept_tab_type IS TABLE OF farmers_4_rout%ROWTYPE;
TYPE dept_tab_type IS TABLE OF g4_ROLLOUT_reftb%ROWTYPE;
TYPE dept_tab_type2 IS TABLE OF g4_rout_wards_mapping%ROWTYPE;
-----FARMERID,NIM,REGNUM,STATE,WARD,F_NAME,FIRST_NAME,LAST_NAME,MIDDLE_NAME,SEX,GENDERID,AGE,DOB,EDU,F_SIZE,LANG,LANGUAGEID,PHONE1,PHONE2,MSISDN,MSISDN2,VILLAGE_HEAD,VILLAGE_PHONE,CROP1,CROP2,LIVES1,LIVES2,FISH1,FISH2,F_TYPE,F_ID_TYP,F_IDENT,F_BANKC,F_BANK,F_GROUP,F_WARD,MAT_USED,GES,REASON,INF,IMG_DIR,FILNO,STATEID,LGAID,WARDID,SERIAL_NUMBER,PROCESSEDID,LASTROLLOUTID,NUMBEROFROLLOUTS,DATE_CREATED,DATEMODIFIED 
CURSOR c1 IS select * 
from g4_farmers f,G4_FARMERTYPES t 
where f.farmerid = t.farmerid
and t.processedid is null
and f.wardid = p_wardid 
and t.vcid   = p_VCID
and t.GESYEAR= P_GES_YEAR;
   
fmerids dept_tab_type;
fmerids2 dept_tab_type2;
rows PLS_INTEGER := 20;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids LIMIT rows;
begin
    select count(*) into r_completed 
    from g4_rout_wards_mapping m
    
where  m.rolloutid   = p_ROLLOUTID
and    m.processedid is null;
    
 EXCEPTION
WHEN others THEN
    r_completed := 0;
    
END;
if r_completed < 1 then
update g4_rollout
set rolloutstatus = 'COMPLETED',
    datemodified = systimestamp
where ROLLOUTID    = p_ROLLOUTID;
end if;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
---Insert_2_fmer_rout(p_FARMERS_CON,fmerids(i).REDEMP_FARMERID,fmerids(i).MSISDN,fmerids(i).farmerid,fmerids(i).SERIALNUMBER,p_wardid,p_ROLLOUTID,p_ROLLOUTNAME,p_REDEMP_CENTER,p_ROLLOUTDATE,p_BUNDLEID,p_VCID,p_STATEID,p_LGAID,p_DEALERID,p_FIELDSTAFFID,p_ROLLOUTSTATUS,p_RES_TYPEID);
END LOOP;
update g4_rout_wards_mapping
set processedid = 1,
    datemodified = systimestamp
where wardid    = p_wardid
and   vcid      = p_VCID;

update G4_FARMERTYPES
----update farmers_4_rout
set   processedid = 1,
----  lastrolloutid = p_ROLLOUTID,
       DATEMODIFIED = systimestamp
---- NUMBEROFROLLOUTS = (nvl(fmerids(i).NUMBEROFROLLOUTS,0) + 1)
where wardid = p_wardid
and   vcid   = p_VCID
and   GESYEAR= P_GES_YEAR;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure G4_WRITE_LOG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."G4_WRITE_LOG" ( log_code IN INTEGER,log_mesg VARCHAR2,log_stmt_name VARCHAR2)
is 
PRAGMA AUTONOMOUS_TRANSACTION;

CURSOR sess IS 
Select machine,program from v$session where audsid = USERENV('SESSIONID');

rec sess%ROWTYPE;

BEGIN
 OPEN sess;
 FETCH sess INTO rec;
 CLOSE sess;
 
 insert into g4_error_log(log_code,log_mesg,log_user,LOG_MACHINE, LOG_PROG,log_stmt_name)
 values(log_code,log_mesg,user,rec.machine,rec.program,log_stmt_name);
 commit;
 exception
    when others then
    rollback;
end;

/
--------------------------------------------------------
--  DDL for Procedure INSERT_2_FMER_ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."INSERT_2_FMER_ROUT" (p_FARMERS_CON Number,p_MSISDN number,p_farmerid number,p_serial_number number,p_wardid NUMBER,p_ROLLOUTID NUMBER,p_ROLLOUTNAME varchar2,p_REDEMP_CENTER varchar2,p_ROLLOUTDATE timestamp,p_BUNDLEID Number,p_VCID Number,p_STATEID Number,p_LGAID Number,p_DEALERID Number,p_FIELDSTAFFID Number,p_ROLLOUTSTATUS varchar2,p_RES_TYPEID number )
as
v_result number(30);
msg_response number(30);
v_bundle_total number(30);


v_first_msg varchar2(500);
v_second_msg varchar2(500);
v_third_msg varchar2(500);

v_first_msg_sent varchar2(500);
v_second_msg_sent varchar2(500);
v_third_msg_sent varchar2(500);
--TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
--TYPE dept_tab_type IS TABLE OF g3_farmers%ROWTYPE;
--TYPE dept_tab_type2 IS TABLE OF g3_rout_wards_mapping%ROWTYPE;
--empids dept_tab_type;
begin
  /* 
    BEGIN
select farmerid into v_result
from g3_farmers_rollout
where farmerid = p_farmerid
and   bundleid = p_BUNDLEID
and       vcid = p_VCID;

EXCEPTION

WHEN NO_DATA_FOUND THEN
    v_result := 0;
END;

    
BEGIN
select res_typeid into msg_response
from g3_rollout
where rolloutid = p_ROLLOUTID
and   bundleid = p_BUNDLEID
and       vcid = p_VCID;

EXCEPTION

WHEN NO_DATA_FOUND THEN
    msg_response := 0;
END; 
*/
    
    
    
----Retriving msg from response table
select RESMSG into v_first_msg from G3_RESPONSES where RES_TYPEID = p_RES_TYPEID and MSG_SEQ = 1;
select RESMSG into v_second_msg from G3_RESPONSES where RES_TYPEID = p_RES_TYPEID and MSG_SEQ = 2;
select replace(replace(replace(RESMSG,'amount_value',p_FARMERS_CON),'amount_total1',p_FARMERS_CON + 200),'amount_total2',p_FARMERS_CON + 310) into v_third_msg from G3_RESPONSES where RES_TYPEID = p_RES_TYPEID and MSG_SEQ = 3;

select sum(e_total) into v_bundle_total from SSUB_INPUT_V_Total where escrow_acct_id in(p_STATEID,38)  and bundleid = p_BUNDLEID;

--if v_result = 0 then
insert into g3_farmers_rollout(farmerid,rolloutid,bundleid,vcid,rolloutdate)
                        values(p_farmerid,p_ROLLOUTID,p_BUNDLEID,p_VCID,p_ROLLOUTDATE);
                        --commit;
                  
                          
            if length(nvl(p_MSISDN,0)) = 13 then
                select concat(concat(concat(v_first_msg||' '||p_STATEID||'-'||p_LGAID||'-('||p_serial_number,')'),'  Ewallet Bal :N'),v_bundle_total) into v_first_msg_sent from dual;
            
            select v_second_msg into v_second_msg_sent from dual;
            
            select replace(v_third_msg,'redemption_center',p_REDEMP_CENTER) into v_third_msg_sent from dual;
            
            insert into G3_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(v_first_msg_sent,p_MSISDN,7,7,1,'GES',p_ROLLOUTID);
                              --commit;
                              
                              
             insert into G3_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(v_second_msg_sent,p_MSISDN,7,7,1,'GES',p_ROLLOUTID);
                             -- commit;
                              
              insert into G3_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(v_third_msg_sent,p_MSISDN,7,7,1,'GES',p_ROLLOUTID);
                              --commit;
             
            end if;

               insert into G3_ESCROW_ACCOUNTS(ESCROW_ACCT_ID,DEBIT,GES_YEAR,FARMERID)
                                      values(p_STATEID,v_bundle_total,to_char(sysdate,'YYYY'),p_farmerid);
                        --commit;
              insert into g3_account(CREDIT,FARMERID,F_MSISDN,DEALERID,rolloutid,bundleid)
                values(v_bundle_total,p_farmerid,p_MSISDN,p_DEALERID,p_ROLLOUTID,p_BUNDLEID );
                        --commit;
            
            
--end if;
END;
 

/
--------------------------------------------------------
--  DDL for Procedure INSERT_CLOB
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."INSERT_CLOB" 
( clob_in in out CLOB ) IS
BEGIN
  INSERT INTO sample_clob
  VALUES (sample_clob_s.nextval,empty_clob())
  RETURNING sample_clob_var INTO clob_in;
  END;

/
--------------------------------------------------------
--  DDL for Procedure INSERT_FMER_REQ
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."INSERT_FMER_REQ" (p_inboundmsgid Number,p_MSISDN number,p_msgcontent varchar2)
as
v_f_token    varchar2(300);
v_token_msg  varchar2(300);
v_new_farmerid  varchar2(50);
begin
 
    
    begin
    select new_farmerid into v_new_farmerid 
    from g3_farmers_token
    where msisdn = p_MSISDN;
exception
    when others then
    v_new_farmerid := 'Invalid';
    end;
    
    
    
  if   v_new_farmerid = 'Invalid' then
    
    
    
    
 begin   
select f_token into v_f_token
from g3_farmers_token
where new_farmerid = p_msgcontent;
exception
when others then 
v_f_token := 'Invalid Request';
end;
if v_f_token = 'Invalid Request' then
v_token_msg := 'The request is invalid.pls check the Farmer ID.For further inquiry call 092913369,092913363,092915332';
sendsms(v_token_msg,p_MSISDN);
insert into g3_inboundvposmsg
    values(p_inboundmsgid,p_MSISDN,v_token_msg,systimestamp,systimestamp);
else 
select 'Your Redemption Token is :'||v_f_token||' Pls proceed to your RC to Redeem your inputs.'  into  v_token_msg from dual;
  
  sendsms(v_token_msg,p_MSISDN);
insert into g3_inboundvposmsg
    values(p_inboundmsgid,p_MSISDN,v_token_msg,systimestamp,systimestamp);
update g3_farmers_token
    set msisdn     = p_MSISDN,
    no_request = (nvl(no_request,0) + 1),
    datemodified = systimestamp
    
    where new_farmerid = p_msgcontent;
  
end if;

elsif v_new_farmerid = p_msgcontent then
    
        
    begin
        select f_token into v_f_token 
        from g3_farmers_token
        where msisdn = p_MSISDN;
    
exception
    when others then
    v_f_token := '0000';
    end;
    

        
        select 'Your Re-issued Redemption Token is  :'||v_f_token||' Pls proceed to your RC to Redeem your inputs.For further inquiry call 092913369,092913363.'  into  v_token_msg from dual;
        sendsms(v_token_msg,p_MSISDN);

    insert into g3_inboundvposmsg
    values(p_inboundmsgid,p_MSISDN,v_token_msg,systimestamp,systimestamp);
        
        else
        
        begin
        select f_token,new_farmerid into v_f_token,v_new_farmerid 
        from g3_farmers_token
        where msisdn = p_MSISDN;

        exception
            when others then
            v_f_token := '00000';
            v_new_farmerid   := '00000';
            end;
            
        
        
        select 'Dear Farmer,You are trying to request for token that belongs to another farmer Your token is :'||v_f_token||' Farmerid is :'||v_new_farmerid into v_token_msg 
        from dual;
 
        sendsms(v_token_msg,p_MSISDN); 
insert into g3_inboundvposmsg
    values(p_inboundmsgid,p_MSISDN,v_token_msg,systimestamp,systimestamp);

end if; END;

/
--------------------------------------------------------
--  DDL for Procedure INSERT_FMER_REQ2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."INSERT_FMER_REQ2" (p_inboundmsgid Number,p_MSISDN number,p_msgcontent varchar2)
as
v_f_token    varchar2(100);
v_token_msg  varchar2(100);
v_new_farmerid  varchar2(50);
begin
 
    
    begin
    select new_farmerid into v_new_farmerid 
    from g3_farmers_token
    where msisdn = p_MSISDN;
exception
    when others then
    v_new_farmerid := 'Invalid';
    end;
    
    
    
  if   v_new_farmerid = 'Invalid' then
    
    
    
    
 begin   
select f_token into v_f_token
from g3_farmers_token
where new_farmerid = p_msgcontent;
exception
when others then 
v_f_token := 'Invalid Request';
end;
if v_f_token = 'Invalid Request' then
v_token_msg := 'The request is invalid.pls check the Farmer ID';
sendsms(v_token_msg,p_MSISDN);
insert into g3_inboundvposmsg
    values(p_inboundmsgid,p_MSISDN,v_token_msg,systimestamp,systimestamp);
else 
select 'Your Redemption Token is :'||v_f_token||' Pls proceed to your RC to Redeem your inputs'  into  v_token_msg from dual;
  
  sendsms(v_token_msg,p_MSISDN);
insert into g3_inboundvposmsg
    values(p_inboundmsgid,p_MSISDN,v_token_msg,systimestamp,systimestamp);
update g3_farmers_token
    set msisdn     = p_MSISDN,
    no_request = (nvl(no_request,0) + 1),
    datemodified = systimestamp
    
    where new_farmerid = p_msgcontent;
  
end if;
elsif v_new_farmerid = p_msgcontent then
        
        select f_token into v_f_token 
        from g3_farmers_token
        where msisdn = p_MSISDN;
        
        select 'Your Re-issued Redemption Token is  :'||v_f_token||' Pls proceed to your RC to Redeem your inputs'  into  v_token_msg from dual;
        sendsms(v_token_msg,p_MSISDN);
        
        else
        
        
        select f_token,new_farmerid into v_f_token,v_new_farmerid 
        from g3_farmers_token
        where msisdn = p_MSISDN;
        
        
        select 'Dear Farmer,You are trying to request for token that belongs to another farmer Your token is :'||v_f_token||' Farmerid is :'||v_new_farmerid into v_token_msg 
        from dual;
 
        sendsms(v_token_msg,p_MSISDN); end if; END;

/
--------------------------------------------------------
--  DDL for Procedure INSERT_G3_FARMERS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."INSERT_G3_FARMERS" (p_lvcid in number,p_vcid in number,p_vc_tb in varchar2)
is


TYPE cur_typ IS REF CURSOR;
c cur_typ;

f_v_c_id number;
f_id number;
check_fmers number;

desk_top number;

x_FARMERID number;
x_STATEID number;
x_LGAID   number;
x_WARDID number;
x_SERIAL_NUMBER number;

v_processedid number;
sql_stm varchar2(500);
query_str varchar2(500);

p_count number;
exist_fmerid number;
v_farmerid number;
v_FULLNAME varchar2(300);
v_GENDER varchar2(100);
v_DATOFBIRTH varchar2(100);
v_TELNO1 number;
v_TELNO2 number;
v_STATEID number;
v_LGAID number;
v_WARDID number;
v_SERIAL_NUMBER number;

--TYPE dept_tab_type IS TABLE OF ||p_vc_tb||%ROWTYPE;

begin

  begin
     --sql_stm := 'select count(stateid) into'||v_processedid||'from'||p_vc_tb||'where rownum < 2 and processedid is null';
     
  -- EXECUTE IMMEDIATE 'select count(stateid) from '||p_vc_tb||' where processedid is null' into v_processedid;
    

EXECUTE IMMEDIATE 'Select 1 into'||v_processedid||' from dual where exists (select 1 
                   from all_tab_columns 
                  where lower(table_name) = '||p_vc_tb||' 
                    and lower(column_name) = processedid)';





   exception
   when others then
   v_processedid := 0;
   end;
   
--dbms_output.put_line('Testing querying value chain db '||v_processedid||' PROCESSING continue'||p_vc_tb);

if v_processedid = 0 then
begin
EXECUTE IMMEDIATE 'alter table '||p_vc_tb||' add processedid number';

exception
when others then
--dbms_output.put_line('invalid table');
desk_top := 0;
    end;
end if;    


--TYPE dept_tab_type IS TABLE OF ||p_vc_tb||%ROWTYPE;
--CURSOR c1 IS SELECT * FROM ||p_vc_tb|| where processedid is null and rownum < 2; -- ORDER BY DATECREATED ASC;
--fmerids dept_tab_type;

    
    query_str := 'SELECT farmerid,FULLNAME,GENDER,DATOFBIRTH,TELNO1,TELNO2,STATEID,LGAID,WARDID,SERIAL_NUMBER from ' || p_vc_tb || ' WHERE processedid is null and rownum < 2';
    
    OPEN c FOR query_str;
    LOOP
        FETCH c INTO v_farmerid,v_FULLNAME,v_GENDER,v_DATOFBIRTH,v_TELNO1,v_TELNO2,v_STATEID,v_LGAID,v_WARDID,v_SERIAL_NUMBER;
        EXIT WHEN c%NOTFOUND;
    
  begin
  select count(farmerid)  into exist_fmerid 
      from g3_farmers 
      where stateid = v_STATEID  
      and lgaid = v_LGAID 
      and serial_number = v_SERIAL_NUMBER;
  
  exception
  when others then
  exist_fmerid := 0;
  end;
  
  if exist_fmerid = 0 then
  
  select G3_FARMERS_VALUE_CHAIN_SEQ.nextval into f_v_c_id from dual;
  
  select G3_FARMERS_SEQ.nextval into f_id from dual;
  
 insert into G3_FARMERS(farmerid,F_NAME    ,SEX     ,AGE         ,MSISDN  ,MSISDN2 ,STATEID  ,LGAID  ,WARDID  ,SERIAL_NUMBER)
                 values(f_id    ,v_FULLNAME,v_GENDER,v_DATOFBIRTH,v_TELNO1,v_TELNO2,v_STATEID,v_LGAID,v_WARDID,v_SERIAL_NUMBER);
   
   
   
   insert into G3_FARMERS_VALUE_CHAIN(FVCID ,FARMERID,STATEID  ,LGAID   ,WARDID ,VCID    ,SERIAL_NUMBER)
                              values(f_v_c_id,f_id   ,v_STATEID,v_LGAID,v_WARDID,p_vcid,v_SERIAL_NUMBER );
   
  --dbms_output.put_line('This the name '||v_FULLNAME||' VAlue chain id '||p_vcid);
  
  EXECUTE IMMEDIATE 'update  '||p_vc_tb||' set processedid = 1 where farmerid = ' ||v_farmerid;
  
  
  else
  
  select FARMERID,STATEID  ,LGAID   ,WARDID ,SERIAL_NUMBER into x_FARMERID,x_STATEID  ,x_LGAID   ,x_WARDID ,x_SERIAL_NUMBER
  from g3_farmers 
  where stateid = v_STATEID  and lgaid = v_LGAID and serial_number = v_SERIAL_NUMBER;
  
  
  insert into G3_FARMERS_VALUE_CHAIN(FARMERID   ,STATEID  ,LGAID   ,WARDID ,VCID    ,SERIAL_NUMBER)
              
                              values(x_FARMERID ,x_STATEID,x_LGAID,x_WARDID,p_vcid,x_SERIAL_NUMBER );
                              
  
   EXECUTE IMMEDIATE 'update  '||p_vc_tb||' set processedid = 1 where farmerid = ' ||v_farmerid;
  
  
  end if;
   -- process row here
    END LOOP;
    CLOSE c;


begin
EXECUTE IMMEDIATE 'select count(*) from   '||p_vc_tb|| ' where processedid is null ' into check_fmers;

exception
when others then 

EXECUTE IMMEDIATE 'update g3_load_value_chain set processedid = 1 where lvcid = '||p_lvcid;

end;

--end loop;
/*
else 
    EXECUTE IMMEDIATE 'update g3_load_value_chain set processedid = 1 where lvcid = '||p_lvcid;

end if;
*/
end insert_g3_farmers;

/
--------------------------------------------------------
--  DDL for Procedure INSERT_G3_FARMERS_2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."INSERT_G3_FARMERS_2" (p_lvcid in number,p_vcid in number,p_vc_tb in varchar2)

IS
-- TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE reg_vc_type IS TABLE OF dry_rice_farmers_2014_redemp%ROWTYPE;
CURSOR c1 IS select * from dry_rice_farmers_2014_redemp where processedid is null and rownum < 51;

---SELECT * FROM START_REDEMP_AGDMSISDN where processedid is null and rownum < 81; -- ORDER BY DATECREATED ASC;
fmerids reg_vc_type;

x_FARMERID number;
x_STATEID number;
x_LGAID   number;
x_WARDID  number;
x_SERIAL_NUMBER number;

f_id      number;
f_v_c_id  number;

--rows PLS_INTEGER := 10;
--v_results number;

exist_fmerid number;

BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids;
    -----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;


FOR i IN 1..fmerids.COUNT LOOP

begin
  select count(farmerid)  into exist_fmerid 
      from g3_farmers 
      where stateid = fmerids(i).stateid  
      and   lgaid   = fmerids(i).lgaid 
      and   SERIAL_NUMBER = fmerids(i).SERIAL_NUMBER;
  
  exception
  when others then
  exist_fmerid := 0;
  end;


 if exist_fmerid = 0 then
  
  select G3_FARMERS_VALUE_CHAIN_SEQ.nextval into f_v_c_id from dual;
  
  select G3_FARMERS_SEQ.nextval into f_id from dual;
  
 insert into G3_FARMERS(farmerid,F_NAME          ,SEX           ,MSISDN        ,MSISDN2       ,STATEID        ,LGAID        ,WARDID        ,SERIAL_NUMBER)
                 values(f_id    ,fmerids(i).FULLNAME,fmerids(i).GENDER,fmerids(i).TELNO1,fmerids(i).TELNO2,fmerids(i).stateid,fmerids(i).lgaid,fmerids(i).wardid,fmerids(i).serial_number);
   
   
   
   insert into G3_FARMERS_VALUE_CHAIN(FVCID  ,FARMERID,STATEID        ,LGAID        ,WARDID        ,VCID    ,SERIAL_NUMBER)
                              values(f_v_c_id,f_id   ,fmerids(i).stateid,fmerids(i).lgaid,fmerids(i).wardid,p_vcid  ,fmerids(i).serial_number );
   
  --dbms_output.put_line('This the name '||v_FULLNAME||' VAlue chain id '||p_vcid);
  
  EXECUTE IMMEDIATE 'update  '||p_vc_tb||' set processedid = 1 where FARMERID = ' ||fmerids(i).FARMERID;
  
  
  else
  
  select FARMERID,STATEID  ,LGAID   ,WARDID ,SERIAL_NUMBER into x_FARMERID,x_STATEID  ,x_LGAID   ,x_WARDID ,x_SERIAL_NUMBER
  from g3_farmers 
  where stateid = fmerids(i).stateid  and lgaid = fmerids(i).lgaid and SERIAL_NUMBER = fmerids(i).SERIAL_NUMBER;
  
  
  insert into G3_FARMERS_VALUE_CHAIN(FARMERID   ,STATEID  ,LGAID   ,WARDID ,VCID    ,SERIAL_NUMBER)
              
                              values(x_FARMERID ,x_STATEID,x_LGAID,x_WARDID,p_vcid,x_SERIAL_NUMBER );
                              
  
   EXECUTE IMMEDIATE 'update  '||p_vc_tb||' set processedid = 1 where farmerid = ' ||fmerids(i).farmerid;
  
  
  end if;

--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');

END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure KANO_FARMERS_REG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."KANO_FARMERS_REG" IS


    var_table_name  VARCHAR2(30);
    var_dimension_key  VARCHAR2(30);

CURSOR cur_all_dim IS  
    SELECT 
        * from FS_TOKEN2;

CURSOR cur_dimension_key IS
    SELECT * FROM g3_farmers_10_id_cp;


BEGIN
OPEN cur_all_dim;

LOOP
EXIT WHEN cur_all_dim%NOTFOUND;

    FETCH cur_all_dim INTO var_table_name;

    OPEN cur_dimensions_key;
    LOOP
    EXIT WHEN cur_dimensions_key%NOTFOUND;
    
    FETCH cur_dimensions_key INTO var_dimension_key;
    dbms_output.put_line (var_table_name);
    dbms_output.put_line (var_dimension_key);


    END LOOP;
    CLOSE cur_dimension_key;
END LOOP;
CLOSE cur_all_dim;
END;

/
--------------------------------------------------------
--  DDL for Procedure LOAD_FARMERS_UK_CON
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."LOAD_FARMERS_UK_CON" IS

v_result number(30);
 
---EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN
--execute immediate 'drop table load_farmers_uk_con';
execute immediate 'create table load_farmers_uk_con as
select f.farmerid,f.stateid,f.lgaid,f.serial_number,f.msisdn, r.stateid state,r.lgaid lga,r.serial_number sn,r.telno1
from g3_farmers f,dry_rice_farmers_2014_redemp r
where f.msisdn = r.telno1
and   f.stateid <> r.stateid';
END;

/
--------------------------------------------------------
--  DDL for Procedure LOAD_G3_FARMERS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."LOAD_G3_FARMERS" (p_lvcid in number,p_vcid in number,vc_tb in varchar2)
as
v_processedid number;

begin

begin
select count(nvl(processedid,1)) into v_processedid from vc_tb;
EXCEPTION
   WHEN others THEN
    v_processedid := 0;
END;

if v_processedid = 0 then 

execute immediate 'alter table'||vc_tb||'add processedid number';
--alter table vc_tb
--add processedid number;

end if;

end;

/
--------------------------------------------------------
--  DDL for Procedure LOB_INS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."LOB_INS" (p_id IN number, p_text IN varchar2 )
as
g_clob clob;
begin
     insert into t values (p_id, empty_clob() ) returning y into g_clob;
     dbms_lob.write( g_clob,length(p_text), 1,p_text);
end;

/
--------------------------------------------------------
--  DDL for Procedure MULTIPLE_CURSORS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."MULTIPLE_CURSORS_PROC" is
           v_old_farmerid number;
           v_msisdn number;
           v_token varchar(50);
            v_new_farmerid varchar2(100);
     
  
            
                
            cursor firstCursor is
            SELECT f_id_10cp FROM g3_farmers_10_id_cp where rownum < 2;
 
           
           cursor secondCursor is
           select fs_token from fs_token2 where rownum < 2;
          cursor thirdCursor is
            SELECT FARMERID,MSISDN FROM g3_kano_ges_for_reg where  processedid is null and rownum < 2;
 
          begin
 
            
             
             open firstCursor;
             loop
                 fetch firstCursor into v_new_farmerid;
                  exit when firstCursor%notfound;
 
               --  dbms_output.put_line('v_owner: '||v_owner);
                 --dbms_output.put_line('v_table_name: '||v_table_name);
 
                 open secondCursor;
                 loop
                     fetch secondCursor into v_token;
                     exit when secondCursor%notfound;
              open thirdCursor;
                 loop
                     fetch thirdCursor into v_old_farmerid,v_msisdn;
                     exit when thirdCursor%notfound;
                     dbms_output.put_line('New farmerid: '||v_new_farmerid||'token: '||v_token||'Old Farmer Id: '||v_old_farmerid||'MSISDN: '||v_msisdn);
insert into G3_FARMERS_KANO_TOKEN(F_TOKEN         ,FARMERID              ,MSISDN               ,NEW_FARMERID)
                            values(v_token        ,v_old_farmerid        ,v_MSISDN             ,v_new_farmerid);
update g3_farmers_10_id_cp
  set processedid = 2
  where f_id_10cp = v_new_farmerid;
update fs_token2
      set processedid = 2
      where fs_token = v_token;
 update g3_kano_ges_for_reg
  set processedid = 2
  where FARMERID = v_old_farmerid;
                  end loop;
                 close thirdCursor;
 
                 end loop;
                 close secondCursor;
 
              end loop;
              close firstCursor;
 
       EXCEPTION
       WHEN OTHERS THEN
           v_new_farmerid := '00000';
           v_token  := '0000';
v_old_farmerid := 0000;
v_msisdn  := 0000;
           -----  raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
       end MULTIPLE_CURSORS_PROC;

/
--------------------------------------------------------
--  DDL for Procedure MULTIPLE_CURSORS_PROC2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."MULTIPLE_CURSORS_PROC2" is
   v_owner varchar2(40);
   v_table_name varchar2(40);
   v_column_name varchar2(100);
   
   /* First cursor */
   CURSOR get_tables IS
     SELECT f_id_10cp,processedid 
       FROM g3_farmers_10_id_cp where rownum < 10;
     
   /* Second cursor */
   CURSOR get_columns IS
     select fs_token from fs_token2 where rownum < 2;
     
   BEGIN
   
   -- Open first cursor
   OPEN get_tables;
   LOOP
      FETCH get_tables INTO v_owner, v_table_name;
      
      -- Open second cursor
      OPEN get_columns;
      LOOP
         FETCH get_columns INTO v_column_name;
    insert into test_reg_fid_tk2
    values(v_owner, v_table_name,v_column_name);
    
      END LOOP;
      
      CLOSE get_columns;
      
   END LOOP;
   
   CLOSE get_tables;
   
EXCEPTION
   WHEN OTHERS THEN
      v_owner       := '00';
      v_table_name  :=  '11';
      v_column_name :=   '22';
end MULTIPLE_CURSORS_PROC2;

/
--------------------------------------------------------
--  DDL for Procedure MYPROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."MYPROC" (p1 IN NUMBER,p3 varchar2) AS
  BEGIN
     
      
      insert into t values ( p1, p3 );
  END;

/
--------------------------------------------------------
--  DDL for Procedure NAPI_INSERTLOB
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."NAPI_INSERTLOB" (p1 IN NUMBER,p2 clob) AS
  BEGIN
     
      
      LOB_PKG.LOB_INS(p1,substr(p2,1,5000));
      LOB_PKG.add_more(substr(p2,5001,10000));
  END;

/
--------------------------------------------------------
--  DDL for Procedure NEW_SEND_MAIL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."NEW_SEND_MAIL" (p_EMAIL_ADDRESS varchar2,p_password varchar2)
AS
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
--  DDL for Procedure NEW_SEND_MAIL_RESET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."NEW_SEND_MAIL_RESET" (p_EMAIL_ADDRESS varchar2,p_password varchar2)
AS
p_mail_body varchar2(150) := ' Your Have Successfully reset your password Please Click on : http://atms3.cellulant.com.ng to login';
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
--v_message:=v_message||'<tr><br/><td><font color=red size=5>'||p_password||'</font></td><br/></tr>'||utl_tcp.CRLF;
--v_message:=v_message||'<tr><br><br><br><td>'||p_mail_body3||'</td></tr>'||utl_tcp.CRLF;


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
--  DDL for Procedure NEWPHONESTRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."NEWPHONESTRTOKEN" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,line IN varchar2, tokenChar IN varchar2 default ' ')
    is
      TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
        index by binary_integer;
      --
      tokens    tokenTableType;
      vCnt      integer := 1;
      myLine    varchar2(4000) := null;
      vPos      integer := 1;
      v_total   number := 0;
     --
     begin
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     --select tokens.count() into v_total from dual;
      -----Total Count
     for vCnt in 1..tokens.count()
     loop
       v_total := v_total + 1;
     end loop;
     dbms_output.put_line('NoPhone'||'           '||'Input Name'||'        '||'No_Request'||'         '||'REQUEST ID');
     for vCnt in 1..tokens.count()
     loop
             
       dbms_output.put_line(vCnt||'                  '||tokens(vCnt)||'                 '||v_total||'                  '||requestid||'            '||SOURCEADDRESS);
     end loop;
     EXCEPTION
     
     WHEN Others THEN
      raise_application_error (-20001,'Your Request Syntax is wrong.');
      end;      
     --
   end;

/
--------------------------------------------------------
--  DDL for Procedure NOPHONE3STRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."NOPHONE3STRTOKEN" (requestid IN number,request_total IN number,SOURCEADDRESS IN number,line IN varchar2, tokenChar IN varchar2 default ';')
    is
      TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
        index by binary_integer;
      --
      tokens    tokenTableType;
      vCnt      integer := 1;
      myLine    varchar2(4000) := null;
      vPos      integer := 1;
      
      fmer_serial_no    varchar2(4000);
      test_fun      integer := 1;
      
      
      --
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     
      ------------------------------------------------------------------ 
      
     for vCnt in tokens.first..tokens.last
     loop
       --dbms_output.put_line(vCnt||'  '||tokens(vCnt));
       if vCnt != tokens.last then
       continue;
       end if;
       
       begin
       fmer_serial_no := tokens(vCnt);
      exception 
      when others then
      fmer_serial_no :=0;
      end;   

       dbms_output.put_line(vCnt||'  '||fmer_serial_no);
     end loop;
     
     
     --------------------------------------------------------------------
        
      
      
      
      
      
      
      
     if foragdregistn_center_check(SOURCEADDRESS,fmer_serial_no) = 1 then
     
    dbms_output.put_line('Center Pass :The Farmer with ID  :'||fmer_serial_no||' is in your redemption center/is Activated');
    
         
    
    
     for vCnt in 1..tokens.count()
     loop
     if tokens(vCnt) = 'GES3' then
     CONTINUE;
     end if;
     
     
     if replace(tokens(vCnt),'',NULL) = fmer_serial_no then
     CONTINUE;
     end if;
     
     
  
      ---------------------------------BEGIN Check If Farmer is assign bundle--------------------------------
    if foragd_bundle_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
    
    dbms_output.put_line('Bundle Pass :The Farmer with ID  :'||fmer_serial_no||' is assign this bundle '||tokens(vCnt));
    -------------------------------------------BEGIN Check Agro dealer stock-------------------------------------------------
     if foragd_stock_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
    
    dbms_output.put_line('AGD Stock Pass :The Farmer with ID  :'||fmer_serial_no||' can redeem this input '||tokens(vCnt));
    ----------------------------------BEGIN Check credit Balance--------------------------------------------------------------
    if forAGDfarmers_credit_check(tokens(vCnt),SOURCEADDRESS,fmer_serial_no) = 1 then
    
    dbms_output.put_line('Fmers Credit Bal Pass :The Farmer with ID  :'||fmer_serial_no||' has enough credit to redeem this input '||tokens(vCnt));
    else
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
     dbms_output.put_line('Fmers Credit Bal FAIL :The Farmer with ID  :'||fmer_serial_no||' has no enough credit to redeem this input '||tokens(vCnt));
    
     continue;
     end if;
    ----------------------------------END Check credit Balance--------------------------------------------------------------
    else
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
     dbms_output.put_line('AGD Stock Fail :The Farmer with ID  :'||fmer_serial_no||' cannot redeem this input '||tokens(vCnt));
    
     continue;
     end if;
   -----------------------------------END Check Agro dealer stock----------------------------------------
    
       else
     -- G3_FMER_BDLE_MSG_PROC(tokens(vCnt),SOURCEADDRESS,requestid,request_total);
     dbms_output.put_line('Bundle Fail :The Farmer with ID  :'||fmer_serial_no||' is not assigned this bundle '||tokens(vCnt));
    
     continue;
     end if;
     ---------------------------------END Check If Farmer is assign bundle--------------------------------
       end loop;
    
  
    
     else
     dbms_output.put_line('The Farmer with ID  :'||fmer_serial_no||' is not registered or not in your redemption center');
     end if;
     
     
     --

   end;

/
--------------------------------------------------------
--  DDL for Procedure P
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."P" ( p_x in int, p_new_text in varchar2 )
    as
    begin
            insert into t values ( p_x, p_new_text );
    end;

/
--------------------------------------------------------
--  DDL for Procedure P2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."P2" ( p_new_text in clob )
   as
       l_clob clob;
    begin
       insert into t values ( 1, empty_clob() ) returning y into l_clob;
       dbms_lob.write( l_clob, 1, length(p_new_text), p_new_text );
      
   end;
   
   commit;
   
   delete from t;
   
   select x, dbms_lob.getlength(y) from t order by 1 ;
   
   drop table t;
   
   create table t ( x int, y clob );
   
   create or replace procedure p( p_x in int, p_new_text in varchar2 )
    as
    begin
            insert into t values ( p_x, p_new_text );
    end;

/
--------------------------------------------------------
--  DDL for Procedure PERMUTATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."PERMUTATION" (
in_number_of_elements IN NUMBER,
in_permutation_number IN NUMBER,
in_race_in_bet_coupon_array IN type_race_in_bet_coupon_array)

IS
v_race_in_bet_coupon_array type_race_in_bet_coupon_array := type_race_in_bet_coupon_array();
v_tmp_race_in_bet_coupon_array type_race_in_bet_coupon_array := type_race_in_bet_coupon_array();

BEGIN
v_race_in_bet_coupon_array := in_race_in_bet_coupon_array;

IF (in_number_of_elements = 1)
THEN
FOR j IN 1 .. in_permutation_number
LOOP
DBMS_OUTPUT.put (v_race_in_bet_coupon_array (j).runner_number || '-');
END LOOP;

DBMS_OUTPUT.put_line ('');
ELSE
FOR k IN 1 .. in_number_of_elements
LOOP
permutation (in_number_of_elements - 1,
in_permutation_number,
v_race_in_bet_coupon_array
);

IF MOD (in_number_of_elements, 2) = 1
THEN

/* here i am swapping two elements in the list, i used to have another function to do it but i tried to make it simple before posting*/
v_tmp_race_in_bet_coupon_array.DELETE;
v_tmp_race_in_bet_coupon_array.EXTEND (1);
v_tmp_race_in_bet_coupon_array (1) :=
v_race_in_bet_coupon_array (1);
v_race_in_bet_coupon_array (1) :=
v_race_in_bet_coupon_array (in_number_of_elements - 1);
v_race_in_bet_coupon_array (in_number_of_elements - 1) :=
v_tmp_race_in_bet_coupon_array (1);
ELSE
v_tmp_race_in_bet_coupon_array.DELETE;
v_tmp_race_in_bet_coupon_array.EXTEND (1);
v_tmp_race_in_bet_coupon_array (1) :=
v_race_in_bet_coupon_array (k);
v_race_in_bet_coupon_array (k) :=
v_race_in_bet_coupon_array (in_number_of_elements);
v_race_in_bet_coupon_array (in_number_of_elements) :=
v_tmp_race_in_bet_coupon_array (1);
v_race_in_bet_coupon_array := v_race_in_bet_coupon_array;
END IF;
END LOOP;
END IF;
EXCEPTION
WHEN NO_DATA_FOUND
THEN
RAISE;
WHEN OTHERS
THEN
RAISE;
END;

/
--------------------------------------------------------
--  DDL for Procedure PRINT_ANAGRAMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."PRINT_ANAGRAMS" 
  (pre in varchar2, str in varchar2)
  is
    prefix varchar2(30);
    stringg varchar2(30);
    strlen number;
  begin
    strlen := length(str);
    if NVL(strlen, 0) = 0 then
     dbms_output.put_line(pre);
    else
      for i in 1..strlen loop
        prefix := pre || SUBSTR(str,i,1);
        stringg := SUBSTR(str,1,i - 1) || SUBSTR(str,i+1,strlen);
        print_anagrams(prefix,stringg);
      end loop;
    end if;
  end;

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_DETAILS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_DETAILS_PROC" IS
var_REQUESTID        START_REDEMP.REQUESTID%type;
var_MSISDN           START_REDEMP.MSISDN%type;
var_REQUESTLOG       START_REDEMP.REQUESTLOG%type;


var_REQUESTID_2      number;
var_MSISDN_2           number;
var_REQUESTLOG_2       varchar2(500);
 
v_result number(30);
 
---//declaring a cursor
CURSOR REDEMP_CURSOR IS select REQUESTID,MSISDN,REQUESTLOG from START_REDEMP;
--EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN
---/opening a cursor//
open REDEMP_CURSOR;
LOOP
--//fetching records from a cursor//
fetch REDEMP_CURSOR into var_REQUESTID_2,var_MSISDN_2,var_REQUESTLOG_2;
--//testing exit conditions//
EXIT when REDEMP_CURSOR%NOTFOUND;
strToken(var_REQUESTID_2,var_MSISDN_2,replace(replace(replace(replace(var_REQUESTLOG_2,'-',null),'_',null),'(',null),')',null),';., ');
--Update_fmer_4rout (var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID);
--IF (var_sal > 1000) then
--DBMS_OUTPUT.put_line(var_empno || ' ' || var_ename || ' ' || var_sal);
--ELSE
--DBMS_OUTPUT.put_line(var_ename || ' sal is less then 1000');
--END IF;
END LOOP;
--//closing the cursor//
close REDEMP_CURSOR;
DBMS_OUTPUT.put_line('DONE');
END;

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_START_NEW
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_START_NEW" 
IS
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF start_redemp2%ROWTYPE;
CURSOR c1 IS SELECT * FROM start_redemp2 where processedid is null and rownum < 6 order by 1 desc;
fmerids dept_tab_type;
rows PLS_INTEGER := 5;
v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,replace(replace(replace(replace(fmerids(i).MESSAGECONTENT,'-',null),'_',null),'(',null),')',null),';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
update g3_inboundgesmessages
     set processedid = 1,
       datemodified = systimestamp
     where inboundgesmessageid = fmerids(i).INBOUNDGESMESSAGEID;
END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_START_NEW_2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_START_NEW_2" 
IS
-- TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF g3_inboundgesmessages%ROWTYPE;
CURSOR c1 IS SELECT * FROM START_REDEMP_AGDMSISDN where processedid is null and rownum < 81; -- ORDER BY DATECREATED ASC;
fmerids dept_tab_type;
--rows PLS_INTEGER := 10;
--v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids;
    -----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
REDEMP_START_TYPES.strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,
--replace(replace(replace(replace(fmerids(i).MESSAGECONTENT,'-',null),'_',null),'(',null),')',null),';., ');
    upper(TRANSLATE(fmerids(i).MESSAGECONTENT,'~-_()','~')), ';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
update g3_inboundgesmessages
     set processedid = 1,
     datemodified = systimestamp
     where inboundgesmessageid = fmerids(i).INBOUNDGESMESSAGEID;
END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_START_NEW_2015
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_START_NEW_2015" 
IS
-- TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF g3_inboundgesmessages%ROWTYPE;
CURSOR c1 IS SELECT *
FROM g3_inboundgesmessages where processedid is null and rownum < 2; -- ORDER BY DATECREATED ASC;
fmerids dept_tab_type;
--rows PLS_INTEGER := 10;
--v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids;
    -----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
--xxxREDEMP_START_TYPES.strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,
--replace(replace(replace(replace(fmerids(i).MESSAGECONTENT,'-',null),'_',null),'(',null),')',null),';., ');
----    upper(TRANSLATE(fmerids(i).MESSAGECONTENT,'~-_()','~')), ';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);

g3_Redemption_3_1_0.reqToken_3_1_0(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,fmerids(i).MESSAGECONTENT);


update g3_inboundgesmessages
     set processedid = 1,
     datemodified = systimestamp
     where inboundgesmessageid = fmerids(i).INBOUNDGESMESSAGEID;
END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_START_NEW_3
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_START_NEW_3" 
IS
-- TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF g3_inboundgesmessages%ROWTYPE;
CURSOR c1 IS SELECT * FROM g3_inboundgesmessages where processedid is null and rownum < 81; -- ORDER BY DATECREATED ASC;
fmerids dept_tab_type;
--rows PLS_INTEGER := 10;
--v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids; 
    -----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
REDEMP_START_TYPES.strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,
--replace(replace(replace(replace(fmerids(i).MESSAGECONTENT,'-',null),'_',null),'(',null),')',null),';., ');
   upper( TRANSLATE(fmerids(i).MESSAGECONTENT,'~-_()','~')), ';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
update g3_inboundgesmessages
     set processedid = 1,
     datemodified = systimestamp
     where inboundgesmessageid = fmerids(i).INBOUNDGESMESSAGEID;
END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_START_NEW_5ST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_START_NEW_5ST" 
IS
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF START_REDEMP_AGDMSISDN%ROWTYPE;
CURSOR c1 IS SELECT * FROM START_REDEMP_AGDMSISDN2;
 ---where rownum < 10 order by 1 desc;
fmerids dept_tab_type;
rows PLS_INTEGER := 9;
v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids;
 ----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
-- strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,replace(replace(replace(replace(fmerids(i).MESSAGECONTENT,'-',null),'_',null),'(',null),')',null),';., ');
REDEMP_START_TYPES.strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,TRANSLATE(fmerids(i).MESSAGECONTENT,'~-_()','~'), ';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
update G3_INBOUNDGESMESSAGES
     set processedid = 1,
       datemodified = systimestamp
     where inboundgesmessageid = fmerids(i).INBOUNDGESMESSAGEID;
END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_START_NEW_RELOADED
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_START_NEW_RELOADED" 
IS

i number := 0;
-- TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF g3_inboundgesmessages%ROWTYPE;
CURSOR c1 IS SELECT * FROM g3_inboundgesmessages where processedid is null and rownum < 51; -- ORDER BY DATECREATED ASC;
fmerids dept_tab_type;
--rows PLS_INTEGER := 10;
--v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids;
    -----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');

fmerids.extend;
    
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
g3_Redemption_3_1_0.reqToken_3_1_0(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,fmerids(i).MESSAGECONTENT);

--REDEMP_START_TYPES.strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,
--replace(replace(replace(replace(fmerids(i).MESSAGECONTENT,'-',null),'_',null),'(',null),')',null),';., ');
--    upper(TRANSLATE(fmerids(i).MESSAGECONTENT,'~-_()','~')), ';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
update g3_inboundgesmessages
     set processedid = 1,
     datemodified = systimestamp
     where inboundgesmessageid = fmerids(i).INBOUNDGESMESSAGEID;
END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_START_NEW_STATES
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_START_NEW_STATES" 
IS
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF START_REDEMP_AGDMSISDN%ROWTYPE;
CURSOR c1 IS SELECT * FROM START_REDEMP_AGDMSISDN2; 
 ---where rownum < 10 order by 1 desc;
fmerids dept_tab_type;
rows PLS_INTEGER := 9;
v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids; 
 ----LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
strToken(fmerids(i).INBOUNDGESMESSAGEID,fmerids(i).MSISDN,replace(replace(replace(replace(fmerids(i).MESSAGECONTENT,'-',null),'_',null),'(',null),')',null),';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
update G3_INBOUNDGESMESSAGES
     set processedid = 1,
       datemodified = systimestamp
     where inboundgesmessageid = fmerids(i).INBOUNDGESMESSAGEID;
END LOOP;
END LOOP;
CLOSE c1;
END;
?

/
--------------------------------------------------------
--  DDL for Procedure REDEMP_START_NEW_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REDEMP_START_NEW_TEST" 
IS
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
TYPE dept_tab_type IS TABLE OF start_redemp%ROWTYPE;
CURSOR c1 IS SELECT * FROM start_redemp where rownum < 10;
fmerids dept_tab_type;
rows PLS_INTEGER := 9;
v_results number;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids LIMIT rows;
EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE(fmerids(i).MSISDN);
strToken(fmerids(i).REQUESTID,fmerids(i).MSISDN,replace(replace(replace(replace(fmerids(i).REQUESTLOG,'-',null),'_',null),'(',null),')',null),';., ');
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);
update g3_inboundgesmessages
     set processedid = 1
     where inboundgesmessageid = fmerids(i).REQUESTID;
END LOOP;
END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure REQUEST_RECON_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."REQUEST_RECON_PROC" IS
---EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN
execute immediate 'drop table agrodealer_request';
execute immediate 'drop table farmers_request';
execute immediate 'create table agrodealer_request as
select stateid,lgaid,dealerid,dealername,phonenumber,count(*) tt
from g3_agrodealers a,g3_inboundgesmessages i
where phonenumber = msisdn
group by stateid,lgaid,dealerid,dealername,phonenumber';
execute immediate 'create table farmers_request as
select  f.stateid,f.lgaid,f.wardid,f.msisdn,count(*) tt
from g3_farmers f,g3_inboundgesmessages i
where f.msisdn = i.msisdn
group by f.stateid,f.lgaid,f.wardid,f.msisdn';
end;

/
--------------------------------------------------------
--  DDL for Procedure RESTIMGCLOB
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."RESTIMGCLOB" (v_buf clob,v_id number)
is 
---declare
      clob_pointer CLOB;
      ---v_buf clob;
      l_count number;
      ------VARCHAR2(1000);
      
      Amount BINARY_INTEGER := 1;
      Position INTEGER :=1;
    BEGIN
      ----v_buf := 'QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB';
      
      select length(v_buf) into l_count from dual;
      -------rpad('A',1000,'A');
  
      insert into myClob values (v_id ,EMPTY_CLOB());
 
     commit;
 
     SELECT clob_data INTO clob_pointer FROM myClob WHERE id = v_id FOR UPDATE;
     DBMS_LOB.OPEN (clob_pointer,DBMS_LOB.LOB_READWRITE);
 
   FOR i IN 1..l_count LOOP
     --- for i in 1..v_buf.last
 
       DBMS_LOB.WRITE (clob_pointer,Amount,Position,v_buf);
 
       Position :=Position +Amount;
 
     END LOOP;
 
     DBMS_LOB.CLOSE (clob_pointer);
 
   END;
   
   ---commit;

/
--------------------------------------------------------
--  DDL for Procedure ROUT_DETAILS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."ROUT_DETAILS_PROC" IS

var_ROLLOUTID        start_rout.ROLLOUTID%type;
var_ROLLOUTNAME      start_rout.ROLLOUTNAME%type;
var_REDEMP_CENTER    start_rout.REDEMP_CENTER%type;
var_ROLLOUTDATE      start_rout.ROLLOUTDATE%type;

var_BUNDLEID         start_rout.BUNDLEID%type;
var_VCID             start_rout.VCID%type;
var_STATEID          start_rout.STATEID%type;
var_LGAID            start_rout.LGAID%type;

var_DEALERID         start_rout.DEALERID%type;
var_FIELDSTAFFID     start_rout.FIELDSTAFFID%type;
var_ROLLOUTSTATUS    start_rout.ROLLOUTSTATUS%type;
var_WARDID           start_rout.WARDID%type;
var_FARMERS_CON      start_rout.FARMERS_CON%type; 
var_RES_TYPEID       start_rout.RES_TYPEID%type;

v_result number(30);

 

---//declaring a cursor
CURSOR ROUT_CURSOR IS select FARMERS_CON,ROLLOUTID,ROLLOUTNAME,REDEMP_CENTER,ROLLOUTDATE,BUNDLEID,VCID,STATEID,LGAID,DEALERID,FIELDSTAFFID,ROLLOUTSTATUS,WARDID,RES_TYPEID from start_rout;




--EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN
---/opening a cursor//
open ROUT_CURSOR;
LOOP
--//fetching records from a cursor//
fetch ROUT_CURSOR into var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID;
--//testing exit conditions//
EXIT when ROUT_CURSOR%NOTFOUND;

Update_fmer_4rout (var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID);


--IF (var_sal > 1000) then
--DBMS_OUTPUT.put_line(var_empno || ' ' || var_ename || ' ' || var_sal);
--ELSE
--DBMS_OUTPUT.put_line(var_ename || ' sal is less then 1000');
--END IF;
END LOOP;
--//closing the cursor//
close ROUT_CURSOR;
--DBMS_OUTPUT.put_line('DONE');
END;


/
--------------------------------------------------------
--  DDL for Procedure RUNQUERY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."RUNQUERY" is 
BEGIN
 
 EXECUTE IMMEDIATE q'{create table POS_GENERIC_transa as 
select s.stateName as State,l.lgaName as Lga,r.REDEMP_CENTER as RC ,ag.DEALERNAME as AGD,ag.PHONENUMBER as AGD_number,count(*) as total 
from g3_rout_wards_mapping rwm, g3_rollout r, g3_agrodealers ag, g3_states s,g3_lga l,dry_postransaction_request p
where rwm.WARDID=p.WARDID and rwm.ROLLOUTID=r.ROLLOUTID and r.DEALERID=ag.DEALERID and rwm.stateID=s.stateID and rwm.lgaID=l.lgaID
and (p.VALUECHAINID='GENERIC GES' or p.VALUECHAINID='GENERIC-GES' or p.VALUECHAINID='GENERIC') and rwm.VCID=1 
group by s.stateName,l.lgaName,r.REDEMP_CENTER,ag.DEALERNAME,ag.PHONENUMBER
order by s.stateName,l.lgaName,r.REDEMP_CENTER,ag.DEALERNAME,ag.PHONENUMBER}';

END;

/
--------------------------------------------------------
--  DDL for Procedure SCHEDULEDMESSAGE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."SCHEDULEDMESSAGE" as


v_first_msg varchar2(500):='Ka/Kin samu cancantar shigar tsarin rabon taki na jihar Kano(GES) wanda ya baka/baki daman sayen taki a kan rangwame.lambar tantancewa ka/ki ita ce ';
v_first_msgI varchar2(500):= 'ragowan kudin asususn ki/ka naira 4,000 wannan taimako ne daga mai girma Dr Abdullahi Umar Gwanduje daya ya kawo maki/ka';
v_second_msg varchar2(500):='Ka/Ki cancancin tallafin. buhu biyu na taki mai nauyin kilo hamsin (50) ';
v_third_msg varchar2(500):='Garzaya  ISLAMIC CENTER  da kudi naira dubu bakwai (7000) don ka/ki karbi taki buhu biyumai tallafin gwamanatin jihar kano';
v_fourth_msg varchar2(500):= 'aika da sakon waya(sms) zuwa 437(mtn) ko 32145 (sauran layuka) daga wayar ka/ki don samun tallafin in ba;a aika wannan sakon ba babu tallafin sayen takin';
v_first_msg_sent varchar2(500);
BEGIN
  FOR item IN (
    SELECT  FARMERID,msisdn,new_farmerID from kanoGES_register where  LENGTH(msisdn)=13 AND lgaID=404 AND  msgID IS NULL AND  ROWNUM< 101
  ) LOOP
   select   v_first_msg ||item.new_farmerID ||v_first_msgI  into v_first_msg_sent from dual;
   
    insert into G3_outMessages_unsent(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
     values(v_first_msg_sent,item.MSISDN,7,7,1,'KANOGES',1);
     
      insert into G3_outMessages_unsent(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
     values(v_second_msg,item.MSISDN,7,7,1,'KANOGES',1);
     
      insert into G3_outMessages_unsent(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
     values(v_third_msg,item.MSISDN,7,7,1,'KANOGES',1);
     
      insert into G3_outMessages_unsent(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
     values(v_fourth_msg,item.MSISDN,7,7,1,'KANOGES',1);
     
     UPDATE kanoGES_register SET msgID=1 WHERE FARMERID=ITEM.FARMERID;
  END LOOP;
  commit;
END;

/
--------------------------------------------------------
--  DDL for Procedure SEND_MAIL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."SEND_MAIL" (p_EMAIL_ADDRESS varchar2,p_password varchar2)

as 
p_mail_body varchar2(150) := 'Please Click on : http://atms3.cellulant.com.ng/pls/apex/f?p=110:89:25745763095939::::: to set your password.Your Control key is           ';
p_mail_body2 varchar2(250);
p_mail_body3 varchar2(250) := 'After Successful Password Reset Click http://atms3.cellulant.com.ng for subsequent login';


l_id number;
l_index number;
l_vc_arr2 APEX_APPLICATION_GLOBAL.VC_ARR2;
BEGIN
    select concat('Dear ',lower(p_EMAIL_ADDRESS)||' '||p_mail_body||' '||p_password||'   '||p_mail_body3) into p_mail_body2 from dual;

l_id := APEX_MAIL.SEND( 
p_to => lower(p_EMAIL_ADDRESS), 
p_cc => 'aaron@cellulant.com.ng,bolaji.akinboro@cellulant.com,patrick.gbenga@cellulant.com', 
p_from => 'atms@cellulant.com.ng', 
    p_subj => 'AGRO DEALERS TRANSACTION SYSTEM(ATMS):RESET PASSWORD', 
p_body => p_mail_body2);
END;

/
--------------------------------------------------------
--  DDL for Procedure SENDSMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."SENDSMS" (msgContent in varchar2,destAddress in Number)
is
v_request utl_http.req;
v_response utl_http.resp;
v_responsetext varchar2 (2000);
v_url  VARCHAR2(2000);

begin
v_url := 'http://94.229.79.114:36000/proxySenders/proxySender.php?username=bar&password=foo&source=GES'||'&destination='|| apex_util.url_encode(destAddress)||'&message='||apex_util.url_encode(msgContent) ;

--DBMS_OUTPUT.PUT_LINE(v_url);
-- Send SMS.
v_request := utl_http.begin_request (url => v_url, method => 'GET');
-- Authenticate Proxy
v_response := utl_http.get_response (v_request);
--dbms_output.put_line ('Response Status ' || v_response.status_code);
--utl_http.read_text (v_response, v_responsetext);
--dbms_output.put_line ('Response Comment ' || v_responsetext);

UTL_HTTP.END_RESPONSE(v_response);
UTL_HTTP.END_REQUEST(v_request);
exception
when others then 
    
v_responsetext := null;
v_url := null;

end;

/
--------------------------------------------------------
--  DDL for Procedure SENDSMSII
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."SENDSMSII" (msgContent in varchar2,destAddress in Number,sourceAddress in VARCHAR2)
is
v_request utl_http.req;
v_response utl_http.resp;
v_responsetext varchar2 (2000);
v_url  VARCHAR2(2000);

begin

v_url := 'http://94.229.79.114:36000/proxySenders/proxySender.php?username=bar&password=foo&source='|| apex_util.url_encode(sourceAddress)||'&destination='|| apex_util.url_encode(destAddress)||'&message='||apex_util.url_encode(msgContent) ;

--DBMS_OUTPUT.PUT_LINE(v_url);
-- Send SMS.
v_request := utl_http.begin_request (url => v_url, method => 'GET');
-- Authenticate Proxy
v_response := utl_http.get_response (v_request);
--dbms_output.put_line ('Response Status ' || v_response.status_code);
--utl_http.read_text (v_response, v_responsetext);
--dbms_output.put_line ('Response Comment ' || v_responsetext);
UTL_HTTP.END_RESPONSE(v_response);
UTL_HTTP.END_REQUEST(v_request);
exception
when others then 
v_url:=null;
end;

/
--------------------------------------------------------
--  DDL for Procedure SPLIT_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."SPLIT_PROC" (tokenChar IN varchar2)
   is
str string_fnc.t_array;
r_total number := -1;
r_type varchar2(200);
 
 
begin
 
   str := string_fnc.split(tokenChar,' ');
   
 
   for i in 1..str.count loop
 
 
     dbms_output.put_line(str(i));
 if i = 1 then 
 r_type := str(i);
 end if;
     
    -- if i > 0 then
    -- exit;
    -- end if;
r_total := r_total + 1;
   end loop;
dbms_output.put_line(r_total);
dbms_output.put_line(r_type);
 
   end;

/
--------------------------------------------------------
--  DDL for Procedure STATE_LIST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."STATE_LIST" 
AS
v_message VARCHAR2(32000);
conn UTL_SMTP.CONNECTION;
v_sender_acct varchar2(100):='atms@cellulant.com.ng';
v_count number;
v_hostname varchar2(100):=' ';
v_displayhost varchar2(100);
BEGIN
v_message:='<center><h3><i><font color=#000099>List of Nigeria States and Stateid </font></i></h3></center><br>'||utl_tcp.CRLF;
v_message:=v_message||'<table style="border: solid 0px #cccccc" cellspacing="0" cellpadding="0"><tr BGCOLOR=#000099>';
v_message:=v_message||'<td><b><font color=white>Stateid</font></td>';
v_message:=v_message||'<td><b><font color=white>Statename</font></td></tr>'||utl_tcp.CRLF;
FOR i IN (select stateid, statename from g3_states)
LOOP
v_message:=v_message||'<tr><td>'||i.stateid||'</td><td>'||i.statename||'</td></tr>'||utl_tcp.CRLF;
END LOOP;

v_message:=v_message||'</table></body></html>'||utl_tcp.CRLF;
conn:= utl_smtp.open_connection('127.0.0.1');
utl_smtp.helo(conn,'127.0.0.1');
utl_smtp.mail(conn,v_sender_acct);
utl_smtp.rcpt(conn,'aaron@cellulant.com.ng');
utl_smtp.open_data(conn);
utl_smtp.write_data(conn,'content-type: text/html;');
utl_smtp.write_data(conn,'MIME-Version: 1.0'||utl_tcp.CRLF);
utl_smtp.write_data(conn,'To: '||'aaron@cellulant.com.ng'||utl_tcp.CRLF);
utl_smtp.write_data(conn,'Cc:'||utl_tcp.CRLF);
utl_smtp.write_data(conn,'From: '||v_sender_acct||utl_tcp.CRLF);
utl_smtp.write_data(conn,'Subject: List of Nigeria States'||utl_tcp.CRLF);
utl_smtp.write_data(conn,'<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="TEXT/HTML; ">'||
utl_tcp.CRLF||'<content="MSHTML 6.00.2800.1276" name=GENERATOR>'||utl_tcp.CRLF||'<HTML><BODY>');
utl_smtp.write_data(conn,v_message);
utl_smtp.close_data(conn);
utl_smtp.quit(conn);
END;

/
--------------------------------------------------------
--  DDL for Procedure STRTOKEN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."STRTOKEN" (requestid IN Number,SOURCEADDRESS IN Number,line IN varchar2, tokenChar IN varchar2 default ';')
   is
     TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
       index by binary_integer;
     --
     tokens    tokenTableType;
     vCnt      integer := 1;
     myLine    varchar2(4000) := null;
     vPos      integer := 1;
     v_total   number := 0;
     --
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     
     -----Total Count
     for vCnt in 1..tokens.count()
     loop
        if tokens(vCnt) = 'GES2' then
         continue;
         elsif  tokens(vCnt) = 'GES3' then
             continue;
             elsif  tokens(vCnt) = 'GES' then
                 continue;
         end if;
     v_total := v_total + 1;
         
     end loop;
   
    -- dbms_output.put_line('SN'||'           '||'Input Name'||'        '||'No_Request'||'         '||'REQUEST ID');
     
     for vCnt in 1..tokens.count()
     loop
     
     if tokens(vCnt) = 'GES' then
   
   -- fmer2strtoken(requestid,v_total,SOURCEADDRESS,line,tokenChar);
        --  dbms_output.put_line('This is a Agd transaction module request');

     
    fmer3strtoken(requestid,v_total,SOURCEADDRESS,line,tokenChar);
     
     elsif  tokens(vCnt) = 'GES3' then
         
    --dbms_output.put_line('Request id '||'Request Total '||'SOURCEADDRESS'||'line'||'tokenChar'||1);
         
   -- dbms_output.put_line(requestid||':     :'||v_total||':        :'||SOURCEADDRESS||':        :'||line||':      :'||tokenChar);
    ex_agd3strtoken(requestid,v_total,SOURCEADDRESS,line,tokenChar);
    
    --elsif tokens(vCnt) = 'GES2' then
    
    --agdstrtoken(requestid,v_total,SOURCEADDRESS,line,tokenChar);
     
  --else
  
  --dbms_output.put_line('This is a farmer without phone Request');
---dbms_output.put_line('Request id '||'Request Total '||'SOURCEADDRESS'||'line'||'tokenChar'||1);
         
   --- dbms_output.put_line(requestid||':     :'||v_total||':        :'||SOURCEADDRESS||':        :'||line||':      :'||tokenChar);
  null;
     
    end if;
    
     
    --- dbms_output.put_line(vCnt||'                  '||tokens(vCnt)||'                 '||v_total||'                  '||requestid);
     ---  dbms_output.put_line(vCnt||'  '||tokens(vCnt));
     end loop;
     --
   end;

/
--------------------------------------------------------
--  DDL for Procedure STRTOKEN_3_1_1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."STRTOKEN_3_1_1" (requestid IN Number,SOURCEADDRESS IN Number,line IN varchar2, tokenChar IN varchar2 default ';')

    is
    r_type varchar2(500);
    V_total number := 3;
BEGIN
    /*   is
     TYPE  tokenTableType is TABLE of varchar2(4000)   -- table for Stringtoken
       index by binary_integer;
     --
     tokens    tokenTableType;
     vCnt      integer := 1;
     myLine    varchar2(4000) := null;
     vPos      integer := 1;
     v_total   number := 0;
     --
   begin
     while (vPos <= length(line))
     loop
       if (length(replace(tokenChar,substr(line, vPos, 1), '')) = length(tokenChar)) then
         myLine := myLine || substr(line, vPos, 1);
       elsif (myLine is not NULL) then
         tokens(vCnt) := myLine;
         myLine := null;
         vCnt := vCnt + 1;
       end if;
       vPos := vPos + 1;
     end loop;
     --
     if (myLine is not NULL) then
       tokens(vCnt) := myLine;
     end if;
     --
     vCnt := 1;
     
     -----Total Count
     for vCnt in 1..tokens.count()
     loop
        if tokens(vCnt) = 'GES2' then
         continue;
         elsif  tokens(vCnt) = 'GES3' then
             continue;
             elsif  tokens(vCnt) = 'GES' then
                 continue;
         end if;
     v_total := v_total + 1;
         
     end loop;
   
    -- dbms_output.put_line('SN'||'           '||'Input Name'||'        '||'No_Request'||'         '||'REQUEST ID');
     
     for vCnt in 1..tokens.count()
     loop
         
     
     if tokens(vCnt) = 'GES' then
         */
         
         select upper(substr(tokenChar,1,4)) into r_type from dual;
         
         if r_type = 'GES' THEN
   -- fmer2strtoken(requestid,v_total,SOURCEADDRESS,line,tokenChar);
        --  dbms_output.put_line('This is a Agd transaction module request');
     
    fmer3strtoken(requestid,v_total,SOURCEADDRESS,line,tokenChar);

     --elsif  tokens(vCnt) = 'GES3' then
     elsif  r_type = 'GES3' then
         
    --dbms_output.put_line('Request id '||'Request Total '||'SOURCEADDRESS'||'line'||'tokenChar'||1);
         
   -- dbms_output.put_line(requestid||':     :'||v_total||':        :'||SOURCEADDRESS||':        :'||line||':      :'||tokenChar);
    ex_agd3strtoken(requestid,v_total,SOURCEADDRESS,line,tokenChar);
    
    --elsif tokens(vCnt) = 'GES2' then
    
    --agdstrtoken(requestid,v_total,SOURCEADDRESS,line,tokenChar);
     
  --else
  
  --dbms_output.put_line('This is a farmer without phone Request');
---dbms_output.put_line('Request id '||'Request Total '||'SOURCEADDRESS'||'line'||'tokenChar'||1);
         
   --- dbms_output.put_line(requestid||':     :'||v_total||':        :'||SOURCEADDRESS||':        :'||line||':      :'||tokenChar);
  null;
     
    end if;
    
     
    --- dbms_output.put_line(vCnt||'                  '||tokens(vCnt)||'                 '||v_total||'                  '||requestid);
     ---  dbms_output.put_line(vCnt||'  '||tokens(vCnt));
     --end loop;
     --
   end;

/
--------------------------------------------------------
--  DDL for Procedure SUCCESSFUL_TRAN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."SUCCESSFUL_TRAN" (p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_inputid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2)
is

dealer_name varchar2(50);
farmer_name varchar2(50);

f_msisdn    number;
f_stateid   number;
f_lgaid     number;

f_s_sub     number;
f_f_sub     number;
f_f_s_sub     number;

---Dear AGD give FMER 1bag of GES approval size of INPUTNAM.Thank you

---Dear FMER collect your 1bag of GES approved size of INPUTNAME FROM AGD.Thank you
begin
-----------------------------------------------------------------------------------------
 select translate(upper(DEALERNAME),'~1234567890','~') into dealer_name
 from g3_agrodealers  
 where dealerid = p_dealerid;
 -----------------------------------------------------------------------------------------
 select replace(replace(f_name, '_', ' '), 'null', ' '),msisdn,stateid,lgaid into farmer_name,f_msisdn,f_stateid,f_lgaid
 from g3_farmers 
 where farmerid = p_farmerid;
 ----------------------------------------------------------------------------------------
 select amount into f_s_sub from g3_subsidy_input_alloc
 where escrow_acct_id = f_stateid
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select amount into f_f_sub from g3_subsidy_input_alloc
 where escrow_acct_id = 38
 and   inputid       = p_inputid
 and   ges_year      = to_number(to_char(sysdate, 'YYYY'));
 ----------------------------------------------------------------------------------------
 select f_f_sub + f_s_sub into f_f_s_sub from dual;
 ----------------------------------------------------------------------------------------
 dbms_output.put_line('Dealer_name :'||dealer_name||' Farmer_name :'||farmer_name||'farmer_phone :'||f_msisdn||'stateid :'||f_stateid||'lgaid :'||f_lgaid||'fmer state sub :'||f_s_sub||'fmer_fed_sub :'||f_f_sub||'fed and state sub :'||f_f_s_sub);
 EXCEPTION
WHEN others THEN
    dealer_name := NULL;
    farmer_name := NULL;
    f_msisdn    := 0;
    f_stateid   := 0;
    f_lgaid     := 0;
    f_f_sub     := 0;
    f_s_sub     := 0;
    f_f_s_sub   := 0;
END;
--END;

/
--------------------------------------------------------
--  DDL for Procedure TEST_THIRD_PARTY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."TEST_THIRD_PARTY" (p_sourceaddress in NUMBER)
is
l_dealerid number;
begin
if g3_third_p_Reg_check_3_1(p_sourceaddress) = 0 then
dbms_output.put_line('The agd is not available');
else
dbms_output.put_line('The agd is available');
end if;
end;

/
--------------------------------------------------------
--  DDL for Procedure TESTING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."TESTING" 
as
rnum number(10);
nmin number:=1 ; -- 1000000000;
nmax number:=9; -- 9999999999;
amax number;
c number;
myexception exception;
begin
select count(voucher_no) into amax from test;
if amax>=(nmax-nmin+1) then 
raise myexception;
end if;
--select count(no) into amax from test;
<<comehere>>
rnum:=ROUND (DBMS_RANDOM.VALUE(nmin,nmax ));
dbms_output.put_line(rnum);
select count(*) into c from test where voucher_no=rnum;
if c>0 then 
goto comehere;
else 
insert into test values(rnum);
end if;
exception
when myexception then
raise_application_error (-20991, 'all numbers are used ');
end;

/
--------------------------------------------------------
--  DDL for Procedure TESTLOB_INS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."TESTLOB_INS" (p_id IN number, p_text IN clob )
as
        l_clob clob;
        BEGIN
           insert into t values (p_id, empty_clob() ) returning y into l_clob;
           dbms_lob.write( l_clob,length(p_text), 1,p_text);
        END;

/
--------------------------------------------------------
--  DDL for Procedure TRANSACTION_MSG_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."TRANSACTION_MSG_PROC" (p_input_keyword in varchar2,p_sourceaddress in Number,p_requestid in number,request_total in number)
is
    s_input_sub number;
    f_input_sub number;
    f_s_input_sub number;
    fmers_bal number;
    s_f_total_sub number;
    fmer_name varchar2(200);
    fmer_id varchar2(200);
    fmer_fullname varchar2(1000);
    f_input_name varchar2(200);
    agd_name varchar2(200);
    agd_details varchar2(800);
    agd_details_full varchar2(800);
    agd_phone number;
    msg_content varchar2(800);
    

    t_BUNDLEID number;
    t_INPUTID  number;
    t_FARMERID number;
    t_DEALERID number;
    t_PHONENUMBER number;
    t_ROLLOUTID   number;
    t_FIELDSTAFFID number;
     t_VCID number;

    
   
    
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
    select f_name into fmer_name from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_name := NULL;
END;
begin 
    select concat(concat(concat(concat(stateid,'-'),lgaid),'-('),serial_number)  into fmer_id from fmers_map_bundle_input_agd 
    where msisdn = p_sourceaddress
    and upper(keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    fmer_id := NULL;
END;
begin
    select upper(inputname) into f_input_name from g3_inputs i,fmers_map_bundle_input_agd f
    where i.inputid = f.inputid
     and upper(i.keyword) = upper(p_input_keyword)
     and  f.msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    f_input_name := p_input_keyword;
END;
begin
    select replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(upper(DEALERNAME),1,''),2,''),3,''),4,''),5,''),6,''),7,''),8,''),9,''),0,'') into agd_name from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_name := NULL;
END;
begin
    select i.phonenumber into agd_phone from g3_agrodealers i,fmers_map_bundle_input_agd f
    where i.DEALERID = f.DEALERID
    and  f.msisdn = p_sourceaddress
    and  upper(f.keyword) = upper(p_input_keyword);
EXCEPTION
WHEN others THEN
    agd_phone := NULL;
END;


begin
select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
EXCEPTION
WHEN others THEN
    fmers_bal := 0;
END;
    
select concat(concat(agd_name,'('),agd_phone) into agd_details from dual; 
select concat('Collect from ',concat(concat(agd_name,' (AGD :'),agd_phone)) into agd_details_full from dual;
        select concat(concat('Dear ',concat(concat(fmer_name,'('),fmer_id)),') Your Input :') into fmer_fullname from dual;
select concat(concat(concat(concat(concat(fmer_fullname,f_input_name),' Ewallet Bal :'),fmers_bal),' INSUFFICIENT for :'),s_f_total_sub) into msg_content from dual;

insert into G3_OUTMESSAGES_BUFFER(MESSAGECONTENT,DESTADDRESS    ,SOURCEADDRESS,REQUEST_TOTAL,REQUESTID,AGD_NAME)
                       values(msg_content   ,p_sourceaddress,'GES',request_total,p_requestid,agd_details_full);

select BUNDLEID,INPUTID,FARMERID,DEALERID,MSISDN,ROLLOUTID,FIELDSTAFFID,VCID into t_BUNDLEID,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_FIELDSTAFFID,t_VCID 
from fmers_map_bundle_input_agd
where   msisdn = p_sourceaddress
 and  upper(keyword) = upper(p_input_keyword);

insert into g3_transactions(BUNDLEID,REQUESTID,STATUSID,SERVICEID,INPUTID,FARMERID,DEALERID,PHONENUMBER,ROLLOUTID,VCID)
                     values(t_BUNDLEID,p_requestid,10,1,t_INPUTID,t_FARMERID,t_DEALERID,t_PHONENUMBER,t_ROLLOUTID,t_VCID);

--insert into g3_stocklevel(INPUTID,AGRODEALERID,QTY_DECREASE,FARMERID,REMARKS,requestid)
--    values(t_INPUTID,t_DEALERID,1,t_FARMERID,'Farmer_Tran',p_requestid);

--insert into g3_account(DEBIT,FARMERID,F_MSISDN,DEALERID,D_MSISDN,ROLLOUTID,BUNDLEID,REMARKS)
--        values(f_s_input_sub,t_FARMERID,t_PHONENUMBER,t_DEALERID,agd_phone,t_ROLLOUTID,t_BUNDLEID,'Farmer_Tran');

--/**
--begin
--select bal into fmers_bal from farmers_account_bal where msisdn = p_sourceaddress;
--EXCEPTION
--WHEN others THEN
--    fmers_bal := 0;
--END;
-- First, check to see if the user is in the user table
---select nvl(s.stock_bal,0) into l_count from agd_stock_bal s,fmers_map_bundle_input_agd f
---where s.agrodealerid = f.dealerid
--and   s.inputid = f.inputid
--and f.msisdn = p_sourceaddress 
--and f.keyword =p_input_keyword;
 
--     if fmers_bal >= f_s_input_sub  then
         --l_count := 1;
--          return 1;
--                else
--                  return 0;
                  ----  l_count := 0;
--    end if;  **\
  commit;  
end;

/
--------------------------------------------------------
--  DDL for Procedure UPDATE_FMER_4ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."UPDATE_FMER_4ROUT" (p_FARMERS_CON Number,p_ROLLOUTID Number,p_ROLLOUTNAME varchar2,p_REDEMP_CENTER varchar2,p_ROLLOUTDATE timestamp,p_BUNDLEID number,p_VCID number,p_STATEID number,p_LGAID number,p_DEALERID number,p_FIELDSTAFFID number,p_ROLLOUTSTATUS varchar2,p_WARDID number,p_RES_TYPEID number )
IS
f_exist number;
r_completed number;
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;

TYPE dept_tab_type IS TABLE OF farmers_4_rout%ROWTYPE;
TYPE dept_tab_type2 IS TABLE OF g3_rout_wards_mapping%ROWTYPE;

CURSOR c1 IS SELECT * FROM farmers_4_rout
WHERE wardid = p_wardid and rownum < 101;
fmerids dept_tab_type;
fmerids2 dept_tab_type2;
rows PLS_INTEGER := 20;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids LIMIT rows;

begin
SELECT count(*) into f_exist FROM farmers_4_rout
WHERE wardid = p_wardid;
EXCEPTION

WHEN others THEN
    f_exist := 0;
    
END;



if f_exist < 1 then

update g3_rout_wards_mapping
set processedid = 1,
    datemodified = systimestamp
where wardid    = p_wardid;

--commit;
/*
update g3_rollout
set rolloutstatus = 'COMPLETED'
where ROLLOUTID    = p_ROLLOUTID;
--commit;
*/
end if;



begin
    select count(*) into r_completed from farmers_4_rout f,g3_rout_wards_mapping m
where f.wardid = m.wardid
and m.rolloutid = p_ROLLOUTID;
    
 EXCEPTION

WHEN others THEN
    r_completed := 0;
    
END;

if r_completed < 1 then

update g3_rollout
set rolloutstatus = 'COMPLETED',
    datemodified = systimestamp
where ROLLOUTID    = p_ROLLOUTID;
--commit;

end if;





EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);

update farmers_4_rout
set processedid = 1,
    lastrolloutid = p_ROLLOUTID,
    DATEMODIFIED = systimestamp, 
    NUMBEROFROLLOUTS = (nvl(fmerids(i).NUMBEROFROLLOUTS,0) + 1)
where farmerid = fmerids(i).farmerid;
--commit;

--update G3_ROUT_WARDS_MAPPING
--set PROCESSEDID = 1
--where WARDID = fmerids(i).wardid;
--commit;
Insert_2_fmer_rout(p_FARMERS_CON,fmerids(i).MSISDN,fmerids(i).farmerid,fmerids(i).SERIAL_NUMBER,p_wardid,p_ROLLOUTID,p_ROLLOUTNAME,p_REDEMP_CENTER,p_ROLLOUTDATE,p_BUNDLEID,p_VCID,p_STATEID,p_LGAID,p_DEALERID,p_FIELDSTAFFID,p_ROLLOUTSTATUS,p_RES_TYPEID);


END LOOP;

END LOOP;
CLOSE c1;
END;

/
--------------------------------------------------------
--  DDL for Procedure VC_INSERT_2_FMER_ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."VC_INSERT_2_FMER_ROUT" (p_FARMERS_CON Number,p_MSISDN number,p_farmerid number,p_serial_number number,p_wardid NUMBER,p_ROLLOUTID NUMBER,p_ROLLOUTNAME varchar2,p_REDEMP_CENTER varchar2,p_ROLLOUTDATE timestamp,p_BUNDLEID Number,p_VCID Number,p_STATEID Number,p_LGAID Number,p_DEALERID Number,p_FIELDSTAFFID Number,p_ROLLOUTSTATUS varchar2,p_RES_TYPEID number )
as
v_result number(30);
msg_response number(30);
v_bundle_total number(30);

state_bundle number;
fed_bundle   number;


v_first_msg varchar2(500);
v_second_msg varchar2(500);
v_third_msg varchar2(500);

v_first_msg_sent varchar2(500);
v_second_msg_sent varchar2(500);
v_third_msg_sent varchar2(500);
--TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
--TYPE dept_tab_type IS TABLE OF g3_farmers%ROWTYPE;
--TYPE dept_tab_type2 IS TABLE OF g3_rout_wards_mapping%ROWTYPE;
--empids dept_tab_type;
begin
  
    BEGIN
select farmerid into v_result
from g3_farmers_rollout
where farmerid = p_farmerid
and   bundleid = p_BUNDLEID
and       vcid = p_VCID;

EXCEPTION

WHEN NO_DATA_FOUND THEN
    v_result := 0;
END;

 /*   
BEGIN
select res_typeid into msg_response
from g3_rollout
where rolloutid = p_ROLLOUTID
and   bundleid = p_BUNDLEID
and       vcid = p_VCID;

EXCEPTION

WHEN NO_DATA_FOUND THEN
    msg_response := 0;
END;
*/

  
    
    
    
----Retriving msg from response table
select RESMSG into v_first_msg from G3_RESPONSES where RES_TYPEID = p_RES_TYPEID and MSG_SEQ = 1;
select RESMSG into v_second_msg from G3_RESPONSES where RES_TYPEID = p_RES_TYPEID and MSG_SEQ = 2;
select replace(replace(replace(RESMSG,'amount_value',p_FARMERS_CON),'amount_total1',p_FARMERS_CON + 200),'amount_total2',p_FARMERS_CON + 310) into v_third_msg from G3_RESPONSES where RES_TYPEID = p_RES_TYPEID and MSG_SEQ = 3;



begin
select sum(nvl(c.quantity,0) * nvl(s.amount,0)) into fed_bundle
from g3_bundlecontents c ,g3_subsidy_input_alloc s
where c.inputid = s.inputid
and c.bundleid = p_BUNDLEID
and s.escrow_acct_id = 38
and ges_year = to_char(sysdate,'YYYY');

exception
when others then
fed_bundle := 0;
end;

begin
select sum(nvl(c.quantity,0) * nvl(s.amount,0)) into state_bundle
from g3_bundlecontents c ,g3_subsidy_input_alloc s
where c.inputid = s.inputid
and c.bundleid = p_BUNDLEID
and s.escrow_acct_id = p_STATEID
and ges_year = to_char(sysdate,'YYYY');

exception
when others then
state_bundle := 0;
end;




select fed_bundle + state_bundle into v_bundle_total from dual;

if v_result = 0 then
insert into g3_farmers_rollout(farmerid,rolloutid,bundleid,vcid,rolloutdate)
                        values(p_farmerid,p_ROLLOUTID,p_BUNDLEID,p_VCID,p_ROLLOUTDATE);
                        --commit;
                  
                          
            if length(nvl(p_MSISDN,0)) = 13 then
                select concat(concat(concat(v_first_msg||' '||p_STATEID||'-'||p_LGAID||'-('||p_serial_number,')'),'  Ewallet Bal :N'),v_bundle_total) into v_first_msg_sent from dual;
            
            select v_second_msg into v_second_msg_sent from dual;
            
            select replace(v_third_msg,'redemption_center',p_REDEMP_CENTER) into v_third_msg_sent from dual;
            
            insert into G3_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(v_first_msg_sent,p_MSISDN,7,7,1,'GES',p_ROLLOUTID);
                              --commit;
                              
                              
             insert into G3_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(v_second_msg_sent,p_MSISDN,7,7,1,'GES',p_ROLLOUTID);
                             -- commit;
                              
              insert into G3_OUTMESSAGES(MESSAGECONTENT,DESTADDRESS,STATUS,TELCOSTATUS,MSG_TYPE,SOURCEADDRESS,ROLLOUTID)
                              values(v_third_msg_sent,p_MSISDN,7,7,1,'GES',p_ROLLOUTID);
                              --commit;
             
            end if;

               insert into G3_ESCROW_ACCOUNTS(ESCROW_ACCT_ID,DEBIT,GES_YEAR,FARMERID)
                                      values(p_STATEID,v_bundle_total,to_char(sysdate,'YYYY'),p_farmerid);
                        --commit;
              insert into g3_account(CREDIT,FARMERID,F_MSISDN,DEALERID,rolloutid,bundleid)
                values(v_bundle_total,p_farmerid,p_MSISDN,p_DEALERID,p_ROLLOUTID,p_BUNDLEID );
                        --commit;
            
            
end if;
END;
 

/
--------------------------------------------------------
--  DDL for Procedure VC_ROUT_DETAILS_PROC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."VC_ROUT_DETAILS_PROC" IS

var_ROLLOUTID        number;
--start_rout.ROLLOUTID%type;
var_ROLLOUTNAME      varchar2(1000);
--start_rout.ROLLOUTNAME%type;
var_REDEMP_CENTER    varchar2(1000);
---start_rout.REDEMP_CENTER%type;
var_ROLLOUTDATE      timestamp(6);
---start_rout.ROLLOUTDATE%type;

var_BUNDLEID         number;
---start_rout.BUNDLEID%type;
var_VCID             number;
---start_rout.VCID%type;
var_STATEID          number;
---start_rout.STATEID%type;
var_LGAID            number;
---start_rout.LGAID%type;

var_DEALERID         number;
---start_rout.DEALERID%type;
var_FIELDSTAFFID     number;
---start_rout.FIELDSTAFFID%type;
var_ROLLOUTSTATUS    varchar2(20);
---start_rout.ROLLOUTSTATUS%type;
var_WARDID           number;
---start_rout.WARDID%type;
var_FARMERS_CON      number;
---start_rout.FARMERS_CON%type;
var_RES_TYPEID       number;
---start_rout.RES_TYPEID%type;

v_result number(30);

 

---//declaring a cursor
-----CURSOR ROUT_CURSOR IS select FARMERS_CON,ROLLOUTID,ROLLOUTNAME,REDEMP_CENTER,ROLLOUTDATE,BUNDLEID,VCID,STATEID,LGAID,DEALERID,FIELDSTAFFID,ROLLOUTSTATUS,WARDID,RES_TYPEID from start_rout;

CURSOR ROUT_CURSOR IS select r.FARMERS_CON,r.ROLLOUTID,r.ROLLOUTNAME,r.REDEMP_CENTER,r.ROLLOUTDATE,r.BUNDLEID,r.VCID,r.STATEID,r.LGAID,r.DEALERID,r.FIELDSTAFFID,r.ROLLOUTSTATUS,m.WARDID,r.RES_TYPEID
from G3_ROUT_WARDS_MAPPING m,G3_ROLLOUT  r,g3_farmers_value_chain c
where r.ROLLOUTID = m.ROLLOUTID 
and   m.wardid    = c.wardid
and   m.processedid is null
and   r.ROLLOUTDATE < systimestamp
and   rownum < 2;


--EXIT when ROUT_CURSOR%NOTFOUND;
BEGIN
---/opening a cursor//
open ROUT_CURSOR;
LOOP
--//fetching records from a cursor//
fetch ROUT_CURSOR into var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID;
--//testing exit conditions//
EXIT when ROUT_CURSOR%NOTFOUND;

vc_Update_fmer_4rout (var_FARMERS_CON,var_ROLLOUTID,var_ROLLOUTNAME,var_REDEMP_CENTER,var_ROLLOUTDATE,var_BUNDLEID,var_VCID,var_STATEID,var_LGAID,var_DEALERID,var_FIELDSTAFFID,var_ROLLOUTSTATUS,var_WARDID,var_RES_TYPEID);


--IF (var_sal > 1000) then
--DBMS_OUTPUT.put_line(var_empno || ' ' || var_ename || ' ' || var_sal);
--ELSE
--DBMS_OUTPUT.put_line(var_ename || ' sal is less then 1000');
--END IF;
END LOOP;
--//closing the cursor//
close ROUT_CURSOR;
--DBMS_OUTPUT.put_line('DONE');
END;

/
--------------------------------------------------------
--  DDL for Procedure VC_UPDATE_FMER_4ROUT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "UCELLULANT1"."VC_UPDATE_FMER_4ROUT" (p_FARMERS_CON Number,p_ROLLOUTID Number,p_ROLLOUTNAME varchar2,p_REDEMP_CENTER varchar2,p_ROLLOUTDATE timestamp,p_BUNDLEID number,p_VCID number,p_STATEID number,p_LGAID number,p_DEALERID number,p_FIELDSTAFFID number,p_ROLLOUTSTATUS varchar2,p_WARDID number,p_RES_TYPEID number )
IS
f_exist number;
r_completed number;
TYPE numtab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;

TYPE dept_tab_type IS TABLE OF vc_farmers_4rout%ROWTYPE;
TYPE dept_tab_type2 IS TABLE OF g3_rout_wards_mapping%ROWTYPE;

CURSOR c1 IS select f.FARMERID,f.F_NAME,f.STATEID,f.LGAID,f.WARDID,f.SERIAL_NUMBER,f.PROCESSEDID,f.LASTROLLOUTID,f.NUMBEROFROLLOUTS,f.msisdn
  from g3_farmers f,g3_farmers_value_chain c
  where f.farmerid = c.farmerid
  and   c.wardid = p_wardid
  and   c.vcid   = p_vcid
  and   c.processedid is null
  and rownum < 11;
  
fmerids dept_tab_type;
fmerids2 dept_tab_type2;
rows PLS_INTEGER := 20;
BEGIN
OPEN c1;
LOOP -- the following statement fetches 10 rows or less in each iteration
FETCH c1 BULK COLLECT INTO fmerids LIMIT rows;

begin
SELECT count(*) into f_exist 

  from g3_farmers_value_chain 
  where wardid = p_wardid
  and   vcid   = p_vcid
  and   processedid is null;

EXCEPTION

WHEN others THEN
    f_exist := 0;
    
END;



if f_exist < 1 then

update g3_rout_wards_mapping
set processedid = 1,
    datemodified = systimestamp
where wardid    = p_wardid
and   vcid   = p_vcid;

--commit;
/*
update g3_rollout
set rolloutstatus = 'COMPLETED'
where ROLLOUTID    = p_ROLLOUTID;
--commit;
*/
end if;



begin
   select count(*)  into r_completed 
   from g3_farmers_value_chain f,g3_rout_wards_mapping m,g3_rollout r
where f.vcid      = m.vcid
and   f.vcid      = r.vcid
and   f.vcid        = p_vcid
and   f.processedid is  null; 
    
 EXCEPTION

WHEN others THEN
    r_completed := 0;
    
END;

if r_completed < 1 then

update g3_rollout
set rolloutstatus = 'COMPLETED',
    datemodified = systimestamp
where ROLLOUTID    = p_ROLLOUTID
and    vcid        = p_vcid;
--commit;

end if;





EXIT WHEN fmerids.COUNT = 0;
-- EXIT WHEN c1%NOTFOUND; -- incorrect, can omit some data
--DBMS_OUTPUT.PUT_LINE('------- Results from Each Bulk Fetch --------');
FOR i IN 1..fmerids.COUNT LOOP
--DBMS_OUTPUT.PUT_LINE( 'Farmer Id: ' || fmerids(i).farmerid);

update g3_farmers_value_chain
set processedid = 1,
    DATEMODIFIED = systimestamp
    
where farmerid = fmerids(i).farmerid
and    vcid        = p_vcid;
--commit;


update g3_farmers
set processedid = 1,
    lastrolloutid = p_ROLLOUTID,
    DATEMODIFIED = systimestamp,
    NUMBEROFROLLOUTS = (nvl(fmerids(i).NUMBEROFROLLOUTS,0) + 1)
where farmerid = fmerids(i).farmerid;
--update G3_ROUT_WARDS_MAPPING
--set PROCESSEDID = 1
--where WARDID = fmerids(i).wardid;
--commit;
vc_Insert_2_fmer_rout(p_FARMERS_CON,fmerids(i).MSISDN,fmerids(i).farmerid,fmerids(i).SERIAL_NUMBER,p_wardid,p_ROLLOUTID,p_ROLLOUTNAME,p_REDEMP_CENTER,p_ROLLOUTDATE,p_BUNDLEID,p_VCID,p_STATEID,p_LGAID,p_DEALERID,p_FIELDSTAFFID,p_ROLLOUTSTATUS,p_RES_TYPEID);


END LOOP;

END LOOP;
CLOSE c1;
END;

/
