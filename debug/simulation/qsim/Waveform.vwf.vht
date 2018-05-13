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
-- Generated on "05/12/2018 17:03:33"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          bitrec
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY bitrec_vhd_vec_tst IS
END bitrec_vhd_vec_tst;
ARCHITECTURE bitrec_arch OF bitrec_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL dout : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL dout_new : STD_LOGIC;
SIGNAL kbd_clk : STD_LOGIC;
SIGNAL kbd_dat : STD_LOGIC;
SIGNAL resetN : STD_LOGIC;
COMPONENT bitrec
	PORT (
	clk : IN STD_LOGIC;
	dout : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
	dout_new : BUFFER STD_LOGIC;
	kbd_clk : IN STD_LOGIC;
	kbd_dat : IN STD_LOGIC;
	resetN : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : bitrec
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	dout => dout,
	dout_new => dout_new,
	kbd_clk => kbd_clk,
	kbd_dat => kbd_dat,
	resetN => resetN
	);

-- resetN
t_prcs_resetN: PROCESS
BEGIN
	resetN <= '0';
	WAIT FOR 10000 ps;
	resetN <= '1';
WAIT;
END PROCESS t_prcs_resetN;

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 5000 ps;
	clk <= '1';
	WAIT FOR 5000 ps;
	IF (NOW >= 1300000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;

-- kbd_clk
t_prcs_kbd_clk: PROCESS
BEGIN
	kbd_clk <= '1';
	WAIT FOR 50000 ps;
	FOR i IN 1 TO 12
	LOOP
		kbd_clk <= '0';
		WAIT FOR 50000 ps;
		kbd_clk <= '1';
		WAIT FOR 50000 ps;
	END LOOP;
	kbd_clk <= '0';
WAIT;
END PROCESS t_prcs_kbd_clk;

-- kbd_dat
t_prcs_kbd_dat: PROCESS
BEGIN
	kbd_dat <= '1';
	WAIT FOR 25000 ps;
	kbd_dat <= '0';
	WAIT FOR 100000 ps;
	kbd_dat <= '1';
	WAIT FOR 100000 ps;
	kbd_dat <= '0';
	WAIT FOR 200000 ps;
	kbd_dat <= '1';
	WAIT FOR 100000 ps;
	kbd_dat <= '0';
	WAIT FOR 100000 ps;
	kbd_dat <= '1';
	WAIT FOR 100000 ps;
	kbd_dat <= '0';
	WAIT FOR 300000 ps;
	kbd_dat <= '1';
WAIT;
END PROCESS t_prcs_kbd_dat;
END bitrec_arch;
