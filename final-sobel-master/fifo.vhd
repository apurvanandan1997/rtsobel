----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:32:51 07/05/2018 
-- Design Name: 
-- Module Name:    fifosmall - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.math_real.all;
entity fifo is
generic(
fifodepth : integer := 150;
pixelvectorsize : integer := 8;
stride : integer := 1
);
port (

clk :in std_logic ;
datain :in std_ulogic_vector(pixelvectorsize -1 downto 0);
dataout1 :out std_ulogic_vector(pixelvectorsize -1 downto 0);
dataout2 :out std_ulogic_vector(pixelvectorsize -1 downto 0);
dataout3 :out std_ulogic_vector(pixelvectorsize -1 downto 0);
dataout :out std_ulogic_vector(pixelvectorsize -1 downto 0);
wr :in std_logic;
rd1 :in std_logic;
rd2 :in std_logic;
rd3 :in std_logic;
rd :in std_logic;
full :out std_logic;
reset : in std_logic
);






end fifo;

architecture Behavioral of fifo is
type pixels_in_a_row is array(0 to fifodepth -1 ) of std_ulogic_vector(pixelvectorsize-1 downto 0);
signal pix_row : pixels_in_a_row :=(others => (others => '0'));
constant nbits : natural := integer(ceil(log2(real(fifodepth))));
begin
process(clk) --writing process

variable writeptrc: std_logic_vector( nbits-1 downto 0) :=( others => '0');
variable fullvar : std_logic:='0';
begin
if(clk'event and clk='1' and wr ='1') then
pix_row(conv_integer(writeptrc)) <= datain;
writeptrc := writeptrc+'1';
end if;
if(writeptrc=conv_std_logic_vector(fifodepth,nbits))then
writeptrc:=(others => '0');
end if;
if(writeptrc=conv_std_logic_vector(fifodepth-1 ,nbits))then
fullvar:= '1'; 
else 
fullvar:= '0';
end if;
if(reset = '1') then
writeptrc := (others => '0');
fullvar :='0';
end if;
full<=fullvar;
end process;
process(clk) --reading process 1
variable r1ptrc: std_logic_vector( nbits-1 downto 0):=( others => '0');
begin
if(clk'event and clk ='0' and rd1='1') then
dataout1 <= pix_row(conv_integer(r1ptrc));
r1ptrc:= r1ptrc+'1';
end if;
if(r1ptrc=conv_std_logic_vector(fifodepth-6,nbits))then 
r1ptrc:=(others => '0');
end if;
if(reset = '1') then
r1ptrc := (others => '0');
end if;
end process;

process(clk) --reading process 2
variable r2ptrc: std_logic_vector( nbits-1 downto 0):=conv_std_logic_vector(3,nbits);
begin
if(clk'event and clk ='0' and rd2='1') then
dataout2 <= pix_row(conv_integer(r2ptrc));
r2ptrc:= r2ptrc+'1';
end if;
if(r2ptrc=conv_std_logic_vector(fifodepth-3,nbits))then 
r2ptrc:=conv_std_logic_vector(3,nbits);
end if;
if(reset = '1') then
r2ptrc := conv_std_logic_vector(3,nbits);
end if;
end process;

process(clk) --reading process 3
variable r3ptrc: std_logic_vector( nbits-1 downto 0):=conv_std_logic_vector(6,nbits);
begin
if(clk'event and clk ='0' and rd3='1') then
dataout3 <= pix_row(conv_integer(r3ptrc));
r3ptrc:= r3ptrc+'1';
end if;
if(r3ptrc=conv_std_logic_vector(fifodepth,nbits))then 
r3ptrc:=conv_std_logic_vector(6,nbits);
end if;
if(reset = '1') then
r3ptrc := conv_std_logic_vector(6,nbits);
end if;
end process;

process(clk) --reading process 
variable readptrc: std_logic_vector( nbits-1 downto 0) :=( others => '0');
begin
if(clk'event and clk ='0' and rd='1') then
dataout <= pix_row(conv_integer(readptrc));
readptrc := readptrc+'1';
end if;
if(readptrc=conv_std_logic_vector(fifodepth,nbits))then 
readptrc:=(others => '0');
end if;
if(reset = '1') then
readptrc := (others => '0');
end if;
end process;

end Behavioral;

