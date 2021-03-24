LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY cpld_a IS
      PORT(a_msb      : in std_logic_vector(14 downto 11);
		     a_lsb      : in std_logic_vector(2 downto 0);
		     memrq_n    : in std_logic;
			  iorq_n     : in std_logic;
			  clk_cpu    : out std_logic;
			  rd_n       : in std_logic;
			  wr_n       : in std_logic;
			  reset_n    : out std_logic;
			  
		     flash_cs_n : out std_logic;
			  flash_a    : out std_logic_vector(2 downto 0);

		     srama_cs_n  : out std_logic;
		     sramb_cs_n  : out std_logic;

			  seg7col_wr     : out std_logic;
			  seg7row_wr     : out std_logic;

			  keybd_rd       : out std_logic;
			  keybd_923      : in std_logic_vector(4 downto 0);
			  keybd_reset_n  : in std_logic;
			  keybd_923_da   : in std_logic;
			  
			  m1             : in std_logic;
			  int_n          : out std_logic;

			  clk_16         : in  std_logic);
END cpld_a;

ARCHITECTURE arch OF cpld_a IS
    signal clk_counter      : integer range 0 to 7 := 0;
	 signal clk_counter_max  : integer range 0 to 7 := 3;
	 signal clk_cpu_internal : std_logic := '0';
	 signal keybd_923_da_1d  : std_logic := '0';
	 signal flash_cs         : std_logic := '0';
	 signal m1_1d            : std_logic := '0';
begin
	 clk_cpu <= clk_cpu_internal;
	 reset_n <= keybd_reset_n;
	 flash_cs_n <= flash_cs;
	 
    --                     A15 A14 A13 A12 | A11
	 -- flash_0  0000-07FF   0   0   0   0  |  0
	 -- srama_0  0800-0FFF   0   0   0   0  |  1
	 -- srama_1  1000-17FF   0   0   0   1  |  0
	 -- flash_1  1800-1FFF   0   0   0   1  |  1
	 -- srama_2  2000-27FF   0   0   1   0  |  0
	 -- srama_3  2800-2FFF   0   0   1   0  |  1
	 -- sramb    4000-5FFF   0   1   0   x  |  x
    flash_cs   <= '1' when memrq_n = '0' and (unsigned(a_msb) = b"00_0" or 
	                                           unsigned(a_msb) = b"001_1") else '0';
	 srama_cs_n <= '0' when memrq_n = '0' and (unsigned(a_msb) = b"00_1" or 
	                                           unsigned(a_msb) = b"01_0" or 
														    unsigned(a_msb) = b"10_0" or 
														    unsigned(a_msb) = b"10_1") else '1';
	 sramb_cs_n <= '0' when memrq_n = '0' and a_msb(14) = '1' else '1';
	 keybd_rd   <= '1' when rd_n = '0' and iorq_n = '0' and unsigned(a_lsb) = b"000" else '0';
	 seg7col_wr <= '1' when wr_n = '0' and iorq_n = '0' and unsigned(a_lsb) = b"001" else '0';
	 seg7row_wr <= '1' when wr_n = '0' and iorq_n = '0' and unsigned(a_lsb) = b"010" else '0';
	 
    clk_p : process(clk_16)
	 begin
	     if rising_edge(clk_16) then
		      keybd_923_da_1d <= keybd_923_da;
				m1_1d <= m1;
				if clk_counter = clk_counter_max then
				    clk_cpu_internal <= not clk_cpu_internal;
					 clk_counter <= 0;
			   else
					 clk_counter <= clk_counter + 1;
				end if;
				if keybd_reset_n = '0' and keybd_923_da = '1' and keybd_923_da_1d = '0' then
				    if keybd_923(4 downto 3) = "00" then
                    -- while holding reset and pressing a 0-7 key we load the flash bank
    				     flash_a <= keybd_923(flash_a'range);
				    elsif keybd_923(4 downto 3) = "01" then
                    -- while holding reset and pressing a 8-F key we load the clock divisor
					     clk_counter_max <= to_integer(unsigned(keybd_923(2 downto 0))) + 1;
					 end if;
				end if;
				if m1 = '1' and m1_1d = '0' then
                int_n <= '1';
				    if flash_cs = '1' then
				        int_n <= '0';
					 end if;
				end if;
		  end if;
	 end process;
end arch;
