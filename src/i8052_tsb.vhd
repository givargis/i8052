--
-- Copyright (c) Tony Givargis, 1999-2025
-- givargis@uci.edu
-- i8052_tsb.vhd
--

library IEEE;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.I8052_PKG.all;

entity I8052_TSB is
end I8052_TSB;

architecture BEHAVIORAL of I8052_TSB is
  signal rst     : STD_LOGIC := '1';
  signal clk     : STD_LOGIC := '0';
  signal addr    : UNSIGNED (15 downto 0);
  signal data_out: UNSIGNED (7 downto 0);
  signal data_in : UNSIGNED (7 downto 0);
  signal rd      : STD_LOGIC;
  signal wr      : STD_LOGIC;
  signal p0_in   : UNSIGNED (7 downto 0);
  signal p0_out  : UNSIGNED (7 downto 0);
  signal p1_in   : UNSIGNED (7 downto 0);
  signal p1_out  : UNSIGNED (7 downto 0);
  signal p2_in   : UNSIGNED (7 downto 0);
  signal p2_out  : UNSIGNED (7 downto 0);
  signal p3_in   : UNSIGNED (7 downto 0);
  signal p3_out  : UNSIGNED (7 downto 0);
begin
  rst <= '0' after 50 ns;
  clk <= not clk after 25 ns;
  I8052_TOP: entity WORK.I8052_TOP port map (rst,
                                             clk,
                                             addr,
                                             data_out,
                                             data_in,
                                             rd,
                                             wr,
                                             p0_in,
                                             p0_out,
                                             p1_in,
                                             p1_out,
                                             p2_in,
                                             p2_out,
                                             p3_in,
                                             p3_out);
  I8052_XRM: entity WORK.I8052_XRM port map (rst,
                                             clk,
                                             addr,
                                             data_out,
                                             data_in,
                                             rd,
                                             wr);
  process (p0_out, p1_out, p2_out, p3_out)
    variable l: LINE;
  begin
    write(l, TO_STRING(p0_out), LEFT, 10);
    write(l, TO_STRING(p1_out), LEFT, 10);
    write(l, TO_STRING(p2_out), LEFT, 10);
    write(l, TO_STRING(p3_out), LEFT, 10);
    writeline(output, l);
  end process;
end BEHAVIORAL;
