//
// Copyright (c) Tony Givargis, 1999-2025
// givargis@uci.edu
// mkrom.c
//

#include <assert.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <time.h>

struct inst_form {
	const char *name;
	int msb, lsb, skip;
};

extern const char * const INST_BIT_TBL[];
extern const struct inst_form INST_FORM_TBL[];

static int
hex2int(const char *s)
{
	unsigned i;

	if ((1 != sscanf(s, "%x", &i)) || (0xffff < i)) {
		return -1;
	}
	return (int)i;
}

static int
load(const char *line, uint8_t *rom, int rom_size, int *prg_size)
{
	int type, len, base;
	uint8_t checksum;
	char hex[5];

	// validate

	if ((0 == (strlen(line) % 2)) ||
	    (11 > strlen(line)) ||
	    (':' != line[0])) {
		fprintf(stderr, "invalid line\n");
		return -1;
	}

	// checksum

	checksum = 0;
	for (int i=0; i<((int)strlen(line) / 2); i++) {
		hex[0] = line[i * 2 + 1];
		hex[1] = line[i * 2 + 2];
		hex[2] = '\0';
		if (0 > hex2int(hex)) {
			fprintf(stderr, "invalid checksum\n");
			return -1;
		}
		checksum += (uint8_t)hex2int(hex);
	}
	if (0 != checksum) {
		fprintf(stderr, "invalid checksum\n");
		return -1;
	}

	// len, base, type

	hex[0] = line[1];
	hex[1] = line[2];
	hex[2] = '\0';
	len = hex2int(hex);
	hex[0] = line[3];
	hex[1] = line[4];
	hex[2] = line[5];
	hex[3] = line[6];
	hex[4] = '\0';
	base = hex2int(hex);
	hex[0] = line[7];
	hex[1] = line[8];
	hex[2] = '\0';
	type = hex2int(hex);

	// type?

	if (1 == type) {
		return 1; /* EOF */
	}
	if (2 == type) {
		fprintf(stderr, "extended machine code not supported\n");
		return -1;
	}
	if (0 != type) {
		fprintf(stderr, "invalid type\n");
		return -1;
	}

	// size?

	if ((base + len) > (*prg_size)) {
		(*prg_size) = base + len + 2;
	}
	if (((*prg_size) >= rom_size) || ((base + len) >= rom_size)) {
		fprintf(stderr, "program too large");
		return -1;
	}

	// code

	for (int i=0; i<len; i++) {
		hex[0] = line[i * 2 +  9];
		hex[1] = line[i * 2 + 10];
		hex[2] = '\0';
		rom[base + i] = (uint8_t)hex2int(hex);
	}
	return 0;
}

static int
match(const char *binary, int msb, int lsb, const char *bit)
{
	char buf[16];

	strcpy(buf, &binary[7-msb]);
	buf[8-lsb] = 0;
	return strcmp(bit, buf) ? 0 : 1;
}

static char *
comment(const char *binary, int pos)
{
	static char buf[64];
	static int skip;

	if (skip == 0) {
		for (int i=0; i<111; i++) {
			if (match(binary,
				  INST_FORM_TBL[i].msb,
				  INST_FORM_TBL[i].lsb,
				  INST_BIT_TBL[i])) {
				sprintf(buf,
					"  -- %05d: %s",
					pos,
					INST_FORM_TBL[i].name);
				skip = INST_FORM_TBL[i].skip;
				return buf;
			}
		}
	}
	else {
		skip--;
	}
	return "";
}

static char *
conv_binary(uint8_t b)
{
	static char buf[9];

	for (int i=0; i<8; i++) {
		buf[i] = b & (0x80 >> i) ? '1' : '0';
	}
	buf[8] = '\0';
	return buf;
}

static int
output(uint8_t *rom, int prg_size, const char *pathname)
{
	const char * const HEADER =
		"-- %s\n"
		"-- %s\n"
		"library IEEE;\n"
		"use IEEE.STD_LOGIC_1164.all;\n"
		"use IEEE.STD_LOGIC_ARITH.all;\n"
		"\n"
		"use WORK.I8052_PKG.all;\n"
		"\n"
		"entity I8052_ROM is\n"
		"  port(rst : in  STD_LOGIC;\n"
		"       clk : in  STD_LOGIC;\n"
		"       addr: in  UNSIGNED (11 downto 0);\n"
		"       data: out UNSIGNED (7 downto 0);\n"
		"       rd  : in  STD_LOGIC);\n"
		"end I8052_ROM;\n"
		"\n"
		"architecture BEHAVIORAL of I8052_ROM is\n"
		"  type ROM_TYPE is array (0 to %d) of UNSIGNED (7 downto 0);"
		"\n"
		"  constant PROGRAM : ROM_TYPE := (\n";
	const char * const FOOTER =
		"    \"%s\" %s\n"
		"  );\n"
		"begin\n"
		"  process (rst, clk)\n"
		"  begin\n"
		"    if (rst = '1') then\n"
		"      data <= CD_8;\n"
		"    elsif (clk'event and clk = '1') then\n"
		"      if (rd = '1' and conv_integer(addr) < %d) then\n"
		"        data <= PROGRAM(conv_integer(addr));\n"
		"      else\n"
		"        data <= CD_8;\n"
		"      end if;\n"
		"    end if;\n"
		"  end process;\n"
		"end BEHAVIORAL;\n";
	char *binary;
	FILE* file;
	time_t tm;

	tm = time(NULL);
	if (!(file = fopen("i8052_rom.vhd", "w"))) {
		fprintf(stderr, "file open\n");
		return -1;
	}
	if (0 > fprintf(file, HEADER, pathname, ctime(&tm), prg_size - 1)) {
		fclose(file);
		fprintf(stderr, "file write\n");
		return -1;
	}
	for (int i=0; i<(prg_size - 1); i++) {
		binary = conv_binary(rom[i]);
		if (0 > fprintf(file,
				"    \"%s\",%s\n",
				binary,
				comment(binary, i))) {
			fclose(file);
			fprintf(stderr, "file write\n");
			return -1;
		}
	}
	binary = conv_binary(rom[prg_size - 1]);
	if (0 > fprintf(file,
			FOOTER,
			binary, comment(binary, prg_size - 1),
			prg_size)) {
		fclose(file);
		fprintf(stderr, "file write\n");
		return -1;
	}
	fclose(file);
	return 0;
}

