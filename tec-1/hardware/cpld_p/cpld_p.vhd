LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY cpld_p IS
      PORT(d          : inout std_logic_vector(7 downto 0);
		     a_lsb      : in std_logic_vector(2 downto 0);
			  iorq_n     : in std_logic;
			  wr_n       : in std_logic;

			  matrix_row   : out std_logic_vector(7 downto 0);
			  matrix_col   : out std_logic_vector(7 downto 0);

           lcd_en     : out std_logic;
			
			  clk_16     : in  std_logic);
END cpld_p;

ARCHITECTURE arch OF cpld_p IS
    signal matrix_row_wr : std_logic := '0';
    signal matrix_col_wr : std_logic := '0';
begin
    -- led matrix on ports 5 and 6
	 matrix_row_wr <= '1' when wr_n = '0' and iorq_n = '0' and unsigned(a_lsb) = b"101" else '0';
	 matrix_col_wr <= '1' when wr_n = '0' and iorq_n = '0' and unsigned(a_lsb) = b"110" else '0';
	 
	 -- lcd on port 4
	 lcd_en <= '1' when iorq_n = '0' and unsigned(a_lsb) = b"100" else '0';
	 
    clk_p : process(clk_16)
	 begin
	     if rising_edge(clk_16) then
		      if matrix_row_wr = '1' then
				    matrix_row <= d;
				end if;
		      if matrix_col_wr = '1' then
				    matrix_col <= d;
				end if;
				if nmi_rd = '1' then
				    nmi_internal <= nmi_n;
				end if;
		  end if;
	 end process;
end arch;
