------------------------------------------------------------------
-- Name		     : top_pack.vhd
-- Description : Package file for top_timer_blk
-- Designed by : Claudio Avi Chami - FPGA Site
-- Date        : 21/04/2017
-- Version     : 01
------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package top_pack  is

-------------------------------------------------------------------------
-- Data size definitions
------------------------------------------------------------------------- 
  constant DATA_W   	: natural := 32;			-- Width of each timer
  constant TIMERS		  : natural := 16;			-- Quantity of timers in block
  constant VEC_W  		: integer := integer(ceil(log2(real(TIMERS))));	

end top_pack;

