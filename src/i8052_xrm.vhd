--
-- Copyright (c) Tony Givargis, 1999-2025
-- givargis@uci.edu
-- i8052_xrm.vhd
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.I8052_PKG.all;

--
-- rst     : active low
-- clk     : rising edge
-- addr    : address of XRAM being requested
-- data_in : data sent to XRAM
-- data_out: data received from XRAM
-- rd      : requesting XRAM read
-- wr      : requesting XRAM write
--

entity I8052_XRM is
  generic(storage_size: INTEGER := 2048);
  port(rst     : in  STD_LOGIC;
       clk     : in  STD_LOGIC;
       addr    : in  UNSIGNED (15 downto 0);
       data_in : in  UNSIGNED (7 downto 0);
       data_out: out UNSIGNED (7 downto 0);
       rd      : in  STD_LOGIC;
       wr      : in  STD_LOGIC);
end I8052_XRM;

architecture BEHAVIORAL of I8052_XRM is
  type XRM_TYPE is array (0 to storage_size - 1) of UNSIGNED (7 downto 0);
  signal xrm: XRM_TYPE;
begin
  process (rst, clk)
  begin
    if (rst = '1') then
      for i in 0 to storage_size - 1 loop
        xrm(i) <= CD_8;
      end loop;
      data_out <= CD_8;
    elsif (clk'event and clk = '1') then
      if (rd = '1' and conv_integer(addr) < storage_size) then
        data_out <= xrm(conv_integer(addr));
      elsif (wr = '1' and conv_integer(addr) < storage_size) then
        xrm(conv_integer(addr)) <= data_in;
      end if;
    end if;
  end process;
end BEHAVIORAL;
