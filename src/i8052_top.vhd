--
-- Copyright (c) Tony Givargis, 1999-2025
-- givargis@uci.edu
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
-- xrm_data_out: data sent to XRAM
-- xrm_data_in : data received from XRAM
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
  port(rst         : in  std_logic;
       clk         : in  std_logic;
       xrm_addr    : out unsigned (15 downto 0);
       xrm_data_out: out unsigned (7 downto 0);
       xrm_data_in : in  unsigned (7 downto 0);
       xrm_rd      : out std_logic;
       xrm_wr      : out std_logic;
       p0_in       : in  unsigned (7 downto 0);
       p0_out      : out unsigned (7 downto 0);
       p1_in       : in  unsigned (7 downto 0);
       p1_out      : out unsigned (7 downto 0);
       p2_in       : in  unsigned (7 downto 0);
       p2_out      : out unsigned (7 downto 0);
       p3_in       : in  unsigned (7 downto 0);
       p3_out      : out unsigned (7 downto 0));
end I8052_TOP;

architecture STRUCTURAL of I8052_TOP is
  signal rom_addr        : unsigned (11 downto 0);
  signal rom_data        : unsigned (7 downto 0);
  signal rom_rd          : std_logic;
  signal ram_addr        : unsigned (7 downto 0);
  signal ram_data_out    : unsigned (7 downto 0);
  signal ram_data_in     : unsigned (7 downto 0);
  signal ram_bit_data_out: std_logic;
  signal ram_bit_data_in : std_logic;
  signal ram_rd          : std_logic;
  signal ram_wr          : std_logic;
  signal ram_direct      : std_logic;
  signal ram_bitaddr     : std_logic;
  signal dec_opc_out     : unsigned (7 downto 0);
  signal dec_opc_in      : unsigned (8 downto 0);
  signal alu_opc         : unsigned (3 downto 0);
  signal alu_src_1       : unsigned (7 downto 0);
  signal alu_src_2       : unsigned (7 downto 0);
  signal alu_src_3       : unsigned (7 downto 0);
  signal alu_src_cy      : std_logic;
  signal alu_src_ac      : std_logic;
  signal alu_des_1       : unsigned (7 downto 0);
  signal alu_des_2       : unsigned (7 downto 0);
  signal alu_des_cy      : std_logic;
  signal alu_des_ac      : std_logic;
  signal alu_des_ov      : std_logic;
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
                                             ram_data_out,
                                             ram_data_in,
                                             ram_bit_data_out,
                                             ram_bit_data_in,
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
                                             ram_data_out,
                                             ram_data_in,
                                             ram_bit_data_out,
                                             ram_bit_data_in,
                                             ram_rd,
                                             ram_wr,
                                             ram_direct,
                                             ram_bitaddr,
                                             xrm_addr,
                                             xrm_data_out,
                                             xrm_data_in,
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
end STRUCTURAL;
