-------
License
-------

See LICENSE-GOV.txt and LICENSE-ACADEMIC.txt in the ./SQED-Generator directory.

-------------------
General information
-------------------

This repository contains material related to our generic SQED
module.

Based on discussions, we had envisioned two possible ways to implement a
generic QED module:

1.) A generic implementation in Verilog that is parameterized by
    design specific properties such as instruction format, opcodes,
    instruction types, etc.

2.) A compilation approach where the designer specifies the ISA of the
    given design in a predefined, structured format that we
    formulate. We implement a tool that parses the specification file
    provided by the designer in our format and automatically generate
    the Verilog sources of the QED module for the given design.

    File 'notes-on-compilation-workflow.txt' contains some notes on
    that approach.

The difference between these two approaches is that the
parameterization is either reflected directly in Verilog (1.) or in
the specification file from which customized Verilog sources are
generated (2.).

Either of the above variants should result in a generic QED module
that is easily customizable. Here, we chose to go with option (2.).

See the README.txt file in ./SQED-Generator directory.

-------------------------------
Documentation and publications:
-------------------------------

The document './Auto-SQED.pdf' provides a detailed technical
description of our generator approach.

A related paper appeared at ICCAD 2019:

F. Lonsing, K. Ganesan, M. Mann, S. Nuthakki, E. Singh, M. Srouji,
Y. Yang, S. Mitra, and C. Barrett: Unlocking the Power of Formal
Hardware Verification with CoSA and Symbolic QED. Invited paper. In
Proc. 2019 International Conference on Computer Aided Design
(ICCAD). IEEE, 2019.

---------------------------
Organization of repository:
---------------------------

Directory 'SQED-Generator':

Contains all scripts, documentation, and text files related to
the generic SQED generators. 

Directory 'custom-sqed-modules':

A collection of QED modules (Verilog sources) that we already
have. These modules are custom for particular designs.

Directory 'doc':

A collection of ISA specification documents that we will need to
formulate the textual description files for our generator workflow.

Directory 'isa-constraints':

Instruction constraints files of the custom QED modules we have
collected.

Directory 'materials':

Contains various material related to SQED such as slides etc.
