--------------------------------------------------------
--  File created - Saturday-March-19-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package G3_REDEMP_PKG_3_1
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "UCELLULANT1"."G3_REDEMP_PKG_3_1" 
IS 
TYPE t_array IS TABLE OF VARCHAR2(50) 
   INDEX BY BINARY_INTEGER; 
FUNCTION g3_SPLIT_3_1 (p_in_string VARCHAR2, p_delim VARCHAR2) 
    RETURN t_array; 
procedure g3_strtoken_3_1(tokenChar IN varchar2);
END; 
---*/
  /*
CREATE OR REPLACE PACKAGE BODY g3_redemp_pkg_3_1  
IS 
   FUNCTION g3_SPLIT_3_1(p_in_string VARCHAR2, p_delim VARCHAR2) 
    RETURN t_array  
   IS 
    
      i       number :=0; 
      pos     number :=0; 
      lv_str  varchar2(50) := p_in_string; 
       
   strings t_array; 
    
   BEGIN 
    
      -- determine first chuck of string   
      pos := instr(lv_str,p_delim,1,1); 
    
      -- while there are chunks left, loop  
      WHILE ( pos != 0) LOOP 
          
         -- increment counter  
         i := i + 1; 
          
         -- create array element for chuck of string  
         strings(i) := substr(lv_str,1,pos); 
          
         -- remove chunk from string  
         lv_str := substr(lv_str,pos+1,length(lv_str)); 
          
         -- determine next chunk  
         pos := instr(lv_str,p_delim,1,1); 
          
         -- no last chunk, add to array  
         IF pos = 0 THEN 
         
            strings(i+1) := lv_str; 
          
         END IF; 
       
      END LOOP; 
    
      -- return array  
      RETURN strings; 
       
   END g3_SPLIT_3_1; 
--create or replace 
    procedure g3_strtoken_3_1(tokenChar IN varchar2)
   is
str string_fnc.t_array;
r_total number := -1;
r_type varchar2(200);
 
 
begin
    
    
 --str := string_fnc.split(tokenChar,' ');
 
str := g3_SPLIT_3_1(tokenChar,' ');
   
 
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
 
   end g3_strtoken_3_1;
END;  
*/

/
