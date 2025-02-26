--  https://electronicstopper.blogspot.com/2017/07/t-flip-flop-in-vhdl-with-testbench.html
library ieee;
use ieee.std_logic_1164.all;

entity TFF is
port( T: in std_logic;
clk: in std_logic;
rst: in std_logic;
set: in std_logic;
Q: out std_logic);
end TFF;

architecture behavioral of TFF is
signal Q_prev: std_logic := '0';
begin
process(rst,set,clk,T)
begin
if (set='1') then
Q_prev<='1';
elsif (rst='1') then
Q_prev<='0';
elsif(rising_edge(clk)) then
Q_prev <= T XOR Q_prev;
end if;
end process;
Q <= Q_prev;
end behavioral;
