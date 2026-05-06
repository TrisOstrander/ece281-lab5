----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
 component ripple_adder is
        Port ( 
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (7 downto 0);
           Cout : out STD_LOGIC
           );
        end component ripple_adder;
        signal w_adder_null  : std_logic;
        signal w_adder_overflow : std_logic;
        signal w_adder_A : std_logic_vector(7 downto 0);
        signal w_adder_B : std_logic_vector(7 downto 0);
        signal w_adder_result : std_logic_vector(7 downto 0);
begin
 full_adder_1: ripple_adder
    port map(
        A     => w_adder_A,
        B     => w_adder_B,
        Cin   => w_adder_null,   -- Directly to input here
        S     => w_adder_result,
        Cout  => w_adder_overflow
    );
o_result <= (i_A and i_B) when (i_op = "010") else
            (i_A or i_B) when (i_op = "011") else
            w_adder_result;
end Behavioral;
