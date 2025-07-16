--
-- Copyright (c) Tony Givargis, 1999-2025
--
-- i8052_top.vhd
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.I8052_PKG.all;

--
-- rst         : active high
-- clk         : rising edge
-- xrm_addr    : address of XRAM being requested
-- xrm_out_data: data sent to XRAM
-- xrm_in_data : data received from XRAM
-- xrm_rd      : requesting XRAM read
-- xrm_wr      : requesting XRAM write
-- p0_in       : port 0's input
-- p0_out      : port 0's output
-- p1_in       : port 1's input
-- p1_out      : port 1's output
-- p2_in       : port 2's input
-- p2_out      : port 2's output
-- p3_in       : port 3's input
-- p3_out      : port 3's output
--

entity I8052_TOP is
  port(rst         : in  STD_LOGIC;
       clk         : in  STD_LOGIC;
       xrm_addr    : out UNSIGNED (15 downto 0);
       xrm_out_data: out UNSIGNED (7 downto 0);
       xrm_in_data : in  UNSIGNED (7 downto 0);
       xrm_rd      : out STD_LOGIC;
       xrm_wr      : out STD_LOGIC;
       p0_in       : in  UNSIGNED (7 downto 0);
       p0_out      : out UNSIGNED (7 downto 0);
       p1_in       : in  UNSIGNED (7 downto 0);
       p1_out      : out UNSIGNED (7 downto 0);
       p2_in       : in  UNSIGNED (7 downto 0);
       p2_out      : out UNSIGNED (7 downto 0);
       p3_in       : in  UNSIGNED (7 downto 0);
       p3_out      : out UNSIGNED (7 downto 0));
end I8052_TOP;

architecture STRUCTURAL of I8052_TOP is
  signal rom_addr        : UNSIGNED (11 downto 0);
  signal rom_data        : UNSIGNED (7 downto 0);
  signal rom_rd          : STD_LOGIC;
  signal ram_addr        : UNSIGNED (7 downto 0);
  signal ram_out_data    : UNSIGNED (7 downto 0);
  signal ram_in_data     : UNSIGNED (7 downto 0);
  signal ram_out_bit_data: STD_LOGIC;
  signal ram_in_bit_data : STD_LOGIC;
  signal ram_rd          : STD_LOGIC;
  signal ram_wr          : STD_LOGIC;
  signal ram_direct      : STD_LOGIC;
  signal ram_bitaddr     : STD_LOGIC;
  signal dec_opc_out     : UNSIGNED (7 downto 0);
  signal dec_opc_in      : UNSIGNED (8 downto 0);
  signal alu_opc         : UNSIGNED (3 downto 0);
  signal alu_src_1       : UNSIGNED (7 downto 0);
  signal alu_src_2       : UNSIGNED (7 downto 0);
  signal alu_src_3       : UNSIGNED (7 downto 0);
  signal alu_src_cy      : STD_LOGIC;
  signal alu_src_ac      : STD_LOGIC;
  signal alu_des_1       : UNSIGNED (7 downto 0);
  signal alu_des_2       : UNSIGNED (7 downto 0);
  signal alu_des_cy      : STD_LOGIC;
  signal alu_des_ac      : STD_LOGIC;
  signal alu_des_ov      : STD_LOGIC;
begin
  I8052_ALU: entity WORK.I8052_ALU port map (rst,
                                             alu_opc,
                                             alu_src_1,
                                             alu_src_2,
                                             alu_src_3,
                                             alu_src_cy,
                                             alu_src_ac,
                                             alu_des_1,
                                             alu_des_2,
                                             alu_des_cy,
                                             alu_des_ac,
                                             alu_des_ov);
  I8052_DEC: entity WORK.I8052_DEC port map (rst,
                                             dec_opc_out,
                                             dec_opc_in);
  I8052_RAM: entity WORK.I8052_RAM port map (rst,
                                             clk,
                                             ram_addr,
                                             ram_out_data,
                                             ram_in_data,
                                             ram_out_bit_data,
                                             ram_in_bit_data,
                                             ram_rd,
                                             ram_wr,
                                             ram_direct,
                                             ram_bitaddr,
                                             p0_in,
                                             p0_out,
                                             p1_in,
                                             p1_out,
                                             p2_in,
                                             p2_out,
                                             p3_in,
                                             p3_out);
  I8052_ROM: entity WORK.I8052_ROM port map (rst,
                                             clk,
                                             rom_addr,
                                             rom_data,
                                             rom_rd);
  I8052_CTR: entity WORK.I8052_CTR port map (rst,
                                             clk,
                                             rom_addr,
                                             rom_data,
                                             rom_rd,
                                             ram_addr,
                                             ram_out_data,
                                             ram_in_data,
                                             ram_out_bit_data,
                                             ram_in_bit_data,
                                             ram_rd,
                                             ram_wr,
                                             ram_direct,
                                             ram_bitaddr,
                                             xrm_addr,
                                             xrm_out_data,
                                             xrm_in_data,
                                             xrm_rd,
                                             xrm_wr,
                                             dec_opc_out,
                                             dec_opc_in,
                                             alu_opc,
                                             alu_src_1,
                                             alu_src_2,
                                             alu_src_3,
                                             alu_src_cy,
                                             alu_src_ac,
                                             alu_des_1,
                                             alu_des_2,
                                             alu_des_cy,
                                             alu_des_ac,
                                             alu_des_ov);
  I8052_DBG: entity WORK.I8052_DBG port map (dec_opc_in);
end STRUCTURAL;
