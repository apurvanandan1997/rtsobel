----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:36:33 07/06/2018 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.math_real.all;

entity top is
generic(
fifodepth : integer := 1920;
pixelvectorsize : integer := 8;
stride : integer := 1
);
port(datain: IN STD_uLOGIC_VECTOR(pixelvectorsize -1 downto 0);
 dataout: out STD_uLOGIC_VECTOR(pixelvectorsize -1 downto 0);
 clock: in STD_LOGIC;
 dat_rdy : out STD_LOGIC;
 reset : in STD_LOGIC
 );

end top;

architecture Behavioral of top is
component bigfifo is
port (
datain :in std_ulogic_vector(pixelvectorsize -1 downto 0);
clock : in std_logic ;
pixel_1 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
pixel_2 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
pixel_3 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
pixel_4 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
pixel_5 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
pixel_6 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
pixel_7 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
pixel_8 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
pixel_9 : out std_ulogic_vector(pixelvectorsize -1 downto 0);
datardy :out std_logic;
reset : in std_logic
);
end component;

component matrix_multiply_top is

port (
           clock: in STD_LOGIC ;
			  nd_sig : in std_logic;
			  rdy :out std_logic;
           pixel_1 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
           pixel_2 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
           pixel_3 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
           pixel_4 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
           pixel_5 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
           pixel_6 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
           pixel_7 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
           pixel_8 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
           pixel_9 : in  STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
--            kc_1 : in  float32;
--            kc_2 : in  float32;
--            kc_3 : in  float32;
--            kc_4 : in  float32;
--            kc_5 : in  float32;
--            kc_6 : in  float32;
--            kc_7 : in  float32;
--            kc_8 : in  float32;
--            kc_9 : in  float32;
            data_out : out STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0)--output
              );
end component;				  
signal  pixel1 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal  pixel2 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal  pixel3 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal  pixel4 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal  pixel5 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal  pixel6 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal  pixel7 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal  pixel8 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal  pixel9 : STD_ULOGIC_VECTOR(pixelvectorsize -1 downto 0);
signal nd_sig :std_logic;
signal kc_1 : float32;
signal kc_2 : float32;
signal kc_3 : float32;
signal kc_4 : float32;
signal kc_5 : float32;
signal kc_6 : float32;
signal kc_7 : float32;
signal kc_8 : float32;
signal kc_9 : float32;


begin

fifo : bigfifo port map (
datain => datain,
pixel_1 =>pixel1,
pixel_2 =>pixel2,
pixel_3 =>pixel3,
pixel_4 =>pixel4,
pixel_5 =>pixel5,
pixel_6 =>pixel6,
pixel_7 =>pixel7,
pixel_8 =>pixel8,
pixel_9 =>pixel9,
clock => clock,
datardy => nd_sig,
reset=> reset);

conv: matrix_multiply_top port map(
clock => clock,
nd_sig => nd_sig,
rdy => dat_rdy,
pixel_1 =>pixel1,
pixel_2 =>pixel2,
pixel_3 =>pixel3,
pixel_4 =>pixel4,
pixel_5 =>pixel5,
pixel_6 =>pixel6,
pixel_7 =>pixel7,
pixel_8 =>pixel8,
pixel_9 =>pixel9,
data_out => dataout
--kc_1 => kc_1,
--kc_2 => kc_2,
--kc_3 => kc_3,
--kc_4 => kc_4,
--kc_5 => kc_5,
--kc_6 => kc_6,
--kc_7 => kc_7,
--kc_8 => kc_8,
--kc_9 => kc_9
);


end Behavioral;

