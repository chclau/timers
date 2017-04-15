------------------------------------------------------------------
-- Name		     : tb_timer.vhd
-- Description : Testbench for timer.vhd
-- Designed by : Claudio Avi Chami - FPGA Site
-- Date        : 15/04/2017
-- Version     : 01
------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_textio.all;
	use ieee.numeric_std.ALL;
    use std.textio.all;
    
entity tb_timer is
end entity;

architecture test of tb_timer is

    constant PERIOD  : time   := 20 ns;
    constant DATA_W  : natural := 4;
	
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '1';
    signal load      : std_logic := '0';
    signal en        : std_logic := '0';
    signal done      : std_logic ;
    signal data_in   : std_logic_vector (3 downto 0);
    signal endSim	   : boolean   := false;

  component timer  is
	  generic (
		  DATA_W		: natural := 32
	  );
	  port (
		  clk: 		   in std_logic;
		  rst: 		   in std_logic;
		
		  -- inputs
		  data_in:	 in std_logic_vector (DATA_W-1 downto 0);
		  load: 		 in std_logic;
		  en:			   in std_logic;
		
		  -- outputs
  		done:		out std_logic
	  );
  end component;
    
begin
    clk     <= not clk after PERIOD/2;
    rst     <= '0' after  PERIOD*10;

	-- Main simulation process
	main_pr : process 
	begin
		wait until (rst = '0');
		wait until (rising_edge(clk));

		data_in <= x"3";
		load	<= '1';
		wait until (rising_edge(clk));
		load	<= '0';
		wait until (rising_edge(clk));
		en		<= '1';

		wait until (done = '1');
		wait until (rising_edge(clk));

		data_in <= x"7";
		load	<= '1';
		en		<= '0';
		wait until (rising_edge(clk));
		load	<= '0';
		wait until (rising_edge(clk));
		en		<= '1';
		wait until (rising_edge(clk));
		en		<= '0';
		wait until (rising_edge(clk));
		en		<= '1';
		wait until (done = '1');
		wait until (rising_edge(clk));
		wait until (rising_edge(clk));
		endSim  <= true;
	end	process;	
		
	-- End the simulation
	process 
	begin
		if (endSim) then
			assert false 
				report "End of simulation." 
				severity failure; 
		end if;
		wait until (rising_edge(clk));
	end process;	

  timer_inst : timer
    generic map (
	  	DATA_W	 => DATA_W
	  )
    port map (
        clk      => clk,
        rst	     => rst,
		
        data_in  => data_in,
        load     => load,
        en       => en,
		
		    done	   => done
    );

end architecture;