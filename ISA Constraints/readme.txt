This directory will contain the instruction constraints for different ISAs. 

Right now these instruction constraints are stored as System Verilog files containing constants 
corresponding the the bit patterns needed for the ISA. These can be included in formal analysis
in order to ensure that in each clock cycle, the current fetched instruction is valid, and
uses the proper register identifiers to create a valid QED test when used with the QED module.

EDIT (3/12/2019): In the RV32M Inst_Constraint file, the memory addresses for
"original" memory are those which have all top 7 bits set to 0. This corresponds
to the memory I used for Vscale for the Vscale bugs. Instead, for RIDECORE, the
memory would only set the top 2 bits to 0 for the orignal addresses.

Both the Inst_Constraint and Modify_Instruction files in the QED module need to 
correspond to one another. Eventually, address range for original and duplicate
memories will be a parameter for the module.