--
-- Copyright (c) Tony Givargis, 1999-2025
--
-- i8052_dbg.vhd
--

library IEEE;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.I8052_PKG.all;

--
-- opc: cracked operation code (see I8052_PKG)
--

entity I8052_DBG is
  port(opc: in UNSIGNED (8 downto 0));
end I8052_DBG;

architecture BEHAVIORAL of I8052_DBG is
begin
  process(opc)
    variable s: STRING (6 downto 1);
    variable l: LINE;
    file f: TEXT is out "trace.out";
  begin
    case opc(6 downto 0) is
      when OPC_ACALL  => s := "ACALL ";
      when OPC_ADD_1  => s := "ADD_1 ";
      when OPC_ADD_2  => s := "ADD_2 ";
      when OPC_ADD_3  => s := "ADD_3 ";
      when OPC_ADD_4  => s := "ADD_4 ";
      when OPC_ADDC_1 => s := "ADDC_1";
      when OPC_ADDC_2 => s := "ADDC_2";
      when OPC_ADDC_3 => s := "ADDC_3";
      when OPC_ADDC_4 => s := "ADDC_4";
      when OPC_AJMP   => s := "AJMP  ";
      when OPC_ANL_1  => s := "ANL_1 ";
      when OPC_ANL_2  => s := "ANL_2 ";
      when OPC_ANL_3  => s := "ANL_3 ";
      when OPC_ANL_4  => s := "ANL_4 ";
      when OPC_ANL_5  => s := "ANL_5 ";
      when OPC_ANL_6  => s := "ANL_6 ";
      when OPC_ANL_7  => s := "ANL_7 ";
      when OPC_ANL_8  => s := "ANL_8 ";
      when OPC_CJNE_1 => s := "CJNE_1";
      when OPC_CJNE_2 => s := "CJNE_2";
      when OPC_CJNE_3 => s := "CJNE_3";
      when OPC_CJNE_4 => s := "CJNE_4";
      when OPC_CLR_1  => s := "CLR_1 ";
      when OPC_CLR_2  => s := "CLR_2 ";
      when OPC_CLR_3  => s := "CLR_3 ";
      when OPC_CPL_1  => s := "CPL_1 ";
      when OPC_CPL_2  => s := "CPL_2 ";
      when OPC_CPL_3  => s := "CPL_3 ";
      when OPC_DA     => s := "DA    ";
      when OPC_DEC_1  => s := "DEC_1 ";
      when OPC_DEC_2  => s := "DEC_2 ";
      when OPC_DEC_3  => s := "DEC_3 ";
      when OPC_DEC_4  => s := "DEC_4 ";
      when OPC_DIV    => s := "DIV   ";
      when OPC_DJNZ_1 => s := "DJNZ_1";
      when OPC_DJNZ_2 => s := "DJNZ_2";
      when OPC_INC_1  => s := "INC_1 ";
      when OPC_INC_2  => s := "INC_2 ";
      when OPC_INC_3  => s := "INC_3 ";
      when OPC_INC_4  => s := "INC_4 ";
      when OPC_INC_5  => s := "INC_5 ";
      when OPC_JB     => s := "JB    ";
      when OPC_JBC    => s := "JBC   ";
      when OPC_JC     => s := "JC    ";
      when OPC_JMP    => s := "JMP   ";
      when OPC_JNB    => s := "JNB   ";
      when OPC_JNC    => s := "JNC   ";
      when OPC_JNZ    => s := "JNZ   ";
      when OPC_JZ     => s := "JZ    ";
      when OPC_LCALL  => s := "LCALL ";
      when OPC_LJMP   => s := "LJMP  ";
      when OPC_MOV_1  => s := "MOV_1 ";
      when OPC_MOV_2  => s := "MOV_2 ";
      when OPC_MOV_3  => s := "MOV_3 ";
      when OPC_MOV_4  => s := "MOV_4 ";
      when OPC_MOV_5  => s := "MOV_5 ";
      when OPC_MOV_6  => s := "MOV_6 ";
      when OPC_MOV_7  => s := "MOV_7 ";
      when OPC_MOV_8  => s := "MOV_8 ";
      when OPC_MOV_9  => s := "MOV_9 ";
      when OPC_MOV_10 => s := "MOV_10";
      when OPC_MOV_11 => s := "MOV_11";
      when OPC_MOV_12 => s := "MOV_12";
      when OPC_MOV_13 => s := "MOV_13";
      when OPC_MOV_14 => s := "MOV_14";
      when OPC_MOV_15 => s := "MOV_15";
      when OPC_MOV_16 => s := "MOV_16";
      when OPC_MOV_17 => s := "MOV_17";
      when OPC_MOV_18 => s := "MOV_18";
      when OPC_MOVC_1 => s := "MOVC_1";
      when OPC_MOVC_2 => s := "MOVC_2";
      when OPC_MOVX_1 => s := "MOVX_1";
      when OPC_MOVX_2 => s := "MOVX_2";
      when OPC_MOVX_3 => s := "MOVX_3";
      when OPC_MOVX_4 => s := "MOVX_4";
      when OPC_MUL    => s := "MUL   ";
      when OPC_NOP    => s := "NOP   ";
      when OPC_ORL_1  => s := "ORL_1 ";
      when OPC_ORL_2  => s := "ORL_2 ";
      when OPC_ORL_3  => s := "ORL_3 ";
      when OPC_ORL_4  => s := "ORL_4 ";
      when OPC_ORL_5  => s := "ORL_5 ";
      when OPC_ORL_6  => s := "ORL_6 ";
      when OPC_ORL_7  => s := "ORL_7 ";
      when OPC_ORL_8  => s := "ORL_8 ";
      when OPC_POP    => s := "POP   ";
      when OPC_PUSH   => s := "PUSH  ";
      when OPC_RET    => s := "RET   ";
      when OPC_RETI   => s := "RETI  ";
      when OPC_RL     => s := "RL    ";
      when OPC_RLC    => s := "RLC   ";
      when OPC_RR     => s := "RR    ";
      when OPC_RRC    => s := "RRC   ";
      when OPC_SETB_1 => s := "SETB_1";
      when OPC_SETB_2 => s := "SETB_2";
      when OPC_SJMP   => s := "SJMP  ";
      when OPC_SUBB_1 => s := "SUBB_1";
      when OPC_SUBB_2 => s := "SUBB_2";
      when OPC_SUBB_3 => s := "SUBB_3";
      when OPC_SUBB_4 => s := "SUBB_4";
      when OPC_SWAP   => s := "SWAP  ";
      when OPC_XCH_1  => s := "XCH_1 ";
      when OPC_XCH_2  => s := "XCH_2 ";
      when OPC_XCH_3  => s := "XCH_3 ";
      when OPC_XCHD   => s := "XCHD  ";
      when OPC_XRL_1  => s := "XRL_1 ";
      when OPC_XRL_2  => s := "XRL_2 ";
      when OPC_XRL_3  => s := "XRL_3 ";
      when OPC_XRL_4  => s := "XRL_4 ";
      when OPC_XRL_5  => s := "XRL_5 ";
      when OPC_XRL_6  => s := "XRL_6 ";
      when others     => s := "      ";
    end case;
    if (s /= "      ") then
      write(l, s, LEFT, 7);
      writeline(f, l);
    end if;
  end process;
end BEHAVIORAL;
