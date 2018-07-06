----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:02:10 07/02/2018 
-- Design Name: 
-- Module Name:    matrix_multiply_top - Behavioral 
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
use ieee.numeric_std.all;
use ieee.math_real.all; 
library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity matrix_multiply_top is
generic(pixelvectorsize : integer := 8);
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
--           kc_1 : in  float32;
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
end matrix_multiply_top;
architecture Behavioral of matrix_multiply_top is

--signal clock: std_logic;
begin
process(clock, nd_sig)
variable output: STD_ULOGIC_VECTOR(7 downto 0);
variable kp_1: float32;
variable kp_2: float32;
variable kp_3: float32;
variable kp_4: float32;
variable kp_5: float32;
variable kp_6: float32;
variable kp_7: float32;
variable kp_8: float32;
variable kp_9: float32;
variable sum : float32;
variable saturated_sum: float32;
variable kc_1: float32 := "00111111100000000000000000000000";
variable kc_2: float32 := "00000000000000000000000000000000";
variable kc_3: float32 := "10111111100000000000000000000000";
variable kc_4: float32 := "01000000000000000000000000000000";
variable kc_5: float32 := "00000000000000000000000000000000";
variable kc_6: float32 := "11000000000000000000000000000000";
variable kc_7: float32 := "00111111100000000000000000000000";
variable kc_8: float32 := "00000000000000000000000000000000";
variable kc_9: float32 := "10111111100000000000000000000000";

variable done :STD_LOGIC :='0';
begin
done := '0';
if(  clock'event and clock='1' and nd_sig='1') then
kp_1:= kc_1*to_float(unsigned(pixel_1));
kp_2:= kc_2*to_float(unsigned(pixel_2));
kp_3:= kc_3*to_float(unsigned(pixel_3));
kp_4:= kc_4*to_float(unsigned(pixel_4));
kp_5:= kc_5*to_float(unsigned(pixel_5));
kp_6:= kc_6*to_float(unsigned(pixel_6));
kp_7:= kc_7*to_float(unsigned(pixel_7));
kp_8:= kc_8*to_float(unsigned(pixel_8));
kp_9:= kc_9*to_float(unsigned(pixel_9));
sum:=(((kp_1+kp_2)+(kp_3+kp_4))+((kp_5+kp_6)+(kp_7+kp_8)))+kp_9;
if(sum>255.0) then
saturated_sum:="01000011011111110000000000000000";
elsif(sum<0.0) then
saturated_sum := "00000000000000000000000000000000";
else
saturated_sum:= sum;
end if;
output:=std_ulogic_vector(to_unsigned(to_integer(saturated_sum), output'length));
done:='1';
end if;
data_out<= output;
rdy <= nd_sig and done;
end process;
end Behavioral;
