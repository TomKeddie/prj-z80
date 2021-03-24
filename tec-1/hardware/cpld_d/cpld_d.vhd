LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY cpld_d IS
      PORT(d          : inout std_logic_vector(7 downto 0);
		     nmi_n      : out std_logic;
			  
  			  seg7col    : out std_logic_vector(5 downto 0);
			  seg7col_wr : in  std_logic;
			  keybd_rd   : in  std_logic;
			  nmi_rd     : in  std_logic;
			  
			  keybd_923      : in std_logic_vector(4 downto 0);
			  keybd_shift_n  : in std_logic; -- pullup
			  keybd_923_da   : in std_logic;
			  
			  keybd_ftdi    : in std_logic_vector(5 downto 0);
			  keybd_ftdi_da : std_logic;
			  
			  clk_16     : in  std_logic);
END cpld_d;

-- flash A18 is wired to A12 to split the chip in two;

ARCHITECTURE arch OF cpld_d IS
	 signal seg7col_internal : std_logic_vector(seg7col'range)    := (others => '0');
	 signal keybd_internal   : std_logic_vector(keybd_ftdi'range) := (others => '0');
	 signal keybd_923_da_1d  : std_logic := '0';
	 signal keybd_ftdi_da_1d : std_logic := '0';
	 signal nmi_internal     : std_logic := '0';
	 signal nmi_latch_n      : std_logic := '0';
 begin
	 seg7col <= seg7col_internal;
	 nmi_n   <= not nmi_internal;
	 
    clk_p : process(clk_16)
	 begin
	     if rising_edge(clk_16) then
		      keybd_923_da_1d  <= keybd_923_da;
				keybd_ftdi_da_1d <= keybd_ftdi_da;
				nmi_internal     <= '0';
		      -- data bus write
		      if keybd_rd = '1' then
				    d <= "00" & keybd_internal;
			   elsif nmi_rd = '1' then
				    d <= '0' & nmi_latch_n & "000000";
				else
				    d <= (d'range => 'Z');
				end if;
				-- data bus read
				if seg7col_wr = '1' then
				    seg7col_internal <= d(seg7col_internal'range);
            end if;				    
				-- keybd store
				if keybd_923_da = '1' and keybd_923_da_1d = '0' then
					 keybd_internal <= keybd_shift_n & keybd_923;
     				 nmi_internal   <= '1';
				elsif keybd_ftdi_da = '1' and keybd_ftdi_da_1d = '0' then
				    keybd_internal <= keybd_ftdi;
     				 nmi_internal   <= '1';
				end if;
				if nmi_rd = '1' then
				    nmi_latch_n <= not nmi_internal;
				end if;
 		  end if;
	 end process;
end arch;
