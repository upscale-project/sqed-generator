import format_parser as P
import module_interface as I

bit_codes, instruction_codes = P.parse_format("RV32M-ridecore_format.txt")

inputs = ["ifu_qed_instruction", "rst", "ena", "clk", "exec_dup", "stall_IF"]
outputs = ["qed_ifu_instruction", "vld_out"]

constraints_file = I.module_header("qed", inputs, outputs)

constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.signal_def(32, "output", "qed_ifu_instruction", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(1, "output", "vld_out", num_spaces=2)
constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.signal_def(32, "input", "ifu_qed_instruction", num_spaces=2)
constraints_file += "\n"

for inp in inputs[1:]:
    constraints_file += I.signal_def(1, "output", inp, num_spaces=2)
    constraints_file += "\n"

constraints_file += "\n"

for bit_code in bit_codes:
    msb, lsb = bit_codes[bit_code]
    constraints_file += I.signal_def(int(msb)-int(lsb)+1, "wire", bit_code, num_spaces=2)
    constraints_file += "\n"

constraints_file += "\n"

constraints_file += I.signal_def(1, "wire", "is_lw", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(1, "wire", "is_sw", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(1, "wire", "is_aluimm", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(1, "wire", "is_alureg", num_spaces=2)
constraints_file += "\n"

constraints_file += "\n"

constraints_file += I.signal_def(32, "wire", "qed_instruction", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(32, "wire", "qic_qimux_instruction", num_spaces=2)
constraints_file += "\n"

constraints_file += "\n"

constraints_file += I.module_def("qed_decoder", "dec",
                                 list(bit_codes.keys())+["is_lw", "is_sw", "is_alureg", "is_aluimm"],
                                 num_spaces=2)

constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.module_def("modify_instruction", "minst",
                                 ["qed_instruction", "qic_qimux_instruction"]+list(bit_codes.keys())+["is_lw", "is_sw", "is_alureg", "is_aluimm"],
                                 num_spaces=2)

constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.module_def("qed_instruction_mux", "imux",
                                 ["qed_ifu_instruction", "ifu_qed_instruction", "qed_instruction", "exec_dup", "ena"],
                                 num_spaces=2)

constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.module_def("qed_i_cache", "qic",
                                 ["qic_qimux_instruction", "vld_out", "clk", "rst", "exec_dup", "IF_stall", "ifu_qed_instruction"],
                                 num_spaces=2)

constraints_file += "\n"
constraints_file += "\n"

constraints_file += I.module_footer()

f = open("qed.v", 'w')
f.write(constraints_file)
f.close()









