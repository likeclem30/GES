--------------------------------------------------------
--  File created - Saturday-March-19-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package G4_VC_REGISTRATION_4_0_0
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "UCELLULANT1"."G4_VC_REGISTRATION_4_0_0" 
  
IS 
TYPE t_array IS TABLE OF VARCHAR2(50) 
   INDEX BY BINARY_INTEGER; 
   
function g4_unique_farmerid(p_vcid number) RETURN VARCHAR2;
function g4_get_num_fid (p_highval   NUMBER,p_lowval    NUMBER := 0,p_scale     PLS_INTEGER := 0) RETURN NUMBER;
function g4_chk_uk_fid(fid varchar2,p_vcid number) RETURN NUMBER;
function g4_unique_token(p_vcid number) RETURN VARCHAR2;
FUNCTION g4_get_num_tk (p_highval   NUMBER,p_lowval    NUMBER := 0,p_scale     PLS_INTEGER := 0)  RETURN NUMBER;
function g4_chk_uk_token(token varchar2,p_vcid number)RETURN NUMBER;
function g4_mustget_uk_fid(p_vcid number) RETURN VARCHAR2;
function g4_mustget_uk_tk(p_vcid number) RETURN VARCHAR2;
---PROCEDURE g3_reg_value_chain; 
---PROCEDURE insert_g3_farmers(p_lvcid in number,p_vcid in number,p_vc_tb in varchar2);
PROCEDURE g4_Reg_details_proc(var_lvcid       number,var_vcid         Number,var_vc_tb        varchar2);
PROCEDURE g4_Registration ( p_WARDID number,var_lvcid       number,var_vcid         Number,var_vc_tb        varchar2 );
PROCEDURE g4_write_log( log_code IN INTEGER,log_mesg VARCHAR2,log_stmt_name VARCHAR2);
end;

/
