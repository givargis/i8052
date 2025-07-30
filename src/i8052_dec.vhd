--
-- Copyright (c) Tony Givargis, 1999-2025
-- givargis@uci.edu
-- i8052_dec.vhd
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.I8052_PKG.all;

--
-- rst    : active high
-- opc_in : variable length operation code (see 8052 specs)
-- opc_out: (6 downto 0) cracked operation code (see I8052_PKG)
-- opc_out: (7) set if this instruction uses a second byte of data
-- opc_out: (8) set if this instruction uses a third byte of data
--

entity I8052_DEC is
  port(rst    : in  STD_LOGIC;
       opc_in : in  UNSIGNED (7 downto 0);
       opc_out: out UNSIGNED (8 downto 0));
end I8052_DEC;

architecture BEHAVIORAL of I8052_DEC is
begin
  opc_out <= ("00" & OPC_ERROR ) when rst = '1'                   else
             ("01" & OPC_ACALL ) when opc_in(4 downto 0) = ACALL  else
             ("00" & OPC_ADD_1 ) when opc_in(7 downto 3) = ADD_1  else
             ("01" & OPC_ADD_2 ) when opc_in(7 downto 0) = ADD_2  else
             ("00" & OPC_ADD_3 ) when opc_in(7 downto 1) = ADD_3  else
             ("01" & OPC_ADD_4 ) when opc_in(7 downto 0) = ADD_4  else
             ("00" & OPC_ADDC_1) when opc_in(7 downto 3) = ADDC_1 else
             ("01" & OPC_ADDC_2) when opc_in(7 downto 0) = ADDC_2 else
             ("00" & OPC_ADDC_3) when opc_in(7 downto 1) = ADDC_3 else
             ("01" & OPC_ADDC_4) when opc_in(7 downto 0) = ADDC_4 else
             ("01" & OPC_AJMP  ) when opc_in(4 downto 0) = AJMP   else
             ("00" & OPC_ANL_1 ) when opc_in(7 downto 3) = ANL_1  else
             ("01" & OPC_ANL_2 ) when opc_in(7 downto 0) = ANL_2  else
             ("00" & OPC_ANL_3 ) when opc_in(7 downto 1) = ANL_3  else
             ("01" & OPC_ANL_4 ) when opc_in(7 downto 0) = ANL_4  else
             ("01" & OPC_ANL_5 ) when opc_in(7 downto 0) = ANL_5  else
             ("11" & OPC_ANL_6 ) when opc_in(7 downto 0) = ANL_6  else
             ("01" & OPC_ANL_7 ) when opc_in(7 downto 0) = ANL_7  else
             ("01" & OPC_ANL_8 ) when opc_in(7 downto 0) = ANL_8  else
             ("11" & OPC_CJNE_1) when opc_in(7 downto 0) = CJNE_1 else
             ("11" & OPC_CJNE_2) when opc_in(7 downto 0) = CJNE_2 else
             ("11" & OPC_CJNE_3) when opc_in(7 downto 3) = CJNE_3 else
             ("11" & OPC_CJNE_4) when opc_in(7 downto 1) = CJNE_4 else
             ("00" & OPC_CLR_1 ) when opc_in(7 downto 0) = CLR_1  else
             ("00" & OPC_CLR_2 ) when opc_in(7 downto 0) = CLR_2  else
             ("01" & OPC_CLR_3 ) when opc_in(7 downto 0) = CLR_3  else
             ("00" & OPC_CPL_1 ) when opc_in(7 downto 0) = CPL_1  else
             ("00" & OPC_CPL_2 ) when opc_in(7 downto 0) = CPL_2  else
             ("01" & OPC_CPL_3 ) when opc_in(7 downto 0) = CPL_3  else
             ("00" & OPC_DA    ) when opc_in(7 downto 0) = DA     else
             ("00" & OPC_DEC_1 ) when opc_in(7 downto 0) = DEC_1  else
             ("00" & OPC_DEC_2 ) when opc_in(7 downto 3) = DEC_2  else
             ("01" & OPC_DEC_3 ) when opc_in(7 downto 0) = DEC_3  else
             ("00" & OPC_DEC_4 ) when opc_in(7 downto 1) = DEC_4  else
             ("00" & OPC_DIV   ) when opc_in(7 downto 0) = DIV    else
             ("01" & OPC_DJNZ_1) when opc_in(7 downto 3) = DJNZ_1 else
             ("11" & OPC_DJNZ_2) when opc_in(7 downto 0) = DJNZ_2 else
             ("00" & OPC_INC_1 ) when opc_in(7 downto 0) = INC_1  else
             ("00" & OPC_INC_2 ) when opc_in(7 downto 3) = INC_2  else
             ("01" & OPC_INC_3 ) when opc_in(7 downto 0) = INC_3  else
             ("00" & OPC_INC_4 ) when opc_in(7 downto 1) = INC_4  else
             ("00" & OPC_INC_5 ) when opc_in(7 downto 0) = INC_5  else
             ("11" & OPC_JB    ) when opc_in(7 downto 0) = JB     else
             ("11" & OPC_JBC   ) when opc_in(7 downto 0) = JBC    else
             ("01" & OPC_JC    ) when opc_in(7 downto 0) = JC     else
             ("00" & OPC_JMP   ) when opc_in(7 downto 0) = JMP    else
             ("11" & OPC_JNB   ) when opc_in(7 downto 0) = JNB    else
             ("01" & OPC_JNC   ) when opc_in(7 downto 0) = JNC    else
             ("01" & OPC_JNZ   ) when opc_in(7 downto 0) = JNZ    else
             ("01" & OPC_JZ    ) when opc_in(7 downto 0) = JZ     else
             ("11" & OPC_LCALL ) when opc_in(7 downto 0) = LCALL  else
             ("11" & OPC_LJMP  ) when opc_in(7 downto 0) = LJMP   else
             ("00" & OPC_MOV_1 ) when opc_in(7 downto 3) = MOV_1  else
             ("01" & OPC_MOV_2 ) when opc_in(7 downto 0) = MOV_2  else
             ("00" & OPC_MOV_3 ) when opc_in(7 downto 1) = MOV_3  else
             ("01" & OPC_MOV_4 ) when opc_in(7 downto 0) = MOV_4  else
             ("00" & OPC_MOV_5 ) when opc_in(7 downto 3) = MOV_5  else
             ("01" & OPC_MOV_6 ) when opc_in(7 downto 3) = MOV_6  else
             ("01" & OPC_MOV_7 ) when opc_in(7 downto 3) = MOV_7  else
             ("01" & OPC_MOV_8 ) when opc_in(7 downto 0) = MOV_8  else
             ("01" & OPC_MOV_9 ) when opc_in(7 downto 3) = MOV_9  else
             ("11" & OPC_MOV_10) when opc_in(7 downto 0) = MOV_10 else
             ("01" & OPC_MOV_11) when opc_in(7 downto 1) = MOV_11 else
             ("11" & OPC_MOV_12) when opc_in(7 downto 0) = MOV_12 else
             ("00" & OPC_MOV_13) when opc_in(7 downto 1) = MOV_13 else
             ("01" & OPC_MOV_14) when opc_in(7 downto 1) = MOV_14 else
             ("01" & OPC_MOV_15) when opc_in(7 downto 1) = MOV_15 else
             ("01" & OPC_MOV_16) when opc_in(7 downto 0) = MOV_16 else
             ("01" & OPC_MOV_17) when opc_in(7 downto 0) = MOV_17 else
             ("11" & OPC_MOV_18) when opc_in(7 downto 0) = MOV_18 else
             ("00" & OPC_MOVC_1) when opc_in(7 downto 0) = MOVC_1 else
             ("00" & OPC_MOVC_2) when opc_in(7 downto 0) = MOVC_2 else
             ("00" & OPC_MOVX_1) when opc_in(7 downto 1) = MOVX_1 else
             ("00" & OPC_MOVX_2) when opc_in(7 downto 0) = MOVX_2 else
             ("00" & OPC_MOVX_3) when opc_in(7 downto 1) = MOVX_3 else
             ("00" & OPC_MOVX_4) when opc_in(7 downto 0) = MOVX_4 else
             ("00" & OPC_MUL   ) when opc_in(7 downto 0) = MUL    else
             ("00" & OPC_NOP   ) when opc_in(7 downto 0) = NOP    else
             ("00" & OPC_ORL_1 ) when opc_in(7 downto 3) = ORL_1  else
             ("01" & OPC_ORL_2 ) when opc_in(7 downto 0) = ORL_2  else
             ("00" & OPC_ORL_3 ) when opc_in(7 downto 1) = ORL_3  else
             ("01" & OPC_ORL_4 ) when opc_in(7 downto 0) = ORL_4  else
             ("01" & OPC_ORL_5 ) when opc_in(7 downto 0) = ORL_5  else
             ("11" & OPC_ORL_6 ) when opc_in(7 downto 0) = ORL_6  else
             ("01" & OPC_ORL_7 ) when opc_in(7 downto 0) = ORL_7  else
             ("01" & OPC_ORL_8 ) when opc_in(7 downto 0) = ORL_8  else
             ("01" & OPC_POP   ) when opc_in(7 downto 0) = POP    else
             ("01" & OPC_PUSH  ) when opc_in(7 downto 0) = PUSH   else
             ("00" & OPC_RET   ) when opc_in(7 downto 0) = RET    else
             ("00" & OPC_RETI  ) when opc_in(7 downto 0) = RETI   else
             ("00" & OPC_RL    ) when opc_in(7 downto 0) = RL     else
             ("00" & OPC_RLC   ) when opc_in(7 downto 0) = RLC    else
             ("00" & OPC_RR    ) when opc_in(7 downto 0) = RR     else
             ("00" & OPC_RRC   ) when opc_in(7 downto 0) = RRC    else
             ("00" & OPC_SETB_1) when opc_in(7 downto 0) = SETB_1 else
             ("01" & OPC_SETB_2) when opc_in(7 downto 0) = SETB_2 else
             ("01" & OPC_SJMP  ) when opc_in(7 downto 0) = SJMP   else
             ("00" & OPC_SUBB_1) when opc_in(7 downto 3) = SUBB_1 else
             ("01" & OPC_SUBB_2) when opc_in(7 downto 0) = SUBB_2 else
             ("00" & OPC_SUBB_3) when opc_in(7 downto 1) = SUBB_3 else
             ("01" & OPC_SUBB_4) when opc_in(7 downto 0) = SUBB_4 else
             ("00" & OPC_SWAP  ) when opc_in(7 downto 0) = SWAP   else
             ("00" & OPC_XCH_1 ) when opc_in(7 downto 3) = XCH_1  else
             ("01" & OPC_XCH_2 ) when opc_in(7 downto 0) = XCH_2  else
             ("00" & OPC_XCH_3 ) when opc_in(7 downto 1) = XCH_3  else
             ("00" & OPC_XCHD  ) when opc_in(7 downto 1) = XCHD   else
             ("00" & OPC_XRL_1 ) when opc_in(7 downto 3) = XRL_1  else
             ("01" & OPC_XRL_2 ) when opc_in(7 downto 0) = XRL_2  else
             ("00" & OPC_XRL_3 ) when opc_in(7 downto 1) = XRL_3  else
             ("01" & OPC_XRL_4 ) when opc_in(7 downto 0) = XRL_4  else
             ("01" & OPC_XRL_5 ) when opc_in(7 downto 0) = XRL_5  else
             ("11" & OPC_XRL_6 ) when opc_in(7 downto 0) = XRL_6  else
             ("00" & OPC_ERROR );
end BEHAVIORAL;
