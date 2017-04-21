------------------------------------------------------------------
-- Name		   : tb_tim_blk.vhd
-- Description : Testbench for top.vhd (timer block)
-- Designed by : Claudio Avi Chami - FPGA Site
-- Date        : 26/03/2016
-- Version     : 01
------------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_textio.all;
	  use ieee.numeric_std.ALL;
    use work.top_pack.all;
   
entity tb_tim_blk is
end entity;

architecture test of tb_tim_blk is

  constant PERIOD  : time   := 20 ns;
	
  signal clk       : std_logic := '0';
  signal rst       : std_logic := '1';
    
	signal load      : std_logic;
	signal load_sel  : std_logic_vector (VEC_W-1 downto 0) := (others => '0');
	signal sel       : std_logic_vector (VEC_W-1 downto 0) := (others => '0');

	signal en        : std_logic_vector (TIMERS-1 downto 0) := (others => '0');
  signal data_in   : std_logic_vector (DATA_W-1 downto 0);
  signal data_out  : std_logic_vector (DATA_W-1 downto 0);
  signal done_vec  : std_logic_vector (TIMERS-1 downto 0);
  signal endSim	 : boolean   := false;

  component top_timer_blk  is
	port (
		clk: 		  in std_logic;
		rst: 		  in std_logic;
		
		-- inputs
		data_in:	in std_logic_vector (DATA_W-1 downto 0);	-- Data bus, connected to all timers
		load: 		in std_logic;		
		load_sel:	in std_logic_vector (VEC_W-1 downto 0);		-- Select what timer to load
																-- the data_out bus - for debug
		en:			  in std_logic_vector (TIMERS-1 downto 0);	-- enable, one for each timer									
		
		done_vec:	out std_logic_vector (TIMERS-1 downto 0)	-- done vector - one for each timer
	);
  end component;
    

begin
    clk     <= not clk after PERIOD/2;
    rst     <= '0' after  PERIOD*10;

	-- Main simulation process
	process 
	begin
	
		wait until (rst = '0');
		wait until (rising_edge(clk));

		-- Set and start timers 0, 1 and 11
		data_in 	<= x"0000_0011";
		load_sel	<= x"0";
		load		  <= '1';
		wait until (rising_edge(clk));
		load		  <= '0';
		wait until (rising_edge(clk));
		data_in 	<= x"0000_0007";
		load_sel	<= x"1";
		load		  <= '1';
		wait until (rising_edge(clk));
		load		<= '0';
		wait until (rising_edge(clk));
		data_in 	<= x"0000_0009";
		load_sel	<= x"B";
		load		  <= '1';
		wait until (rising_edge(clk));
		load		<= '0';
		wait until (rising_edge(clk));

    -- Enable timers
		en(0)		<= '1';
    en(1)   <= '1';
    en(11)  <= '1';
    wait until (rising_edge(clk));


		-- restart timer 11 when done
		wait until (done_vec(11) = '1');
		wait until (rising_edge(clk));
		data_in 	<= x"0000_0003";
		load_sel	<= x"B";
		load		  <= '1';
		wait until (rising_edge(clk));
		load		  <= '0';
		wait until (rising_edge(clk));
		
		wait until (done_vec(11) = '1');
		wait for 400 ns;
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

    top_inst : top_timer_blk
    port map (
      clk      => clk,
      rst	     => rst,
		
      data_in  => data_in,
      load     => load,
      load_sel => load_sel,
      en       => en,
		
		  done_vec => done_vec
    );

end architecture;