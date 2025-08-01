--
-- Copyright (c) Tony Givargis, 1999-2025
-- givargis@uci.edu
-- i8052_pkg.vhd
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

package I8052_PKG is
  constant CD_16: UNSIGNED (15 downto 0) := "----------------";
  constant CD_12: UNSIGNED (11 downto 0) := "------------";
  constant CD_8 : UNSIGNED ( 7 downto 0) := "--------";
  constant C0_8 : UNSIGNED ( 7 downto 0) := "00000000";
  constant C1_8 : UNSIGNED ( 7 downto 0) := "00000001";
  constant C7_8 : UNSIGNED ( 7 downto 0) := "00000111";
  constant CM_8 : UNSIGNED ( 7 downto 0) := "11111111";
  constant C9_4 : UNSIGNED ( 3 downto 0) := "1001";

  constant R_P0  : UNSIGNED (7 downto 0) := "10000000"; -- BITADDR
  constant R_SP  : UNSIGNED (7 downto 0) := "10000001";
  constant R_DPL : UNSIGNED (7 downto 0) := "10000010";
  constant R_DPH : UNSIGNED (7 downto 0) := "10000011";
  constant R_PCON: UNSIGNED (7 downto 0) := "10000111";
  constant R_TCON: UNSIGNED (7 downto 0) := "10001000"; -- BITADDR
  constant R_TMOD: UNSIGNED (7 downto 0) := "10001001";
  constant R_TL0 : UNSIGNED (7 downto 0) := "10001010";
  constant R_TL1 : UNSIGNED (7 downto 0) := "10001011";
  constant R_TH0 : UNSIGNED (7 downto 0) := "10001100";
  constant R_TH1 : UNSIGNED (7 downto 0) := "10001101";
  constant R_P1  : UNSIGNED (7 downto 0) := "10010000"; -- BITADDR
  constant R_SCON: UNSIGNED (7 downto 0) := "10011000"; -- BITADDR
  constant R_SBUF: UNSIGNED (7 downto 0) := "10011001";
  constant R_P2  : UNSIGNED (7 downto 0) := "10100000"; -- BITADDR
  constant R_IE  : UNSIGNED (7 downto 0) := "10101000"; -- BITADDR
  constant R_P3  : UNSIGNED (7 downto 0) := "10110000"; -- BITADDR
  constant R_IP  : UNSIGNED (7 downto 0) := "10111000"; -- BITADDR
  constant R_PSW : UNSIGNED (7 downto 0) := "11010000"; -- BITADDR
  constant R_A   : UNSIGNED (7 downto 0) := "11100000"; -- BITADDR
  constant R_B   : UNSIGNED (7 downto 0) := "11110000"; -- BITADDR

  constant ACALL : UNSIGNED (4 downto 0) := "10001";
  constant ADD_1 : UNSIGNED (4 downto 0) := "00101";
  constant ADD_2 : UNSIGNED (7 downto 0) := "00100101";
  constant ADD_3 : UNSIGNED (6 downto 0) := "0010011";
  constant ADD_4 : UNSIGNED (7 downto 0) := "00100100";
  constant ADDC_1: UNSIGNED (4 downto 0) := "00111";
  constant ADDC_2: UNSIGNED (7 downto 0) := "00110101";
  constant ADDC_3: UNSIGNED (6 downto 0) := "0011011";
  constant ADDC_4: UNSIGNED (7 downto 0) := "00110100";
  constant AJMP  : UNSIGNED (4 downto 0) := "00001";
  constant ANL_1 : UNSIGNED (4 downto 0) := "01011";
  constant ANL_2 : UNSIGNED (7 downto 0) := "01010101";
  constant ANL_3 : UNSIGNED (6 downto 0) := "0101011";
  constant ANL_4 : UNSIGNED (7 downto 0) := "01010100";
  constant ANL_5 : UNSIGNED (7 downto 0) := "01010010";
  constant ANL_6 : UNSIGNED (7 downto 0) := "01010011";
  constant ANL_7 : UNSIGNED (7 downto 0) := "10000010";
  constant ANL_8 : UNSIGNED (7 downto 0) := "10110000";
  constant CJNE_1: UNSIGNED (7 downto 0) := "10110101";
  constant CJNE_2: UNSIGNED (7 downto 0) := "10110100";
  constant CJNE_3: UNSIGNED (4 downto 0) := "10111";
  constant CJNE_4: UNSIGNED (6 downto 0) := "1011011";
  constant CLR_1 : UNSIGNED (7 downto 0) := "11100100";
  constant CLR_2 : UNSIGNED (7 downto 0) := "11000011";
  constant CLR_3 : UNSIGNED (7 downto 0) := "11000010";
  constant CPL_1 : UNSIGNED (7 downto 0) := "11110100";
  constant CPL_2 : UNSIGNED (7 downto 0) := "10110011";
  constant CPL_3 : UNSIGNED (7 downto 0) := "10110010";
  constant DA    : UNSIGNED (7 downto 0) := "11010100";
  constant DEC_1 : UNSIGNED (7 downto 0) := "00010100";
  constant DEC_2 : UNSIGNED (4 downto 0) := "00011";
  constant DEC_3 : UNSIGNED (7 downto 0) := "00010101";
  constant DEC_4 : UNSIGNED (6 downto 0) := "0001011";
  constant DIV   : UNSIGNED (7 downto 0) := "10000100";
  constant DJNZ_1: UNSIGNED (4 downto 0) := "11011";
  constant DJNZ_2: UNSIGNED (7 downto 0) := "11010101";
  constant INC_1 : UNSIGNED (7 downto 0) := "00000100";
  constant INC_2 : UNSIGNED (4 downto 0) := "00001";
  constant INC_3 : UNSIGNED (7 downto 0) := "00000101";
  constant INC_4 : UNSIGNED (6 downto 0) := "0000011";
  constant INC_5 : UNSIGNED (7 downto 0) := "10100011";
  constant JB    : UNSIGNED (7 downto 0) := "00100000";
  constant JBC   : UNSIGNED (7 downto 0) := "00010000";
  constant JC    : UNSIGNED (7 downto 0) := "01000000";
  constant JMP   : UNSIGNED (7 downto 0) := "01110011";
  constant JNB   : UNSIGNED (7 downto 0) := "00110000";
  constant JNC   : UNSIGNED (7 downto 0) := "01010000";
  constant JNZ   : UNSIGNED (7 downto 0) := "01110000";
  constant JZ    : UNSIGNED (7 downto 0) := "01100000";
  constant LCALL : UNSIGNED (7 downto 0) := "00010010";
  constant LJMP  : UNSIGNED (7 downto 0) := "00000010";
  constant MOV_1 : UNSIGNED (4 downto 0) := "11101";
  constant MOV_2 : UNSIGNED (7 downto 0) := "11100101";
  constant MOV_3 : UNSIGNED (6 downto 0) := "1110011";
  constant MOV_4 : UNSIGNED (7 downto 0) := "01110100";
  constant MOV_5 : UNSIGNED (4 downto 0) := "11111";
  constant MOV_6 : UNSIGNED (4 downto 0) := "10101";
  constant MOV_7 : UNSIGNED (4 downto 0) := "01111";
  constant MOV_8 : UNSIGNED (7 downto 0) := "11110101";
  constant MOV_9 : UNSIGNED (4 downto 0) := "10001";
  constant MOV_10: UNSIGNED (7 downto 0) := "10000101";
  constant MOV_11: UNSIGNED (6 downto 0) := "1000011";
  constant MOV_12: UNSIGNED (7 downto 0) := "01110101";
  constant MOV_13: UNSIGNED (6 downto 0) := "1111011";
  constant MOV_14: UNSIGNED (6 downto 0) := "1010011";
  constant MOV_15: UNSIGNED (6 downto 0) := "0111011";
  constant MOV_16: UNSIGNED (7 downto 0) := "10100010";
  constant MOV_17: UNSIGNED (7 downto 0) := "10010010";
  constant MOV_18: UNSIGNED (7 downto 0) := "10010000";
  constant MOVC_1: UNSIGNED (7 downto 0) := "10010011";
  constant MOVC_2: UNSIGNED (7 downto 0) := "10000011";
  constant MOVX_1: UNSIGNED (6 downto 0) := "1110001";
  constant MOVX_2: UNSIGNED (7 downto 0) := "11100000";
  constant MOVX_3: UNSIGNED (6 downto 0) := "1111001";
  constant MOVX_4: UNSIGNED (7 downto 0) := "11110000";
  constant MUL   : UNSIGNED (7 downto 0) := "10100100";
  constant NOP   : UNSIGNED (7 downto 0) := "00000000";
  constant ORL_1 : UNSIGNED (4 downto 0) := "01001";
  constant ORL_2 : UNSIGNED (7 downto 0) := "01000101";
  constant ORL_3 : UNSIGNED (6 downto 0) := "0100011";
  constant ORL_4 : UNSIGNED (7 downto 0) := "01000100";
  constant ORL_5 : UNSIGNED (7 downto 0) := "01000010";
  constant ORL_6 : UNSIGNED (7 downto 0) := "01000011";
  constant ORL_7 : UNSIGNED (7 downto 0) := "01110010";
  constant ORL_8 : UNSIGNED (7 downto 0) := "10100000";
  constant POP   : UNSIGNED (7 downto 0) := "11010000";
  constant PUSH  : UNSIGNED (7 downto 0) := "11000000";
  constant RET   : UNSIGNED (7 downto 0) := "00100010";
  constant RETI  : UNSIGNED (7 downto 0) := "00110010";
  constant RL    : UNSIGNED (7 downto 0) := "00100011";
  constant RLC   : UNSIGNED (7 downto 0) := "00110011";
  constant RR    : UNSIGNED (7 downto 0) := "00000011";
  constant RRC   : UNSIGNED (7 downto 0) := "00010011";
  constant SETB_1: UNSIGNED (7 downto 0) := "11010011";
  constant SETB_2: UNSIGNED (7 downto 0) := "11010010";
  constant SJMP  : UNSIGNED (7 downto 0) := "10000000";
  constant SUBB_1: UNSIGNED (4 downto 0) := "10011";
  constant SUBB_2: UNSIGNED (7 downto 0) := "10010101";
  constant SUBB_3: UNSIGNED (6 downto 0) := "1001011";
  constant SUBB_4: UNSIGNED (7 downto 0) := "10010100";
  constant SWAP  : UNSIGNED (7 downto 0) := "11000100";
  constant XCH_1 : UNSIGNED (4 downto 0) := "11001";
  constant XCH_2 : UNSIGNED (7 downto 0) := "11000101";
  constant XCH_3 : UNSIGNED (6 downto 0) := "1100011";
  constant XCHD  : UNSIGNED (6 downto 0) := "1101011";
  constant XRL_1 : UNSIGNED (4 downto 0) := "01101";
  constant XRL_2 : UNSIGNED (7 downto 0) := "01100101";
  constant XRL_3 : UNSIGNED (6 downto 0) := "0110011";
  constant XRL_4 : UNSIGNED (7 downto 0) := "01100100";
  constant XRL_5 : UNSIGNED (7 downto 0) := "01100010";
  constant XRL_6 : UNSIGNED (7 downto 0) := "01100011";

  constant ALU_OPC_NONE  : UNSIGNED (3 downto 0) := "0000";
  constant ALU_OPC_ADD   : UNSIGNED (3 downto 0) := "0001";
  constant ALU_OPC_SUB   : UNSIGNED (3 downto 0) := "0010";
  constant ALU_OPC_MUL   : UNSIGNED (3 downto 0) := "0011";
  constant ALU_OPC_DIV   : UNSIGNED (3 downto 0) := "0100";
  constant ALU_OPC_DA    : UNSIGNED (3 downto 0) := "0101";
  constant ALU_OPC_NOT   : UNSIGNED (3 downto 0) := "0110";
  constant ALU_OPC_AND   : UNSIGNED (3 downto 0) := "0111";
  constant ALU_OPC_XOR   : UNSIGNED (3 downto 0) := "1000";
  constant ALU_OPC_OR    : UNSIGNED (3 downto 0) := "1001";
  constant ALU_OPC_RL    : UNSIGNED (3 downto 0) := "1010";
  constant ALU_OPC_RLC   : UNSIGNED (3 downto 0) := "1011";
  constant ALU_OPC_RR    : UNSIGNED (3 downto 0) := "1100";
  constant ALU_OPC_RRC   : UNSIGNED (3 downto 0) := "1101";
  constant ALU_OPC_PCSADD: UNSIGNED (3 downto 0) := "1110";
  constant ALU_OPC_PCUADD: UNSIGNED (3 downto 0) := "1111";

  constant OPC_ACALL : UNSIGNED (6 downto 0) := "0000000";
  constant OPC_ADD_1 : UNSIGNED (6 downto 0) := "0000001";
  constant OPC_ADD_2 : UNSIGNED (6 downto 0) := "0000010";
  constant OPC_ADD_3 : UNSIGNED (6 downto 0) := "0000011";
  constant OPC_ADD_4 : UNSIGNED (6 downto 0) := "0000100";
  constant OPC_ADDC_1: UNSIGNED (6 downto 0) := "0000101";
  constant OPC_ADDC_2: UNSIGNED (6 downto 0) := "0000110";
  constant OPC_ADDC_3: UNSIGNED (6 downto 0) := "0000111";
  constant OPC_ADDC_4: UNSIGNED (6 downto 0) := "0001000";
  constant OPC_AJMP  : UNSIGNED (6 downto 0) := "0001001";
  constant OPC_ANL_1 : UNSIGNED (6 downto 0) := "0001010";
  constant OPC_ANL_2 : UNSIGNED (6 downto 0) := "0001011";
  constant OPC_ANL_3 : UNSIGNED (6 downto 0) := "0001100";
  constant OPC_ANL_4 : UNSIGNED (6 downto 0) := "0001101";
  constant OPC_ANL_5 : UNSIGNED (6 downto 0) := "0001110";
  constant OPC_ANL_6 : UNSIGNED (6 downto 0) := "0001111";
  constant OPC_ANL_7 : UNSIGNED (6 downto 0) := "0010000";
  constant OPC_ANL_8 : UNSIGNED (6 downto 0) := "0010001";
  constant OPC_CJNE_1: UNSIGNED (6 downto 0) := "0010010";
  constant OPC_CJNE_2: UNSIGNED (6 downto 0) := "0010011";
  constant OPC_CJNE_3: UNSIGNED (6 downto 0) := "0010100";
  constant OPC_CJNE_4: UNSIGNED (6 downto 0) := "0010101";
  constant OPC_CLR_1 : UNSIGNED (6 downto 0) := "0010110";
  constant OPC_CLR_2 : UNSIGNED (6 downto 0) := "0010111";
  constant OPC_CLR_3 : UNSIGNED (6 downto 0) := "0011000";
  constant OPC_CPL_1 : UNSIGNED (6 downto 0) := "0011001";
  constant OPC_CPL_2 : UNSIGNED (6 downto 0) := "0011010";
  constant OPC_CPL_3 : UNSIGNED (6 downto 0) := "0011011";
  constant OPC_DA    : UNSIGNED (6 downto 0) := "0011100";
  constant OPC_DEC_1 : UNSIGNED (6 downto 0) := "0011101";
  constant OPC_DEC_2 : UNSIGNED (6 downto 0) := "0011110";
  constant OPC_DEC_3 : UNSIGNED (6 downto 0) := "0011111";
  constant OPC_DEC_4 : UNSIGNED (6 downto 0) := "0100000";
  constant OPC_DIV   : UNSIGNED (6 downto 0) := "0100001";
  constant OPC_DJNZ_1: UNSIGNED (6 downto 0) := "0100010";
  constant OPC_DJNZ_2: UNSIGNED (6 downto 0) := "0100011";
  constant OPC_INC_1 : UNSIGNED (6 downto 0) := "0100100";
  constant OPC_INC_2 : UNSIGNED (6 downto 0) := "0100101";
  constant OPC_INC_3 : UNSIGNED (6 downto 0) := "0100110";
  constant OPC_INC_4 : UNSIGNED (6 downto 0) := "0100111";
  constant OPC_INC_5 : UNSIGNED (6 downto 0) := "0101000";
  constant OPC_JB    : UNSIGNED (6 downto 0) := "0101001";
  constant OPC_JBC   : UNSIGNED (6 downto 0) := "0101010";
  constant OPC_JC    : UNSIGNED (6 downto 0) := "0101011";
  constant OPC_JMP   : UNSIGNED (6 downto 0) := "0101100";
  constant OPC_JNB   : UNSIGNED (6 downto 0) := "0101101";
  constant OPC_JNC   : UNSIGNED (6 downto 0) := "0101110";
  constant OPC_JNZ   : UNSIGNED (6 downto 0) := "0101111";
  constant OPC_JZ    : UNSIGNED (6 downto 0) := "0110000";
  constant OPC_LCALL : UNSIGNED (6 downto 0) := "0110001";
  constant OPC_LJMP  : UNSIGNED (6 downto 0) := "0110010";
  constant OPC_MOV_1 : UNSIGNED (6 downto 0) := "0110011";
  constant OPC_MOV_2 : UNSIGNED (6 downto 0) := "0110100";
  constant OPC_MOV_3 : UNSIGNED (6 downto 0) := "0110101";
  constant OPC_MOV_4 : UNSIGNED (6 downto 0) := "0110110";
  constant OPC_MOV_5 : UNSIGNED (6 downto 0) := "0110111";
  constant OPC_MOV_6 : UNSIGNED (6 downto 0) := "0111000";
  constant OPC_MOV_7 : UNSIGNED (6 downto 0) := "0111001";
  constant OPC_MOV_8 : UNSIGNED (6 downto 0) := "0111010";
  constant OPC_MOV_9 : UNSIGNED (6 downto 0) := "0111011";
  constant OPC_MOV_10: UNSIGNED (6 downto 0) := "0111100";
  constant OPC_MOV_11: UNSIGNED (6 downto 0) := "0111101";
  constant OPC_MOV_12: UNSIGNED (6 downto 0) := "0111110";
  constant OPC_MOV_13: UNSIGNED (6 downto 0) := "0111111";
  constant OPC_MOV_14: UNSIGNED (6 downto 0) := "1000000";
  constant OPC_MOV_15: UNSIGNED (6 downto 0) := "1000001";
  constant OPC_MOV_16: UNSIGNED (6 downto 0) := "1000010";
  constant OPC_MOV_17: UNSIGNED (6 downto 0) := "1000011";
  constant OPC_MOV_18: UNSIGNED (6 downto 0) := "1000100";
  constant OPC_MOVC_1: UNSIGNED (6 downto 0) := "1000101";
  constant OPC_MOVC_2: UNSIGNED (6 downto 0) := "1000110";
  constant OPC_MOVX_1: UNSIGNED (6 downto 0) := "1000111";
  constant OPC_MOVX_2: UNSIGNED (6 downto 0) := "1001000";
  constant OPC_MOVX_3: UNSIGNED (6 downto 0) := "1001001";
  constant OPC_MOVX_4: UNSIGNED (6 downto 0) := "1001010";
  constant OPC_MUL   : UNSIGNED (6 downto 0) := "1001011";
  constant OPC_NOP   : UNSIGNED (6 downto 0) := "1001100";
  constant OPC_ORL_1 : UNSIGNED (6 downto 0) := "1001101";
  constant OPC_ORL_2 : UNSIGNED (6 downto 0) := "1001110";
  constant OPC_ORL_3 : UNSIGNED (6 downto 0) := "1001111";
  constant OPC_ORL_4 : UNSIGNED (6 downto 0) := "1010000";
  constant OPC_ORL_5 : UNSIGNED (6 downto 0) := "1010001";
  constant OPC_ORL_6 : UNSIGNED (6 downto 0) := "1010010";
  constant OPC_ORL_7 : UNSIGNED (6 downto 0) := "1010011";
  constant OPC_ORL_8 : UNSIGNED (6 downto 0) := "1010100";
  constant OPC_POP   : UNSIGNED (6 downto 0) := "1010101";
  constant OPC_PUSH  : UNSIGNED (6 downto 0) := "1010110";
  constant OPC_RET   : UNSIGNED (6 downto 0) := "1010111";
  constant OPC_RETI  : UNSIGNED (6 downto 0) := "1011000";
  constant OPC_RL    : UNSIGNED (6 downto 0) := "1011001";
  constant OPC_RLC   : UNSIGNED (6 downto 0) := "1011010";
  constant OPC_RR    : UNSIGNED (6 downto 0) := "1011011";
  constant OPC_RRC   : UNSIGNED (6 downto 0) := "1011100";
  constant OPC_SETB_1: UNSIGNED (6 downto 0) := "1011101";
  constant OPC_SETB_2: UNSIGNED (6 downto 0) := "1011110";
  constant OPC_SJMP  : UNSIGNED (6 downto 0) := "1011111";
  constant OPC_SUBB_1: UNSIGNED (6 downto 0) := "1100000";
  constant OPC_SUBB_2: UNSIGNED (6 downto 0) := "1100001";
  constant OPC_SUBB_3: UNSIGNED (6 downto 0) := "1100010";
  constant OPC_SUBB_4: UNSIGNED (6 downto 0) := "1100011";
  constant OPC_SWAP  : UNSIGNED (6 downto 0) := "1100100";
  constant OPC_XCH_1 : UNSIGNED (6 downto 0) := "1100101";
  constant OPC_XCH_2 : UNSIGNED (6 downto 0) := "1100110";
  constant OPC_XCH_3 : UNSIGNED (6 downto 0) := "1100111";
  constant OPC_XCHD  : UNSIGNED (6 downto 0) := "1101000";
  constant OPC_XRL_1 : UNSIGNED (6 downto 0) := "1101001";
  constant OPC_XRL_2 : UNSIGNED (6 downto 0) := "1101010";
  constant OPC_XRL_3 : UNSIGNED (6 downto 0) := "1101011";
  constant OPC_XRL_4 : UNSIGNED (6 downto 0) := "1101100";
  constant OPC_XRL_5 : UNSIGNED (6 downto 0) := "1101101";
  constant OPC_XRL_6 : UNSIGNED (6 downto 0) := "1101110";
  constant OPC_ERROR : UNSIGNED (6 downto 0) := "1101111";
  constant OPC_NU1   : UNSIGNED (6 downto 0) := "1110000";
  constant OPC_NU2   : UNSIGNED (6 downto 0) := "1110001";
  constant OPC_NU3   : UNSIGNED (6 downto 0) := "1110010";
  constant OPC_NU4   : UNSIGNED (6 downto 0) := "1110011";
  constant OPC_NU5   : UNSIGNED (6 downto 0) := "1111100";
  constant OPC_NU6   : UNSIGNED (6 downto 0) := "1111101";
  constant OPC_NU7   : UNSIGNED (6 downto 0) := "1111110";
  constant OPC_NU8   : UNSIGNED (6 downto 0) := "1111111";
end I8052_PKG;
