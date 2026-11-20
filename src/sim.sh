#!/bin/bash

nvc -a i8052_pkg.vhd
nvc -a i8052_dec.vhd
nvc -a i8052_ram.vhd
nvc -a i8052_xrm.vhd
nvc -a i8052_rom.vhd
nvc -a i8052_alu.vhd
nvc -a i8052_ctr.vhd
nvc -a i8052_top.vhd
nvc -a i8052_tsb.vhd

nvc -e i8052_tsb

nvc -r --stop-time=100000us i8052_tsb

rm -rf work
