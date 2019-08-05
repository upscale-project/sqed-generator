# Copyright (c) Stanford University
#
# This source code is patent protected and being made available under the
# terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.

import copy
import sys
sys.path.append("../FormatParsers/")
sys.path.append("../Interface/")

import format_parser as P
import module_interface as I

# Format file
FILE = sys.argv[1]

# Grabs all global ISA format information
format_sections, format_dicts = P.parse_format(FILE)

# Get ISA information
isa_info = format_dicts["ISA"]
# Get register names
registers = format_dicts["REGISTERS"]
# Get memory fields needed for modification
memory = format_dicts["MEMORY"]
# Get constraints for qed module setup
qed_constraints = format_dicts["QEDCONSTRAINTS"]
# Get the instruction types
ins_types = format_dicts["INSTYPES"]
# Get the instruction fields for each type
ins_fields = format_dicts["INSFIELDS"]
# Get instruction types requirements
ins_reqs = format_dicts["INSREQS"]
# Get the bit fields
bit_fields = format_dicts["BITFIELDS"]
# Get all instruction types
instructions = {}
for ins in format_dicts["INSTYPES"].keys():
        if ins != "CONSTRAINT":
                    instructions[ins] = format_dicts[ins]

# Constraints file
from constraint_generator import *

MODULENAME = "inst_constraint"
INPUTS = {"clk": 1, "instruction": int(isa_info["instruction_length"])}
OUTPUTS = {}

verilog = generate_constraints_file(MODULENAME, INPUTS, OUTPUTS, FILE)

f = open("../QEDFiles/inst_constraints.v", 'w')
f.write(verilog)
f.close()

# Decoder file
from decoder_generator import *

MODULENAME = "qed_decoder"
INPUTS = {"ifu_qed_instruction": int(isa_info["instruction_length"])}
OUTPUTS = {}

verilog = generate_decoder_file(MODULENAME, INPUTS, OUTPUTS, FILE)

f = open("../QEDFiles/qed_decoder.v", 'w')
f.write(verilog)
f.close()

# Modify file
from modify_generator import *

MODULENAME = "modify_instruction"
INPUTS = {"qic_qimux_instruction": int(isa_info["instruction_length"])}
OUTPUTS = {"qed_instruction": int(isa_info["instruction_length"])}

verilog = generate_modify_file(MODULENAME, INPUTS, OUTPUTS, FILE)

f = open("../QEDFiles/modify_instruction.v", 'w')
f.write(verilog)
f.close()

# QED top file
from qed_generator import *

MODULENAME = "qed"
INPUTS = {"clk": 1, "ifu_qed_instruction": int(isa_info["instruction_length"]),
                "rst": 1, "ena": 1, "exec_dup": 1, "stall_IF": 1}
OUTPUTS = {"qed_ifu_instruction": int(isa_info["instruction_length"]), "vld_out": 1}

verilog = generate_qed_file(MODULENAME, INPUTS, OUTPUTS, FILE)

f = open("../QEDFiles/qed.v", 'w')
f.write(verilog)
f.close()



