LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY cpld_a IS
      PORT(a_msb      : in std_logic_vector(13 downto 11);
		     a_lsb      : in std_logic_vector(3 downto 0);
		     memrq_n    : in std_logic;
			  iorq_n     : in std_logic;
			  clk_cpu    : out std_logic;
			  
		     flash_cs_n : out std_logic;
			  flash_a    : out std_logic_vector(13 downto 11);

		     sram_cs_n  : out std_logic;

			  seg7col_cs : out std_logic;
			  seg7row_cs : out std_logic;

			  keybd_cs_n : out std_logic;

			  clk_16     : in  std_logic);
END cpld_a;

-- flash A18 is wired to A12 to split the chip in two;

ARCHITECTURE arch OF cpld_a IS
    signal clk_counter : integer range 0 to 7 := 0;
	 signal clk_cpu_internal : std_logic := '0';
begin
	 clk_cpu <= clk_cpu_internal;
	 
    --                    A15 A14 A13 A12 | A11
	 -- flash_0 0000-07FF   0   0   0   0  |  0
	 -- sram_0  0800-0FFF   0   0   0   0  |  1
	 -- sram_1  1000-17FF   0   0   0   1  |  0
	 -- flash_1 1800-1FFF   0   0   0   1  |  1
	 -- sram_2  2000-27FF   0   0   1   0  |  0
	 -- sram_3  2800-2FFF   0   0   1   0  |  1
    flash_cs_n <= '0' when memrq_n = '0' and (unsigned(a_msb) = b"00_0" or 
	                                           unsigned(a_msb) = b"001_1") else '1';
	 sram_cs_n  <= '0' when memrq_n = '0' and (unsigned(a_msb) = b"00_1" or 
	                                           unsigned(a_msb) = b"01_0" or 
														    unsigned(a_msb) = b"10_0" or 
														    unsigned(a_msb) = b"10_1") else '1';
	 keybd_cs_n <= '0' when iorq_n = '0' and unsigned(a_lsb) = b"0000" else '1';
	 seg7col_cs <= '1' when iorq_n = '0' and unsigned(a_lsb) = b"0001" else '1';
	 seg7row_cs <= '1' when iorq_n = '0' and unsigned(a_lsb) = b"0001" else '1';
	 
    clk_p : process(clk_16)
	 begin
	     if rising_edge(clk_16) then
				if clk_counter = 3 then
				    clk_cpu_internal <= not clk_cpu_internal;
					 clk_counter <= 0;
			   else
					 clk_counter <= clk_counter + 1;
				end if;
		  end if;
	 end process;
end arch;
