--  https://ghdl.readthedocs.io/en/stable/using/QuickStartGuide.html
--  A testbench has no ports.
entity adder_tb is
end adder_tb;

architecture behav of adder_tb is
  --  Declaration of the component that will be instantiated.
  component adder
    port (i0, i1 : in bit; ci : in bit; s : out bit; co : out bit);
  end component;

  signal A, B, s, co : bit_vector(3 downto 0);
  signal ci: bit;
begin
  --  Component instantiation.
  adder_0: adder port map (i0 => A(0), i1 => B(0), ci => ci, s => s(0), co => co(0));
  adder_1: adder port map (i0 => A(1), i1 => B(1), ci => co(0), s => s(1), co => co(1));
  adder_2: adder port map (i0 => A(2), i1 => B(2), ci => co(1), s => s(2), co => co(2));
  adder_3: adder port map (i0 => A(3), i1 => B(3), ci => co(2), s => s(3), co => co(3));

  --  This process does the real job.
  process
    type pattern_type is record
      --  The inputs of the adder.
      i0, i1, ci : bit;
      --  The expected outputs of the adder.
      s, co : bit;
    end record;
    --  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (('0', '0', '0', '0', '0'),
       ('0', '0', '1', '1', '0'),
       ('0', '1', '0', '1', '0'),
       ('0', '1', '1', '0', '1'),
       ('1', '0', '0', '1', '0'),
       ('1', '0', '1', '0', '1'),
       ('1', '1', '0', '0', '1'),
       ('1', '1', '1', '1', '1'));
  begin
      A(1) <= '1';
      A(2) <= '1';
      A(3) <= '1';
    --  Check each pattern.
   for i in patterns'range loop
      --  Set the inputs.
      A(0) <= patterns(i).i0;
      B(0) <= patterns(i).i1;
      ci <= patterns(i).ci;
      --  Wait for the results.
      wait for 1 ns;
      --  Check the outputs.
      assert s(0) = patterns(i).s
        report "bad sum value" severity error;
      assert co(0) = patterns(i).co
        report "bad carry out value" severity error;
    end loop;
    assert false report "end of test" severity note;
    --  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
