create or replace PACKAGE g3_VPOS2015 
    ----STRING_FNC 
IS 
TYPE t_array IS TABLE OF VARCHAR2(50) 
   INDEX BY BINARY_INTEGER; 
FUNCTION split_3_1_0 (p_in_string VARCHAR2, p_delim VARCHAR2) RETURN t_array; 
FUNCTION is_number( p_str IN VARCHAR2 ) RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE;

FUNCTION check_token_3_2(p_ftoken in varchar2) return VARCHAR2;
FUNCTION chk_tken_phoneno(p_tk_phone in number)return VARCHAR2;
FUNCTION chk_fmer_rdemp(p_tk_phone in number,p_token in varchar2) return VARCHAR2;

procedure sendsms(msgContent in varchar2,destAddress in Number);
PROCEDURE Insert_fmer_req (p_inboundmsgid in Number,p_MSISDN in number,p_msgcontent in varchar2);
    
END;
