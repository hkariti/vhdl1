-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "05/12/2018 21:47:10"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          NUM_LOCK
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY NUM_LOCK_vhd_vec_tst IS
END NUM_LOCK_vhd_vec_tst;
ARCHITECTURE NUM_LOCK_arch OF NUM_LOCK_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL break : STD_LOGIC;
SIGNAL clk : STD_LOGIC;
SIGNAL din : STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL dout : STD_LOGIC;
SIGNAL key_code : STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL make : STD_LOGIC;
SIGNAL resetN : STD_LOGIC;
COMPONENT NUM_LOCK
	PORT (
	break : IN STD_LOGIC;
	clk : IN STD_LOGIC;
	din : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
	dout : OUT STD_LOGIC;
	key_code : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
	make : IN STD_LOGIC;
	resetN : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : NUM_LOCK
	PORT MAP (
-- list connections between master ports and signals
	break => break,
	clk => clk,
	din => din,
	dout => dout,
	key_code => key_code,
	make => make,
	resetN => resetN
	);

-- resetN
t_prcs_resetN: PROCESS
BEGIN
	resetN <= '0';
	WAIT FOR 60000 ps;
	resetN <= '1';
WAIT;
END PROCESS t_prcs_resetN;

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 10000 ps;
	clk <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;

-- make
t_prcs_make: PROCESS
BEGIN
	make <= '1';
	WAIT FOR 20000 ps;
	FOR i IN 1 TO 24
	LOOP
		make <= '0';
		WAIT FOR 20000 ps;
		make <= '1';
		WAIT FOR 20000 ps;
	END LOOP;
	make <= '0';
WAIT;
END PROCESS t_prcs_make;

-- break
t_prcs_break: PROCESS
BEGIN
LOOP
	break <= '0';
	WAIT FOR 20000 ps;
	break <= '1';
	WAIT FOR 20000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_break;
-- key_code[8]
t_prcs_key_code_8: PROCESS
BEGIN
	key_code(8) <= '0';
WAIT;
END PROCESS t_prcs_key_code_8;
-- key_code[7]
t_prcs_key_code_7: PROCESS
BEGIN
	key_code(7) <= '0';
WAIT;
END PROCESS t_prcs_key_code_7;
-- key_code[6]
t_prcs_key_code_6: PROCESS
BEGIN
	key_code(6) <= '1';
WAIT;
END PROCESS t_prcs_key_code_6;
-- key_code[5]
t_prcs_key_code_5: PROCESS
BEGIN
	key_code(5) <= '1';
WAIT;
END PROCESS t_prcs_key_code_5;
-- key_code[4]
t_prcs_key_code_4: PROCESS
BEGIN
	key_code(4) <= '1';
WAIT;
END PROCESS t_prcs_key_code_4;
-- key_code[3]
t_prcs_key_code_3: PROCESS
BEGIN
	key_code(3) <= '0';
WAIT;
END PROCESS t_prcs_key_code_3;
-- key_code[2]
t_prcs_key_code_2: PROCESS
BEGIN
	key_code(2) <= '1';
WAIT;
END PROCESS t_prcs_key_code_2;
-- key_code[1]
t_prcs_key_code_1: PROCESS
BEGIN
	key_code(1) <= '1';
WAIT;
END PROCESS t_prcs_key_code_1;
-- key_code[0]
t_prcs_key_code_0: PROCESS
BEGIN
	key_code(0) <= '1';
WAIT;
END PROCESS t_prcs_key_code_0;
-- din[8]
t_prcs_din_8: PROCESS
BEGIN
	din(8) <= '0';
WAIT;
END PROCESS t_prcs_din_8;
-- din[7]
t_prcs_din_7: PROCESS
BEGIN
	din(7) <= '0';
WAIT;
END PROCESS t_prcs_din_7;
-- din[6]
t_prcs_din_6: PROCESS
BEGIN
	din(6) <= '1';
	WAIT FOR 640000 ps;
	din(6) <= '0';
	WAIT FOR 350000 ps;
	din(6) <= '1';
WAIT;
END PROCESS t_prcs_din_6;
-- din[5]
t_prcs_din_5: PROCESS
BEGIN
	din(5) <= '1';
	WAIT FOR 640000 ps;
	din(5) <= '0';
	WAIT FOR 350000 ps;
	din(5) <= '1';
WAIT;
END PROCESS t_prcs_din_5;
-- din[4]
t_prcs_din_4: PROCESS
BEGIN
	din(4) <= '1';
	WAIT FOR 640000 ps;
	din(4) <= '0';
	WAIT FOR 350000 ps;
	din(4) <= '1';
WAIT;
END PROCESS t_prcs_din_4;
-- din[3]
t_prcs_din_3: PROCESS
BEGIN
	din(3) <= '0';
WAIT;
END PROCESS t_prcs_din_3;
-- din[2]
t_prcs_din_2: PROCESS
BEGIN
	din(2) <= '1';
	WAIT FOR 640000 ps;
	din(2) <= '0';
	WAIT FOR 350000 ps;
	din(2) <= '1';
WAIT;
END PROCESS t_prcs_din_2;
-- din[1]
t_prcs_din_1: PROCESS
BEGIN
	din(1) <= '1';
	WAIT FOR 640000 ps;
	din(1) <= '0';
	WAIT FOR 350000 ps;
	din(1) <= '1';
WAIT;
END PROCESS t_prcs_din_1;
-- din[0]
t_prcs_din_0: PROCESS
BEGIN
	din(0) <= '1';
	WAIT FOR 640000 ps;
	din(0) <= '0';
	WAIT FOR 350000 ps;
	din(0) <= '1';
WAIT;
END PROCESS t_prcs_din_0;
END NUM_LOCK_arch;
