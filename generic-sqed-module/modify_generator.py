import format_parser as P
import module_interface as I

bit_codes, instruction_codes = P.parse_format("RV32M-ridecore_format.txt")

inputs = ["qic_qimux_instruction", "is_lw", "is_sw",
          "is_aluimm", "is_alureg",
          "rd", "rs1", "rs2",
          "opcode", "simm12",
          "funct3", "funct7",
          "imm5", "simm7", "shamt"]

constraints_file = I.module_header("modify_instruction", inputs, ["qed_instruction"])

constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.signal_def(32, "output", "qed_instruction", num_spaces=2)
constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.signal_def(32, "input", "qic_qimux_instruction", num_spaces=2)
constraints_file += "\n"

for inp in inputs[1:]:
    if inp in bit_codes:
        msb, lsb = bit_codes[inp]
        msb = int(msb)
        lsb = int(lsb)
        bit_width = msb - lsb + 1
        constraints_file += I.signal_def(bit_width, "output", inp, num_spaces=2)
        constraints_file += "\n"
    else:
        constraints_file += I.signal_def(1, "output", inp, num_spaces=2)
        constraints_file += "\n"

constraints_file += "\n"

constraints_file += I.signal_def(32, "wire", "ins_lw", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(32, "wire", "ins_sw", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(32, "wire", "ins_alureg", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(32, "wire", "ins_aluimm", num_spaces=2)
constraints_file += "\n"

constraints_file += "\n"

constraints_file += I.signal_def(5, "wire", "new_rd", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(5, "wire", "new_rs1", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(5, "wire", "new_rs2", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(12, "wire", "new_simm12", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(7, "wire", "new_simm7", num_spaces=2)
constraints_file += "\n"

constraints_file += "\n"

constraints_file += I.assign_def("new_rd",
                               I.inline_conditional(I._equals("rd", "5'b00000", True), "rd", I.bit_vector(["1'b1", I.signal_index("rd", "3", "0")]), False),
                               num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("new_rs1",
                               I.inline_conditional(I._equals("rs1", "5'b00000", True), "rs1", I.bit_vector(["1'b1", I.signal_index("rs1", "3", "0")]), False),
                               num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("new_rs2",
                               I.inline_conditional(I._equals("rs2", "5'b00000", True), "rs2", I.bit_vector(["1'b1", I.signal_index("rs2", "3", "0")]), False),
                               num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("new_simm12", I.bit_vector(["2'b01", I.signal_index("simm12", "9", "0")]), num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("new_simm7", I.bit_vector(["2'b01", I.signal_index("simm7", "4", "0")]), num_spaces=2)
constraints_file += "\n"

constraints_file += "\n"

constraints_file += I.assign_def("ins_lw", I.bit_vector(["new_simm12", "5'b00000", "funct3", "new_rd", "opcode"]), num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("ins_sw", I.bit_vector(["new_simm7", "new_rs2", "5'b00000", "funct3", "imm5", "opcode"]), num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("ins_aluimm", I.bit_vector(["simm12", "new_rs1", "funct3", "new_rd", "opcode"]), num_spaces=2)
constraints_file += "\n"
constraints_file += I.assign_def("ins_alureg", I.bit_vector(["funct7", "new_rs2", "new_rs1", "funct3", "new_rd", "opcode"]), num_spaces=2)
constraints_file += "\n"

constraints_file += "\n"

constraints_file += "  assign qed_instruction = is_lw ? ins_lw : (is_sw ? ins_sw : (is_alureg ? ins_alureg : (is_aluimm ? ins_aluimm : instruction)));"
constraints_file += "\n"

constraints_file += "\n"
constraints_file += I.module_footer()

f = open("modify_instruction.v", 'w')
f.write(constraints_file)
f.close()









