This is the SQED standalone module

Notes:
------

- ultimate goal: implement a tool which takes as input an ISA
  specification provided by the user. That specification file defines
  the instruction format, opcodes, etc. Given that specification, our
  tool automatically generates the Verilog files of the QED module.

- would be best to use Python to implement the tool since many people
  use it and it should be portable

- instruction constraint can be obtained generated from a table in the
  ISA specification document. The designer has to convert the
  information in that table into our input format.

- we might want to abstract the fields of the instruction layout
  (opcode, func7, func3,...) as this is ISA dependent

- our format e.g.: list the following for every instruction

  ADD:
    opcode = ...
    func3 = ...
    func7 = ..
  ...

- make memory size a parameter

- see 'inst_constraints' files, these depend on the ISA

- module qed.v: maybe the i_cache will have to be parametrized

- not all instructions are present in every ISA, e.g. ORBIS has EXT
  instructions which e.g. Ridecore has not

- module modify_instructions.v: might need different numbers of
  parameters, depending on ISA

