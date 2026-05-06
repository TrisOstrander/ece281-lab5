----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller_fsm is
    Port ( i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is
 
    -- Below you create a new variable type! You also define what values that 
    -- variable type can take on. Now you can assign a signal as 
    -- "sm_floor" the same way you'd assign a signal as std_logic
	type controllerState is (state0, state1, state2, state3);
	
	-- Here you create variables that can take on the values defined above. Neat!	
	signal currentState, nextState : controllerState;

begin

	-- CONCURRENT STATEMENTS ------------------------------------------------------------------------------
	-- Next State Logic            
  	currentState <=  state0 when (i_reset = '1' or (currentState = state3 and i_adv = '1')) else
	               currentState'succ(currentState) when ( i_adv = '1' and i_reset = '0' ) else -- going up
	                currentState;
           
	-- Output logic
	with currentState select
	o_cycle <= "1000" when state0,
	           "0100" when state1,
	           "0010" when state2,
	           "0001" when state3,
	           "1000" when others;
      


end FSM;
