------------------------------------------------------------------
-- Name		     : timer.vhd
-- Description : Timer with load, enable and done output
-- Designed by : Claudio Avi Chami - FPGA Site
--               fpgasite.blogspot.com
-- Date        : 15/04/2017
-- Version     : 01
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
	generic (
		DATA_W		: natural := 32
	);
	port (
		clk: 		in std_logic;
		rst: 		in std_logic;
		
		-- inputs
		data_in:	in std_logic_vector (DATA_W-1 downto 0);
		load: 		in std_logic;
		en:			in std_logic;
		
		-- outputs
		done:		out std_logic
	);
end timer;

architecture rtl of timer is
	signal timer_reg : unsigned (DATA_W-1 downto 0);

begin 

timer_pr: process (clk) 
	begin 
    if (rising_edge(clk)) then
      if (rst = '1') then 
        timer_reg   <= (others => '0');
        done    <= '0';
	    else
		    if (load = '1') then				  -- load timer
			    timer_reg	<= unsigned(data_in);
			    done		    <= '0';				  -- start a new timing - deassert done signal
		    elsif (en = '1') then				  -- is timer enabled?
			    if (timer_reg = 0) then			-- check if timer reached final count
				    done        <=	'1';	   	-- set irq output
			    else
				    timer_reg <= timer_reg - 1;	-- decrement timer until it reaches zero
			    end if;	
		    end if;			
      end if;
    end if;  
  end process timer_pr;

end rtl;