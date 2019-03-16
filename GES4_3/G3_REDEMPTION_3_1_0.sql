--------------------------------------------------------
--  File created - Saturday-March-19-2016   
--------------------------------------------------------
-- Unable to render PACKAGE DDL for object UCELLULANT1.G3_REDEMPTION_3_1_0 with DBMS_METADATA attempting internal generator.
CREATE 
PACKAGE G3_REDEMPTION_3_1_0 
    ----STRING_FNC 
IS 
TYPE t_array IS TABLE OF VARCHAR2(50) 
   INDEX BY BINARY_INTEGER; 
FUNCTION split_3_1_0 (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array; 
FUNCTION is_number( p_str IN VARCHAR2 ) RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE;

FUNCTION g3_third_p_Reg_check_3_1 (p_sourceaddress in NUMBER) RETURN NUMBER;
FUNCTION g3_third_p_act_check_3_1 (p_dealerid in NUMBER, p_vcid in NUMBER) RETURN NUMBER;
FUNCTION g3_third_p_cen_check_3_1 (p_dealerid in NUMBER,p_l_req_item_n in NUMBER) RETURN NUMBER;
FUNCTION g3_third_p_f_act_check_3_1 (p_farmerid in NUMBER,p_bundleid in NUMBER,p_vcid in NUMBER) RETURN NUMBER;
FUNCTION g3_third_p_b_input_check_3_1 (p_bundleid in number,p_inputid in number) RETURN NUMBER;
FUNCTION STR2NUM_3_1_0 (p_string varchar2) RETURN NUMBER;
FUNCTION g3_third_p_stock_check_3_1(p_dealerid in number,p_inputid in NUMBER)return number;
FUNCTION g3_third_p_acct_bal_3_1 (p_farmerid in number) return number;

FUNCTION g3_fmer_Reg_check_3_1     (p_sourceaddress in NUMBER)                RETURN NUMBER;
FUNCTION g3_fmer_cen_check_3_1     (p_farmerid in NUMBER, p_vcid in NUMBER)   RETURN NUMBER;
FUNCTION g3_fmer_act_check_3_1     (p_farmerid in NUMBER, p_vcid in NUMBER)   RETURN NUMBER;
FUNCTION g3_fmer_b_input_check_3_1 (p_bundleid in number,p_inputid in number) RETURN NUMBER;
FUNCTION g3_fmers_stock_check_3_1  (p_dealerid in number,p_inputid in NUMBER) RETURN NUMBER;
FUNCTION g3_fmer_acct_bal_3_1      (p_farmerid in number)                     RETURN NUMBER;


---PROCEDURE g3_reg_value_chain; 
---PROCEDURE insert_g3_farmers(p_lvcid in number,p_vcid in number,p_vc_tb in varchar2);
PROCEDURE reqToken_3_1_0(requestid IN number,SOURCEADDRESS IN number,rToken IN VARCHAR2);
PROCEDURE agd3strToken_3_1(requestid IN number,request_total IN number,SOURCEADDRESS IN number,rToken IN varchar2,l_req_item varchar2,l_vcid number);
PROCEDURE fmer3strToken_3_1(requestid IN number,request_total IN number,SOURCEADDRESS IN number,rToken IN varchar2,l_req_item varchar2,l_vcid number);

PROCEDURE agd_successful_3_1_0(p_sourceaddress in number,p_request_total in number,p_requestid in number,p_dealerid in number,p_f_serial_no in number,p_farmerid in number,p_inputid in number,p_bundleid in number,p_rolloutid in number,p_vcid in number,p_payload in varchar2);
END;
