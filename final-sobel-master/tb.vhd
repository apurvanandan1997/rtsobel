-- TestBench Template

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;
  ENTITY testbench IS
  END testbench;

	ARCHITECTURE behavior OF testbench IS

  -- Component Declaration
          COMPONENT top is
port(
 datain: IN STD_uLOGIC_VECTOR(7 downto 0);
 dataout: out STD_uLOGIC_VECTOR(7 downto 0);
 clock: in STD_LOGIC;
 dat_rdy : out STD_LOGIC;
 reset: in std_logic
 );
END COMPONENT;

          SIGNAL data_out :  std_ulogic_vector(7 downto 0) ;
          SIGNAL data_in :  std_ulogic_vector(7 downto 0);
			  signal clock : std_logic := '0';
			  signal data_rdy : std_logic;
			   constant clock_period : time := 1 ns;
				signal eof_sig : std_logic :='0';
  -----------------------------------------------------------------------------
  -- Testbench Internal Signals
  -----------------------------------------------------------------------------
  file file_VECTORS : text;
  file file_RESULTS : text;

  constant c_WIDTH : natural := 8;

 signal temp: std_ulogic_vector(7 downto 0);



begin
  uut: top PORT MAP (
  datain =>data_in,
  dataout=>data_out,
  clock=>clock,
  dat_rdy=>data_rdy,
   reset => eof_sig);
  -----------------------------------------------------------------------------
  -- Instantiate and Map UUT
  -----------------------------------------------------------------------------


   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;


  ---------------------------------------------------------------------------
  -- This procedure reads the file input_vectors.txt which is located in the
  -- simulation project area.
  -- It will read the data in and send it to the ripple-adder component
  -- to perform the operations.  The result is written to the
  -- output_results.txt file, located in the same directory.
  ---------------------------------------------------------------------------
 reading: process
    variable v_ILINE     : line;

    variable vector: std_ulogic_vector(c_WIDTH-1 downto 0);

    variable v_SPACE     : character;
     variable v1GoodRead      : boolean := true;
	  variable v2GoodRead      : boolean := true;
     variable testing : std_logic :='1';
     variable i: integer :=0;
  begin

    file_open(file_VECTORS, "a.txt",  read_mode);
    while not endfile(file_vectors) loop
      readline(file_VECTORS, v_ILINE);
--		read(v_ILINE, vector, v1GoodRead);
--            read(v_ILINE, v_SPACE, v2GoodRead );
            while (i <150) loop--not (v_SPACE = CR ) and v1GoodRead and v2GoodRead) loop
				read(v_ILINE, vector, v1GoodRead);
            read(v_ILINE, v_SPACE, v2GoodRead );
				if (v1GoodRead ) then
				data_in<= vector;
				wait for clock_period ;
            end if;
				i:=i+1;
				end loop;
         i:=0;
   if(endfile(file_VECTORS)) then eof_sig <= '1' ;
	else eof_sig <='0';
	end if;
        end loop;
    file_close(file_VECTORS);
	 wait;
	   end process reading;
  writing: process
      variable v_OLINE     : line;
		variable vector: std_ulogic_vector(c_WIDTH-1 downto 0);
		variable v_SPACE     : character :=' ';
		variable new_line : character :=CR;
		variable pixels_c: integer:= 0;
      variable line_count: integer :=0;
		begin
 file_open(file_RESULTS, "c.txt", write_mode);
 while ( line_count<50) loop
  wait until data_rdy'event and data_rdy='1';
  vector := data_out;
  write(v_OLINE, vector);
  if(pixels_c>142) then
    pixels_c:=0;
    write(v_OLINE, new_line);
    line_count := line_count+1;
  else write(v_OLINE, v_SPACE);
    pixels_c:=pixels_c+1; end if;
end loop;
writeline(file_RESULTS, v_OLINE);
	  file_close(file_RESULTS);
      wait;
    end process writing;

  end;
