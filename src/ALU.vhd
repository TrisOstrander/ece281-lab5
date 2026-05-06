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
           Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (7 downto 0);
           Cout : out STD_LOGIC);
        end component ripple_adder;
 signal w_adder_result : STD_LOGIC_VECTOR (7 downto 0);
 signal w_subtracter_result : STD_LOGIC_VECTOR (7 downto 0);
 signal w_B_inverted: STD_LOGIC_VECTOR (7 downto 0);
 signal w_result_internal : STD_LOGIC_VECTOR(7 downto 0);
 signal w_carry : STD_LOGIC;
 signal w_carry1 : STD_LOGIC;
 signal w_carry2: STD_LOGIC;
 signal w_overflow: STD_LOGIC;
begin
 adder: ripple_adder
 port map(
        A     => i_A,
        B     => i_B,
        Cin   => '0',
        S     => w_adder_result,
        Cout  => w_carry1
    );
 subtracter: ripple_adder
 port map(
        A     => i_A,
        B     => w_B_inverted,
        Cin   => '1',
        S     => w_subtracter_result,
        Cout  => w_carry2
    );
--Inverted B for subtraction
w_B_inverted <= not i_B;
--Result Calculation
w_result_internal <= w_adder_result      when (i_op = "000") else
                         w_subtracter_result when (i_op = "001") else
                         (i_A and i_B)       when (i_op = "010") else
                         (i_A or i_B)        when (i_op = "011") else
                         (others => '0');
o_result <= w_result_internal;
--Carry Flag
w_carry <= w_carry1  when (i_op = "000") else --Adder
           w_carry2 when (i_op = "001") else --Subtracter
           '0'; --AND + OR
--Overflow Flag
w_overflow <= ((i_A(7) and i_B(7) and not w_result_internal(7)) or 
               (not i_A(7) and not i_B(7) and w_result_internal(7))) 
               when (i_op = "000") else --Adder
              ((i_A(7) and not i_B(7) and not w_result_internal(7)) or 
               (not i_A(7) and i_B(7) and w_result_internal(7))) 
               when (i_op = "001") else  --Subtracter
              '0'; --AND + OR
--Flag Assigments
o_flags(3) <= w_result_internal(7); -- N
o_flags(2) <= '1' when w_result_internal = "00000000" else '0'; -- Z
o_flags(1) <= w_carry; -- C
o_flags(0) <= w_overflow; --V
end Behavioral;
