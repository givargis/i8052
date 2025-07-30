--
-- Copyright (c) Tony Givargis, 1999-2025
-- givargis@uci.edu
-- i8052_ram.vhd
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

use WORK.I8052_PKG.all;

--
-- rst         : active high
-- clk         : rising edge
-- addr        : address of RAM/REG being requested
-- data_in     : data sent to RAM/REG
-- data_out    : data received from RAM/REG
-- bit_data_in : bit-data sent to RAM/REG
-- bit_data_out: bit-data received from RAM/REG
-- rd          : requesting RAM/REG read
-- wr          : requesting RAM/REG write
-- direct      : requesting direct RAM/REG data/bit-data
-- bitaddr     : requesting a RAM/REG bit-data
-- p0_in       : port 0's input
-- p0_out      : port 0's output
-- p1_in       : port 1's input
-- p1_out      : port 1's output
-- p2_in       : port 2's input
-- p2_out      : port 2's output
-- p3_in       : port 3's input
-- p3_out      : port 3's output
--

entity I8052_RAM is
  port(rst         : in  STD_LOGIC;
       clk         : in  STD_LOGIC;
       addr        : in  UNSIGNED (7 downto 0);
       data_in     : in  UNSIGNED (7 downto 0);
       data_out    : out UNSIGNED (7 downto 0);
       bit_data_in : in  STD_LOGIC;
       bit_data_out: out STD_LOGIC;
       rd          : in  STD_LOGIC;
       wr          : in  STD_LOGIC;
       direct      : in  STD_LOGIC;
       bitaddr     : in  STD_LOGIC;
       p0_in       : in  UNSIGNED (7 downto 0);
       p0_out      : out UNSIGNED (7 downto 0);
       p1_in       : in  UNSIGNED (7 downto 0);
       p1_out      : out UNSIGNED (7 downto 0);
       p2_in       : in  UNSIGNED (7 downto 0);
       p2_out      : out UNSIGNED (7 downto 0);
       p3_in       : in  UNSIGNED (7 downto 0);
       p3_out      : out UNSIGNED (7 downto 0));
end I8052_RAM;

architecture BEHAVIORAL of I8052_RAM is
  type RAM_TYPE is array (0 to 255) of UNSIGNED (7 downto 0);
  signal ram: RAM_TYPE;
  signal sfr_sp  : UNSIGNED (7 downto 0);
  signal sfr_dpl : UNSIGNED (7 downto 0);
  signal sfr_dph : UNSIGNED (7 downto 0);
  signal sfr_pcon: UNSIGNED (7 downto 0);
  signal sfr_tcon: UNSIGNED (7 downto 0);
  signal sfr_tmod: UNSIGNED (7 downto 0);
  signal sfr_tl0 : UNSIGNED (7 downto 0);
  signal sfr_tl1 : UNSIGNED (7 downto 0);
  signal sfr_th0 : UNSIGNED (7 downto 0);
  signal sfr_th1 : UNSIGNED (7 downto 0);
  signal sfr_scon: UNSIGNED (7 downto 0);
  signal sfr_sbuf: UNSIGNED (7 downto 0);
  signal sfr_ie  : UNSIGNED (7 downto 0);
  signal sfr_ip  : UNSIGNED (7 downto 0);
  signal sfr_psw : UNSIGNED (7 downto 0);
  signal sfr_a   : UNSIGNED (7 downto 0);
  signal sfr_b   : UNSIGNED (7 downto 0);
