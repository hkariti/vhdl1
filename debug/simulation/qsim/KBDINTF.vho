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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition"

-- DATE "05/12/2018 21:47:12"

-- 
-- Device: Altera 5CSXFC6D6F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	NUM_LOCK IS
    PORT (
	resetN : IN std_logic;
	clk : IN std_logic;
	din : IN std_logic_vector(8 DOWNTO 0);
	key_code : IN std_logic_vector(8 DOWNTO 0);
	make : IN std_logic;
	break : IN std_logic;
	dout : OUT std_logic
	);
END NUM_LOCK;

ARCHITECTURE structure OF NUM_LOCK IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_resetN : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_din : std_logic_vector(8 DOWNTO 0);
SIGNAL ww_key_code : std_logic_vector(8 DOWNTO 0);
SIGNAL ww_make : std_logic;
SIGNAL ww_break : std_logic;
SIGNAL ww_dout : std_logic;
SIGNAL \dout~output_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \make~input_o\ : std_logic;
SIGNAL \din[6]~input_o\ : std_logic;
SIGNAL \key_code[6]~input_o\ : std_logic;
SIGNAL \din[7]~input_o\ : std_logic;
SIGNAL \key_code[7]~input_o\ : std_logic;
SIGNAL \din[8]~input_o\ : std_logic;
SIGNAL \key_code[8]~input_o\ : std_logic;
SIGNAL \Equal0~0_combout\ : std_logic;
SIGNAL \din[0]~input_o\ : std_logic;
SIGNAL \key_code[0]~input_o\ : std_logic;
SIGNAL \din[1]~input_o\ : std_logic;
SIGNAL \key_code[1]~input_o\ : std_logic;
SIGNAL \din[2]~input_o\ : std_logic;
SIGNAL \key_code[2]~input_o\ : std_logic;
SIGNAL \Equal0~1_combout\ : std_logic;
SIGNAL \din[3]~input_o\ : std_logic;
SIGNAL \key_code[3]~input_o\ : std_logic;
SIGNAL \din[4]~input_o\ : std_logic;
SIGNAL \key_code[4]~input_o\ : std_logic;
SIGNAL \din[5]~input_o\ : std_logic;
SIGNAL \key_code[5]~input_o\ : std_logic;
SIGNAL \Equal0~2_combout\ : std_logic;
SIGNAL \break~input_o\ : std_logic;
SIGNAL \pr_state~0_combout\ : std_logic;
SIGNAL \resetN~input_o\ : std_logic;
SIGNAL \pr_state~q\ : std_logic;
SIGNAL \out_led~0_combout\ : std_logic;
SIGNAL \out_led~q\ : std_logic;
SIGNAL \ALT_INV_break~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[5]~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[4]~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_out_led~q\ : std_logic;
SIGNAL \ALT_INV_pr_state~q\ : std_logic;
SIGNAL \ALT_INV_Equal0~0_combout\ : std_logic;
SIGNAL \ALT_INV_Equal0~1_combout\ : std_logic;
SIGNAL \ALT_INV_Equal0~2_combout\ : std_logic;
SIGNAL \ALT_INV_make~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[6]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[7]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[8]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_key_code[0]~input_o\ : std_logic;
SIGNAL \ALT_INV_din[1]~input_o\ : std_logic;

BEGIN

ww_resetN <= resetN;
ww_clk <= clk;
ww_din <= din;
ww_key_code <= key_code;
ww_make <= make;
ww_break <= break;
dout <= ww_dout;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_break~input_o\ <= NOT \break~input_o\;
\ALT_INV_key_code[5]~input_o\ <= NOT \key_code[5]~input_o\;
\ALT_INV_din[5]~input_o\ <= NOT \din[5]~input_o\;
\ALT_INV_key_code[4]~input_o\ <= NOT \key_code[4]~input_o\;
\ALT_INV_din[4]~input_o\ <= NOT \din[4]~input_o\;
\ALT_INV_key_code[3]~input_o\ <= NOT \key_code[3]~input_o\;
\ALT_INV_key_code[1]~input_o\ <= NOT \key_code[1]~input_o\;
\ALT_INV_din[2]~input_o\ <= NOT \din[2]~input_o\;
\ALT_INV_out_led~q\ <= NOT \out_led~q\;
\ALT_INV_pr_state~q\ <= NOT \pr_state~q\;
\ALT_INV_Equal0~0_combout\ <= NOT \Equal0~0_combout\;
\ALT_INV_Equal0~1_combout\ <= NOT \Equal0~1_combout\;
\ALT_INV_Equal0~2_combout\ <= NOT \Equal0~2_combout\;
\ALT_INV_make~input_o\ <= NOT \make~input_o\;
\ALT_INV_key_code[2]~input_o\ <= NOT \key_code[2]~input_o\;
\ALT_INV_din[3]~input_o\ <= NOT \din[3]~input_o\;
\ALT_INV_din[6]~input_o\ <= NOT \din[6]~input_o\;
\ALT_INV_key_code[6]~input_o\ <= NOT \key_code[6]~input_o\;
\ALT_INV_din[7]~input_o\ <= NOT \din[7]~input_o\;
\ALT_INV_key_code[7]~input_o\ <= NOT \key_code[7]~input_o\;
\ALT_INV_din[8]~input_o\ <= NOT \din[8]~input_o\;
\ALT_INV_key_code[8]~input_o\ <= NOT \key_code[8]~input_o\;
\ALT_INV_din[0]~input_o\ <= NOT \din[0]~input_o\;
\ALT_INV_key_code[0]~input_o\ <= NOT \key_code[0]~input_o\;
\ALT_INV_din[1]~input_o\ <= NOT \din[1]~input_o\;

