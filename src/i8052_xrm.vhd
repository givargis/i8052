--
-- Copyright (c) Tony Givargis, 1999-2025
--
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
-- in_data : data sent to XRAM
-- out_data: data received from XRAM
-- rd      : requesting XRAM read
-- wr      : requesting XRAM write
--

entity I8052_XRM is
  generic(storage_size: INTEGER := 2048);
  port(rst     : in  STD_LOGIC;
       clk     : in  STD_LOGIC;
       addr    : in  UNSIGNED (15 downto 0);
       in_data : in  UNSIGNED (7 downto 0);
       out_data: out UNSIGNED (7 downto 0);
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
      out_data <= CD_8;
    elsif (clk'event and clk = '1') then
      if (rd = '1' and conv_integer(addr) < storage_size) then
        out_data <= xrm(conv_integer(addr));
      elsif (wr = '1' and conv_integer(addr) < storage_size) then
        xrm(conv_integer(addr)) <= in_data;
      end if;
    end if;
  end process;
end BEHAVIORAL;