begin
  process (rst, clk)
    procedure GET_BYTE (a: in  UNSIGNED (7 downto 0);
                        v: out UNSIGNED (7 downto 0);
                        d: in  STD_LOGIC) is
    begin
      if (d = '1' and a(7) = '1') then
        case a is
          when R_P0   => v := p0_in;
          when R_P1   => v := p1_in;
          when R_P2   => v := p2_in;
          when R_P3   => v := p3_in;
          when R_SP   => v := sfr_sp;
          when R_DPL  => v := sfr_dpl;
          when R_DPH  => v := sfr_dph;
          when R_PCON => v := sfr_pcon;
          when R_TCON => v := sfr_tcon;
          when R_TMOD => v := sfr_tmod;
          when R_TL0  => v := sfr_tl0;
          when R_TL1  => v := sfr_tl1;
          when R_TH0  => v := sfr_th0;
          when R_TH1  => v := sfr_th1;
          when R_SCON => v := sfr_scon;
          when R_SBUF => v := sfr_sbuf;
          when R_IE   => v := sfr_ie;
          when R_IP   => v := sfr_ip;
          when R_PSW  => v := sfr_psw;
          when R_A    => v := sfr_a;
          when R_B    => v := sfr_b;
          when others => v := CD_8;
        end case;
      else
        v := ram(conv_integer(a));
      end if;
    end GET_BYTE;

    procedure SET_BYTE (a: in UNSIGNED (7 downto 0);
                        v: in UNSIGNED (7 downto 0);
                        d: in STD_LOGIC) is
    begin
      if (d = '1' and a(7) = '1') then
        case a is
          when R_P0   => p0_out <= v;
          when R_P1   => p1_out <= v;
          when R_P2   => p2_out <= v;
          when R_P3   => p3_out <= v;
          when R_SP   => sfr_sp <= v;
          when R_DPL  => sfr_dpl <= v;
          when R_DPH  => sfr_dph <= v;
          when R_PCON => sfr_pcon <= v;
          when R_TCON => sfr_tcon <= v;
          when R_TMOD => sfr_tmod <= v;
          when R_TL0  => sfr_tl0 <= v;
          when R_TL1  => sfr_tl1 <= v;
          when R_TH0  => sfr_th0 <= v;
          when R_TH1  => sfr_th1 <= v;
          when R_SCON => sfr_scon <= v;
          when R_SBUF => sfr_sbuf <= v;
          when R_IE   => sfr_ie <= v;
          when R_IP   => sfr_ip <= v;
          when R_PSW  => sfr_psw <= v;
          when R_A    => sfr_a <= v;
          when R_B    => sfr_b <= v;
          when others => null;
        end case;
      else
        ram(conv_integer(a)) <= v;
      end if;
    end SET_BYTE;

    procedure GET_BIT (a: in  UNSIGNED (7 downto 0);
                       v: out STD_LOGIC;
                       d: in  STD_LOGIC) is
      variable t: UNSIGNED (7 downto 0);
      variable i, j: INTEGER;
    begin
      j := conv_integer(a(2 downto 0));
      if (d = '1' and a(7) = '1') then
        t := a(7 downto 3) & "000";
        case t is
          when R_P0   => v := p0_in(j);
          when R_P1   => v := p1_in(j);
          when R_P2   => v := p2_in(j);
          when R_P3   => v := p3_in(j);
          when R_TCON => v := sfr_tcon(j);
          when R_SCON => v := sfr_scon(j);
          when R_IE   => v := sfr_ie(j);
          when R_IP   => v := sfr_ip(j);
          when R_PSW  => v := sfr_psw(j);
          when R_A    => v := sfr_a(j);
          when R_B    => v := sfr_b(j);
          when others => v := '-';
        end case;
      else
        i := conv_integer("0010" & a(6 downto 3));
        v := ram(i)(j);
      end if;
    end GET_BIT;

    procedure SET_BIT (a: in UNSIGNED (7 downto 0);
                       v: in STD_LOGIC;
                       d: in STD_LOGIC) is
      variable t: UNSIGNED (7 downto 0);
      variable i, j: INTEGER;
    begin
      j := conv_integer(a(2 downto 0));
      if (d = '1' and a(7) = '1') then
        t := a(7 downto 3) & "000";
        case t is
          when R_P0   => p0_out(j) <= v;
          when R_P1   => p1_out(j) <= v;
          when R_P2   => p2_out(j) <= v;
          when R_P3   => p3_out(j) <= v;
          when R_TCON => sfr_tcon(j) <= v;
          when R_SCON => sfr_scon(j) <= v;
          when R_IE   => sfr_ie(j) <= v;
          when R_IP   => sfr_ip(j) <= v;
          when R_PSW  => sfr_psw(j) <= v;
          when R_A    => sfr_a(j) <= v;
          when R_B    => sfr_b(j) <= v;
          when others => null;
        end case;
      else
        i := conv_integer("0010" & a(6 downto 3));
        ram(i)(j) <= v;
      end if;
    end SET_BIT;

    variable v8: UNSIGNED (7 downto 0);
    variable v1: STD_LOGIC;
  begin
    if (rst = '1') then
      for i in 0 to 255 loop
        ram(i) <= CD_8;
      end loop;
      sfr_sp <= C0_8;
      sfr_dpl <= C0_8;
      sfr_dph <= C0_8;
      sfr_pcon <= C0_8;
      sfr_tcon <= C0_8;
      sfr_tmod <= C0_8;
      sfr_tl0 <= C0_8;
      sfr_tl1 <= C0_8;
      sfr_th0 <= C0_8;
      sfr_th1 <= C0_8;
      sfr_scon <= C0_8;
      sfr_sbuf <= C0_8;
      sfr_ie <= C0_8;
      sfr_ip <= C0_8;
      sfr_psw <= C0_8;
      sfr_a <= C0_8;
      sfr_b <= C0_8;
      p0_out <= CM_8;
      p1_out <= CM_8;
      p2_out <= CM_8;
      p3_out <= CM_8;
      data_out <= CD_8;
      bit_data_out <= '-';
    elsif (clk'event and clk = '1') then
      if (rd = '1') then
        if (bitaddr = '1') then
          GET_BIT(addr, v1, direct);
          bit_data_out <= v1;
        else
          GET_BYTE(addr, v8, direct);
          data_out <= v8;
        end if;
      elsif (wr = '1') then
        if (bitaddr = '1') then
          SET_BIT(addr, bit_data_in, direct);
        else
          SET_BYTE(addr, data_in, direct);
        end if;
      end if;
    end if;
  end process;
end BEHAVIORAL;
