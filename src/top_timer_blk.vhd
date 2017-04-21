------------------------------------------------------------------
-- Name		     : top_timer_blk.vhd
-- Description : Top level that implements a block of timers
-- Designed by : Claudio Avi Chami - FPGA Site
--               fpgasite.blogspot.com
-- Date        : 21/04/2017
-- Version     : 01
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.top_pack.all;

entity top_timer_blk is 
	port (
		clk: 		   in std_logic;
		rst: 	  	 in std_logic;
		
		-- inputs
		data_in:	 in std_logic_vector (DATA_W-1 downto 0);	-- Data bus, connected to all timers
		load:		   in std_logic;						             		-- Load control common to all timers
		load_sel:	 in std_logic_vector (VEC_W-1 downto 0);	-- Select what timer to load
		en:			   in std_logic_vector (TIMERS-1 downto 0);	-- enable, one for each timer									
		
		done_vec:	 out std_logic_vector (TIMERS-1 downto 0)	-- done vector - one for each timer
	);
end top_timer_blk;


architecture rtl of top_timer_blk is

component timer is 
	port (
		clk: 		   in std_logic;
		rst: 		   in std_logic;
		
		-- inputs
		data_in:	 in std_logic_vector (DATA_W-1 downto 0);
		load: 		 in std_logic;
		en:			   in std_logic;
		
		done:		   out std_logic
	);
end component;

signal load_vec : std_logic_vector (TIMERS-1 downto 0);

begin 

	demux: process(load_sel, load)
	begin
		-- set all to 0
		load_vec <= (others => '0');
		-- Set load signal to the addressed timer
		load_vec(to_integer(unsigned(load_sel))) <= load;
	end process;

	GEN_TIMER: 
	for I in 0 to TIMERS-1 generate
		TMRX : timer 
			 port map
			(
				clk		  => clk,
				rst		  => rst,
				data_in	=> data_in,
				load	  => load_vec(I),
				en		  => en(I),
				done	  => done_vec(I)		
			);
	end generate GEN_TIMER;

end rtl;