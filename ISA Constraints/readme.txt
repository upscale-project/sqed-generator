This directory will contain the instruction constraints for different ISAs. 

Right now these instruction constraints are stored as System Verilog files containing constants 
corresponding the the bit patterns needed for the ISA. These can be included in formal analysis
in order to ensure that in each clock cycle, the current fetched instruction is valid, and
uses the proper register identifiers to create a valid QED test when used with the QED module.