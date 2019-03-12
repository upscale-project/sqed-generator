This directory will store the template text file. This text file will 
explain all of the different fields required for an ISA.

In the future, when automation is complete, the designer will then provide this 
template text file to the tool. From this text file, a parser will extract all
of the different bit patterns and instructions needed to represent the ISA. It will
spit out the inst_constraint.sv, qed_decoder.sv, and modify_instruction.sv files
needed to generate the entire QED module.