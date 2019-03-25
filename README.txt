This is the SQED standalone module


Steps towards a generic module:
------------------------------

- set up a file format used as input of our tool

- take a present design and represent its ISA constraints in our format

- aim at an early executable version, likely incomplete but something
  that could be demonstrated. E.g., as a first version, could only
  generate the instruction constraints module from our file format
  while still manually construction the other submodules that are part
  of the QED module. Then we could gradually refine it.

- in the end, it would be nice to show a working demo using our
  workflow and integrate that with the Ridecore demo that we already
  have.

- Eventually we want to support also single instruction checking, but
  this does not have to be included in the very first version.

- as a good test case, should use OpenRISC 1200 as a showcase that our
  generic module also works with designs where we haven't applied SQED
  to.

Notes:
------

- ultimate goal: implement a tool which takes as input an ISA
  specification provided by the user. That specification file defines
  the instruction format, opcodes, etc. Given that specification, our
  tool automatically generates the Verilog files of the QED module.

- would be best to use Python to implement the tool since many people
  use it and it should be portable

  - regular expression library in Python:

    - https://docs.python.org/3/howto/regex.html
    - https://stackoverflow.com/questions/1921894/grep-and-python
    - https://stackoverflow.com/questions/47982949/how-to-parse-complex-text-files-using-python
    - https://docs.python.org/2/library/glob.html	


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