int
main(int argc, char *argv[])
{
	uint8_t rom[4096];
	char line[256];
	int prg_size;
	FILE *file;
	int e;

	prg_size = 0;
	memset(rom, 0, sizeof (rom));
	if (argc != 2) {
		fprintf(stderr, "usage: %s hexfile\n", argv[0]);
		return -1;
	}
	if (!(file = fopen(argv[1], "r"))) {
		fprintf(stderr, "file open error\n");
		return -1;
	}
	while (!feof(file)) {
		if (!fgets(line, sizeof (line), file)) {
			fclose(file);
			fprintf(stderr, "file read error\n");
			return -1;
		}
		while (strlen(line) &&
		       (('\n' == line[strlen(line) - 1]) ||
			('\r' == line[strlen(line) - 1]))) {
			line[strlen(line) - 1] = '\0';
		}
		if ((e = load(line, rom, sizeof (rom), &prg_size))) {
			if (0 > e) {
				fclose(file);
				fprintf(stderr, "load error\n");
				return -1;
			}
			break;
		}
	}
	fclose(file);
	if (output(rom, prg_size, argv[1])) {
		fprintf(stderr, "output error\n");
		return -1;
	}
	return 0;
}

const char * const INST_BIT_TBL[] = {
	"10001",
	"00101",
	"00100101",
	"0010011",
	"00100100",
	"00111",
	"00110101",
	"0011011",
	"00110100",
	"00001",
	"01011",
	"01010101",
	"0101011",
	"01010100",
	"01010010",
	"01010011",
	"10000010",
	"10110000",
	"10110101",
	"10110100",
	"10111",
	"1011011",
	"11100100",
	"11000011",
	"11000010",
	"11110100",
	"10110011",
	"10110010",
	"11010100",
	"00010100",
	"00011",
	"00010101",
	"0001011",
	"10000100",
	"11011",
	"11010101",
	"00000100",
	"00001",
	"00000101",
	"0000011",
	"10100011",
	"00100000",
	"00010000",
	"01000000",
	"01110011",
	"00110000",
	"01010000",
	"01110000",
	"01100000",
	"00010010",
	"00000010",
	"11101",
	"11100101",
	"1110011",
	"01110100",
	"11111",
	"10101",
	"01111",
	"11110101",
	"10001",
	"10000101",
	"1000011",
	"01110101",
	"1111011",
	"1010011",
	"0111011",
	"10100010",
	"10010010",
	"10010000",
	"10010011",
	"10000011",
	"1110001",
	"11100000",
	"1111001",
	"11110000",
	"10100100",
	"00000000",
	"01001",
	"01000101",
	"0100011",
	"01000100",
	"01000010",
	"01000011",
	"01110010",
	"10100000",
	"11010000",
	"11000000",
	"00100010",
	"00110010",
	"00100011",
	"00110011",
	"00000011",
	"00010011",
	"11010011",
	"11010010",
	"10000000",
	"10011",
	"10010101",
	"1001011",
	"10010100",
	"11000100",
	"11001",
	"11000101",
	"1100011",
	"1101011",
	"01101",
	"01100101",
	"0110011",
	"01100100",
	"01100010",
	"01100011",
};

