Please feel free to contact me (msrouji@stanford.edu, my name is Mario) for any questions, 
and also create issues for any problems you might have or features you want to see. 
I also encourage you to contribute to the codebase, or try case-studies of your own!

To come up with the generic SQED generator, we analyzed common parts of
the custom modules in "../custom-sqed-modules/" as an early case-study. From there, 
the tool has advanced to support far more generalized generation of SQED-related
modules, in order to allow for support of a wider-range of ISA's. We additionally 
have a beta-version of a generator that generates the Single Instruction Checking files.

Please familiarize yourself with Symbolic-Quick-Error-Detection (SQED) 
before diving into this code-base, as a lot of the details are necessary 
for knowing how the generators work, and for being able to sanity check the 
output of the generators (the verilog files). See here: http://theory.stanford.edu/~barrett/pubs/SLB+16.pdf 

###########################################
                                      SETUP
###########################################

The only setup you need to get started with the generator is Python: https://www.python.org/downloads/ 

This tool supports the usage of both Python2.7 and Python3 

###########################################
                                      USAGE
###########################################

To run the generation scripts, you need to define a format file similar to 
the ones in the FormatFiles directory, and optionally a COSA operator mapping 
file (more details below). Please see the README in the ../FormatFiles directory 
for more information. 

To run the main script, go to the Generators directory and run the generate_sqed.py 
script as in the following example:

How to run main script: python generate_sqed.py [FORMATFILE PATH] [OPTIONAL OUTPUTDIR PATH] [OPTIONAL COSA OPS FILE]

[FORMATFILE PATH] : Relative path to the format file for the desired ISA. Some examples are included in ../FormatFiles directory.

[OPTIONAL OUTPUTDIR PATH] : Relative path to directory that will hold the resulting 
outputted SQED files. This directory does not need to exist, as it will be 
created if it does not. If you do not specify the otuput directory path, then 
the tool will use the default created ../QEDFiles directory. Please do not delete this directory. 

[OPTIONAL COSA OPS FILE] : Relative path to the file that contains the mappings from 
the given ISA instructions to the corresponding COSA operations. An example COSAOPS 
file is included in this directory as an example mapping from RISCV to COSA (there are 
also non-RISCV instructions in there as placeholders for COSA operators). If file is not 
specified, then the SIC file generation is omitted. Currently the SIC files are outputted 
to the already existing ../SICFiles directory. 

Example run (for SQED generation only): python generate_sqed.py ../FormatFiles/RV32M-ridecore_format.txt ../QEDFiles

Example run (for SQED generation + SIC generation): python generate_sqed.py ../FormatFiles/RV32M-ridecore_format.txt ../QEDFiles ./COSA_OPS 

The first example will generate the SQED module for the ridecore processor, and will 
store the output files in the QEDFiles directory. The second example will do all 
of that, and also generate the Single Instruction Checking files to be inputted into the 
tool COSA. Note that this is still a beta-version. 

###########################################
  TECHNICAL DESCRIPTION OF TOOL AND PROCESS
###########################################

I am currently in the process of creating a Wiki for this project, going into 
far more detail on how the generators parse the format file, structure the ISA information, 
and generate the verilog files for the corresponding SQED module for the given ISA. It will 
also detail the ongoing effort on the Single Instruction Checking files generator, 
and the technical details. Stay-tuned, and in the meantime I encourage you to read 
through the code in this directory to get a feel for how the tool's logic works. 

I would first start by reading the format_parser.py code in the ../FormatParsers 
directory. This will help you understand how the tool parses and structures the relevant 
information from the ISA format file, which is a structured file that details 
the specification of a given ISA. (Please read the README in the ../FormatFiles directory 
for more information on how to create a format file). To give you an idea of how 
the code hierarchy is structured in this directory, here is a brief description:

Main Generators:

generate_sqed.py - This script is the 'main' script of the tool. It is in charge of 
parsing the command line args from the user (with error correction), calling the 
parser on the specified format file (and doing basic sanity checks and error detection), 
making sure the format file data has all the needed sections and information for the 
generators, launching each of the generators with the necessary inputs (and doing error detection), 
and finally outputting the verilog. 

constraint_generator.py - This script is in charge of generating the instruction_constraints.v 
file for the SQED module, which defines the constraints for each instruction in the ISA.

decoder_generator.py - This script is in charge of generating the qed_decoder.v file 
for the SQED module, which decodes which instruction type a given instruction is in the given ISA spec.

modify_generator.py - This script is in charge of generating the modify_instruction.v file 
for the SQED module, which takes in a given ISA instruction, and modifies it's fields in 
order to turn it into a SQED instruction (operating on different registers or memory).

qed_generator.py - This script is in charge of generating the qed.v file for the SQED module, 
which is the 'main' file, and instantiates all of the other required SQED modules described above, 
as well as the instruction mux and cache verilog files (which are automatically 
copied over / modified by the tool inside of the generate_sqed.py script).

SIC Generators (BETA-VERSION):

SIC_generator.py - This is the main (and only) file that generates the Single Instruction Checking 
text files, and .ssts files. This is a work in progress still, but it has a good amount of 
the generation automated already.

Miscellaneous:

clean.py - A simple script to delete files in the ../QEDFiles directory.

LICENSE.v - Contains the necessary license header that needs to be included in every file. 

COSA_OPS - File that contains mappings between the RISCV32 instructions and COSA operations (example file).
