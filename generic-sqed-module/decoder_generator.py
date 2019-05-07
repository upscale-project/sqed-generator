import format_parser as P
import module_interface as I

bit_codes, instruction_codes = P.parse_format("RV32M-ridecore_format.txt")

outputs = ["is_lw", "is_sw",
          "is_aluimm", "is_alureg",
          "rd", "rs1", "rs2",
          "opcode", "simm12",
          "funct3", "funct7",
          "imm5", "simm7", "shamt"]

constraints_file = I.module_header("qed_decoder", ["ifu_qed_instruction"], outputs)

constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.signal_def(32, "input", "ifu_qed_instruction", num_spaces=2)
constraints_file += "\n"
constraints_file += "\n"

for out in outputs:
    if out in bit_codes:
        msb, lsb = bit_codes[out]
        msb = int(msb)
        lsb = int(lsb)
        bit_width = msb - lsb + 1
        constraints_file += I.signal_def(bit_width, "output", out, num_spaces=2)
        constraints_file += "\n"
    else:
        constraints_file += I.signal_def(1, "output", out, num_spaces=2)
        constraints_file += "\n"

constraints_file += "\n"

for bit_code in bit_codes:
    msb, lsb = bit_codes[bit_code]
    constraints_file += I.assign_def(bit_code, I.signal_index("ifu_qed_instruction", msb, lsb), num_spaces=2)
    constraints_file += "\n"

constraints_file += "\n"

constraints_file += I.assign_def("is_lw", "(opcode == 7'b0000011) && (funct3 == 3'b010)", num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("is_sw", "(opcode == 7'b0100011) && (funct3 == 3'b010)", num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("is_alureg", "(opcode == 7'b0110011)", num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("is_aluimm", "(opcode == 7'b0010011)", num_spaces=2)
constraints_file += "\n"

constraints_file += "\n"
constraints_file += I.module_footer()

f = open("qed_decoder.v", 'w')
f.write(constraints_file)
f.close()