\dout~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \out_led~q\,
	devoe => ww_devoe,
	o => \dout~output_o\);

\clk~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

\make~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_make,
	o => \make~input_o\);

\din[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(6),
	o => \din[6]~input_o\);

\key_code[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(6),
	o => \key_code[6]~input_o\);

\din[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(7),
	o => \din[7]~input_o\);

\key_code[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(7),
	o => \key_code[7]~input_o\);

\din[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(8),
	o => \din[8]~input_o\);

\key_code[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(8),
	o => \key_code[8]~input_o\);

\Equal0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Equal0~0_combout\ = ( \din[8]~input_o\ & ( \key_code[8]~input_o\ & ( (!\din[6]~input_o\ & (!\key_code[6]~input_o\ & (!\din[7]~input_o\ $ (\key_code[7]~input_o\)))) # (\din[6]~input_o\ & (\key_code[6]~input_o\ & (!\din[7]~input_o\ $ 
-- (\key_code[7]~input_o\)))) ) ) ) # ( !\din[8]~input_o\ & ( !\key_code[8]~input_o\ & ( (!\din[6]~input_o\ & (!\key_code[6]~input_o\ & (!\din[7]~input_o\ $ (\key_code[7]~input_o\)))) # (\din[6]~input_o\ & (\key_code[6]~input_o\ & (!\din[7]~input_o\ $ 
-- (\key_code[7]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1001000000001001000000000000000000000000000000001001000000001001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_din[6]~input_o\,
	datab => \ALT_INV_key_code[6]~input_o\,
	datac => \ALT_INV_din[7]~input_o\,
	datad => \ALT_INV_key_code[7]~input_o\,
	datae => \ALT_INV_din[8]~input_o\,
	dataf => \ALT_INV_key_code[8]~input_o\,
	combout => \Equal0~0_combout\);

\din[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(0),
	o => \din[0]~input_o\);

\key_code[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(0),
	o => \key_code[0]~input_o\);

\din[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(1),
	o => \din[1]~input_o\);

\key_code[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(1),
	o => \key_code[1]~input_o\);

\din[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(2),
	o => \din[2]~input_o\);

\key_code[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(2),
	o => \key_code[2]~input_o\);

\Equal0~1\ : cyclonev_lcell_comb
-- Equation(s):
-- \Equal0~1_combout\ = ( \din[2]~input_o\ & ( \key_code[2]~input_o\ & ( (!\din[0]~input_o\ & (!\key_code[0]~input_o\ & (!\din[1]~input_o\ $ (\key_code[1]~input_o\)))) # (\din[0]~input_o\ & (\key_code[0]~input_o\ & (!\din[1]~input_o\ $ 
-- (\key_code[1]~input_o\)))) ) ) ) # ( !\din[2]~input_o\ & ( !\key_code[2]~input_o\ & ( (!\din[0]~input_o\ & (!\key_code[0]~input_o\ & (!\din[1]~input_o\ $ (\key_code[1]~input_o\)))) # (\din[0]~input_o\ & (\key_code[0]~input_o\ & (!\din[1]~input_o\ $ 
-- (\key_code[1]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1001000000001001000000000000000000000000000000001001000000001001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_din[0]~input_o\,
	datab => \ALT_INV_key_code[0]~input_o\,
	datac => \ALT_INV_din[1]~input_o\,
	datad => \ALT_INV_key_code[1]~input_o\,
	datae => \ALT_INV_din[2]~input_o\,
	dataf => \ALT_INV_key_code[2]~input_o\,
	combout => \Equal0~1_combout\);

