LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TFF_tb IS
END TFF_tb;

ARCHITECTURE behavior OF TFF_tb IS 
   
   COMPONENT TFF
    PORT(
         T : IN  std_logic;
         clk : IN  std_logic;
         set : IN std_logic;
         rst : IN  std_logic;
         Q : OUT  std_logic
        );
    END COMPONENT;
    
    component ha
    port(
    a: in std_logic;
    b: in std_logic;
    s: out std_logic;
    c: out std_logic
    );
    END component;
    
   signal T : std_logic := '0';
   signal clk : std_logic := '0';
   signal set : std_logic := '0';
   signal rst : std_logic := '0';
   signal Q : std_logic;
   
   signal a : std_logic := '0';
   signal b : std_logic := '0';
   signal s : std_logic;
   signal c : std_logic;


   constant clk_period : time := 10 ns;

BEGIN

   uut: TFF PORT MAP (
          T => s,
          clk => clk,
          set => set,
          rst => rst,
          Q => Q
        );
     
   ha0: HA PORT MAP (
        a => T,
        b => clk,
        s => s,
        c => c
        );
        
  clk_process :process
  begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
  if NOW > 300 ns then  -- Extended to allow more toggles
  wait;
  end if;
  end process;

 process
  type pattern_type is record
    -- Inputs of the T flip-flop.
    T, set, rst : std_logic;
    -- Expected output.
    Q_expected : std_logic;
  end record;
  
  -- The patterns to apply.
  type pattern_array is array (natural range <>) of pattern_type;
  constant patterns : pattern_array := (
    ('0', '0', '1', '0'), -- Reset: Q should be 0
    ('0', '0', '0', '0'), -- T=0, No toggle: Q remains 0
    ('1', '0', '0', '1'), -- T=1, Toggle: Q flips to 1
    ('1', '0', '0', '0'), -- T=1, Toggle: Q flips back to 0
    ('1', '0', '0', '1'),
    ('1', '1', '0', '1'), -- Set active: Q should be 1
    ('0', '1', '0', '1'), -- Set still active: Q remains 1
    ('0', '0', '0', '1'), -- T=0, No toggle: Q remains 1
    ('1', '0', '0', '0'), -- T=1, Toggle: Q flips back to 0
    ('0', '0', '1', '0')  -- Reset again: Q should be 0
  );

begin
  -- Check each pattern.
  for i in patterns'range loop
    -- Set the inputs.
    T   <= patterns(i).T;
    set <= patterns(i).set;
    rst <= patterns(i).rst;

    -- Wait for clock edge.
    wait until rising_edge(clk);
    
    -- Check the outputs.
    assert Q = patterns(i).Q_expected
      report "Test case " & integer'image(i) & " failed: Q was " & std_logic'image(Q)
      severity error;
  end loop;

  -- End of test message.
  assert false report "End of T flip-flop test" severity note;

  -- Wait forever to finish simulation.
  wait;
end process;
END;
