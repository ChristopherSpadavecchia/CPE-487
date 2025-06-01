-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;

entity fsm is
	port (X, CLK, RESET: in std_logic;
    Y : out std_logic_vector(2 downto 0);
    Z : out std_logic);
end fsm;

 architecture fsmMealy11100 of fsm is
 	type state_type is (A, B, C, D, E);
    signal PS, NS : state_type := A;
    signal NZ : std_logic;
 begin 
 	clockAndReset: process(CLK, RESET)
     begin
     	if (RESET = '1') then
            PS <= A; -- Set previous state to A when reset is 1
            Z <= '0';
        elsif (rising_edge(CLK)) then 
            PS <= NS; -- Set previous state to next state on rising edge
            Z <= NZ;
        end if;
   	end process clockAndReset;
 -- A: 1/0 -> B 
 -- A: 0/0 -> A
 -- B: 1/0 -> C
 -- B: 0/0 -> A
 -- C: 1/0 -> D
 -- C: 0/0 -> A
 -- D: 1/0 -> D
 -- D: 0/0 -> E
 -- E: 1/0 -> B
 -- E: 0/1 -> A
     stateAndOutputLogic : process(PS, X)
     begin
     case PS is
     	when A =>
         	if (X = '1') then NZ<='0'; NS <= B;
             else NZ <= '0'; NS <= A;
             end if;
         when B =>
         	if (X = '1') then NZ <= '0'; NS <= C;
             else NZ <= '0'; NS <= A;
             end if;
         when C =>
         	if (X = '1') then NZ <= '0'; NS <= D;
             else NZ <= '0'; NS <= A;
             end if;
         when D =>
         	if (X = '1') then NZ <= '0'; NS <= D;
             else NZ <= '0'; NS <= E;
             end if;
         when E =>
         	if (X = '1') then NZ <= '0'; NS <= B;
             else NZ <= '1'; NS <= A;
             end if;
         end case;
     end process stateAndOutputLogic;
    
     with PS select
     Y <= "000" when A,
     	  "001" when B,
          "010" when C,
          "011" when D,
          "100" when E,
          "000" when others;
 end fsmMealy11100; 
 