\din[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(3),
	o => \din[3]~input_o\);

\key_code[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(3),
	o => \key_code[3]~input_o\);

\din[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(4),
	o => \din[4]~input_o\);

\key_code[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(4),
	o => \key_code[4]~input_o\);

\din[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_din(5),
	o => \din[5]~input_o\);

\key_code[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_key_code(5),
	o => \key_code[5]~input_o\);

\Equal0~2\ : cyclonev_lcell_comb
-- Equation(s):
-- \Equal0~2_combout\ = ( \din[5]~input_o\ & ( \key_code[5]~input_o\ & ( (!\din[3]~input_o\ & (!\key_code[3]~input_o\ & (!\din[4]~input_o\ $ (\key_code[4]~input_o\)))) # (\din[3]~input_o\ & (\key_code[3]~input_o\ & (!\din[4]~input_o\ $ 
-- (\key_code[4]~input_o\)))) ) ) ) # ( !\din[5]~input_o\ & ( !\key_code[5]~input_o\ & ( (!\din[3]~input_o\ & (!\key_code[3]~input_o\ & (!\din[4]~input_o\ $ (\key_code[4]~input_o\)))) # (\din[3]~input_o\ & (\key_code[3]~input_o\ & (!\din[4]~input_o\ $ 
-- (\key_code[4]~input_o\)))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1001000000001001000000000000000000000000000000001001000000001001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_din[3]~input_o\,
	datab => \ALT_INV_key_code[3]~input_o\,
	datac => \ALT_INV_din[4]~input_o\,
	datad => \ALT_INV_key_code[4]~input_o\,
	datae => \ALT_INV_din[5]~input_o\,
	dataf => \ALT_INV_key_code[5]~input_o\,
	combout => \Equal0~2_combout\);

\break~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_break,
	o => \break~input_o\);

\pr_state~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \pr_state~0_combout\ = ( \Equal0~2_combout\ & ( \break~input_o\ & ( (!\pr_state~q\ & (\make~input_o\ & (\Equal0~0_combout\ & \Equal0~1_combout\))) # (\pr_state~q\ & (((!\Equal0~0_combout\) # (!\Equal0~1_combout\)))) ) ) ) # ( !\Equal0~2_combout\ & ( 
-- \break~input_o\ & ( \pr_state~q\ ) ) ) # ( \Equal0~2_combout\ & ( !\break~input_o\ & ( ((\make~input_o\ & (\Equal0~0_combout\ & \Equal0~1_combout\))) # (\pr_state~q\) ) ) ) # ( !\Equal0~2_combout\ & ( !\break~input_o\ & ( \pr_state~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101011101010101010101010101010101010010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_pr_state~q\,
	datab => \ALT_INV_make~input_o\,
	datac => \ALT_INV_Equal0~0_combout\,
	datad => \ALT_INV_Equal0~1_combout\,
	datae => \ALT_INV_Equal0~2_combout\,
	dataf => \ALT_INV_break~input_o\,
	combout => \pr_state~0_combout\);

\resetN~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_resetN,
	o => \resetN~input_o\);

pr_state : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \pr_state~0_combout\,
	clrn => \resetN~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \pr_state~q\);

\out_led~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \out_led~0_combout\ = ( \Equal0~1_combout\ & ( \Equal0~2_combout\ & ( !\out_led~q\ $ ((((!\make~input_o\) # (!\Equal0~0_combout\)) # (\pr_state~q\))) ) ) ) # ( !\Equal0~1_combout\ & ( \Equal0~2_combout\ & ( \out_led~q\ ) ) ) # ( \Equal0~1_combout\ & ( 
-- !\Equal0~2_combout\ & ( \out_led~q\ ) ) ) # ( !\Equal0~1_combout\ & ( !\Equal0~2_combout\ & ( \out_led~q\ ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010101010101010101010101010101010101010101010101010101011001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_out_led~q\,
	datab => \ALT_INV_pr_state~q\,
	datac => \ALT_INV_make~input_o\,
	datad => \ALT_INV_Equal0~0_combout\,
	datae => \ALT_INV_Equal0~1_combout\,
	dataf => \ALT_INV_Equal0~2_combout\,
	combout => \out_led~0_combout\);

out_led : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~input_o\,
	d => \out_led~0_combout\,
	clrn => \resetN~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \out_led~q\);

ww_dout <= \dout~output_o\;
END structure;