const struct inst_form INST_FORM_TBL[] = {
	{ "ACALL",  4, 0, 1 },
	{ "ADD_1",  7, 3, 0 },
	{ "ADD_2",  7, 0, 1 },
	{ "ADD_3",  7, 1, 0 },
	{ "ADD_4",  7, 0, 1 },
	{ "ADDC_1", 7, 3, 0 },
	{ "ADDC_2", 7, 0, 1 },
	{ "ADDC_3", 7, 1, 0 },
	{ "ADDC_4", 7, 0, 1 },
	{ "AJMP",   4, 0, 1 },
	{ "ANL_1",  7, 3, 0 },
	{ "ANL_2",  7, 0, 1 },
	{ "ANL_3",  7, 1, 0 },
	{ "ANL_4",  7, 0, 1 },
	{ "ANL_5",  7, 0, 1 },
	{ "ANL_6",  7, 0, 2 },
	{ "ANL_7",  7, 0, 1 },
	{ "ANL_8",  7, 0, 1 },
	{ "CJNE_1", 7, 0, 2 },
	{ "CJNE_2", 7, 0, 2 },
	{ "CJNE_3", 7, 3, 2 },
	{ "CJNE_4", 7, 1, 2 },
	{ "CLR_1",  7, 0, 0 },
	{ "CLR_2",  7, 0, 0 },
	{ "CLR_3",  7, 0, 1 },
	{ "CPL_1",  7, 0, 0 },
	{ "CPL_2",  7, 0, 0 },
	{ "CPL_3",  7, 0, 1 },
	{ "DA", 7,  0, 0 },
	{ "DEC_1",  7, 0, 0 },
	{ "DEC_2",  7, 3, 0 },
	{ "DEC_3",  7, 0, 1 },
	{ "DEC_4",  7, 1, 0 },
	{ "DIV",    7, 0, 0 },
	{ "DJNZ_1", 7, 3, 1 },
	{ "DJNZ_2", 7, 0, 2 },
	{ "INC_1",  7, 0, 0 },
	{ "INC_2",  7, 3, 0 },
	{ "INC_3",  7, 0, 1 },
	{ "INC_4",  7, 1, 0 },
	{ "INC_5",  7, 0, 0 },
	{ "JB",     7, 0, 2 },
	{ "JBC",    7, 0, 2 },
	{ "JC",     7, 0, 1 },
	{ "JMP",    7, 0, 0 },
	{ "JNB",    7, 0, 2 },
	{ "JNC",    7, 0, 1 },
	{ "JNZ",    7, 0, 1 },
	{ "JZ",     7, 0, 1 },
	{ "LCALL",  7, 0, 2 },
	{ "LJMP",   7, 0, 2 },
	{ "MOV_1",  7, 3, 0 },
	{ "MOV_2",  7, 0, 1 },
	{ "MOV_3",  7, 1, 0 },
	{ "MOV_4",  7, 0, 1 },
	{ "MOV_5",  7, 3, 0 },
	{ "MOV_6",  7, 3, 1 },
	{ "MOV_7",  7, 3, 1 },
	{ "MOV_8",  7, 0, 1 },
	{ "MOV_9",  7, 3, 1 },
	{ "MOV_10", 7, 0, 2 },
	{ "MOV_11", 7, 1, 1 },
	{ "MOV_12", 7, 0, 2 },
	{ "MOV_13", 7, 1, 0 },
	{ "MOV_14", 7, 1, 1 },
	{ "MOV_15", 7, 1, 1 },
	{ "MOV_16", 7, 0, 1 },
	{ "MOV_17", 7, 0, 1 },
	{ "MOV_18", 7, 0, 2 },
	{ "MOVC_1", 7, 0, 0 },
	{ "MOVC_2", 7, 0, 0 },
	{ "MOVX_1", 7, 1, 0 },
	{ "MOVX_2", 7, 0, 0 },
	{ "MOVX_3", 7, 1, 0 },
	{ "MOVX_4", 7, 0, 0 },
	{ "MUL",    7, 0, 0 },
	{ "NOP",    7, 0, 0 },
	{ "ORL_1",  7, 3, 0 },
	{ "ORL_2",  7, 0, 1 },
	{ "ORL_3",  7, 1, 0 },
	{ "ORL_4",  7, 0, 1 },
	{ "ORL_5",  7, 0, 1 },
	{ "ORL_6",  7, 0, 2 },
	{ "ORL_7",  7, 0, 1 },
	{ "ORL_8",  7, 0, 1 },
	{ "POP",    7, 0, 1 },
	{ "PUSH",   7, 0, 1 },
	{ "RET",    7, 0, 0 },
	{ "RETI",   7, 0, 0 },
	{ "RL",     7, 0, 0 },
	{ "RLC",    7, 0, 0 },
	{ "RR",     7, 0, 0 },
	{ "RRC",    7, 0, 0 },
	{ "SETB_1", 7, 0, 0 },
	{ "SETB_2", 7, 0, 1 },
	{ "SJMP",   7, 0, 1 },
	{ "SUBB_1", 7, 3, 0 },
	{ "SUBB_2", 7, 0, 1 },
	{ "SUBB_3", 7, 1, 0 },
	{ "SUBB_4", 7, 0, 1 },
	{ "SWAP",   7, 0, 0 },
	{ "XCH_1",  7, 3, 0 },
	{ "XCH_2",  7, 0, 1 },
	{ "XCH_3",  7, 1, 0 },
	{ "XCHD",   7, 1, 0 },
	{ "XRL_1",  7, 3, 0 },
	{ "XRL_2",  7, 0, 1 },
	{ "XRL_3",  7, 1, 0 },
	{ "XRL_4",  7, 0, 1 },
	{ "XRL_5",  7, 0, 1 },
	{ "XRL_6",  7, 0, 2 }
};
