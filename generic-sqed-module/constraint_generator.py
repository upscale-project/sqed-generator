import format_parser as P
import module_interface as I

bit_codes, instruction_codes = P.parse_format("RV32M-ridecore_format.txt")

constraints_file = I.module_header("inst_constraint", ["clk", "instruction"], [])

constraints_file += "\n"
constraints_file += "\n"
constraints_file += I.signal_def(1, "input", "clk", num_spaces=2)
constraints_file += "\n"
constraints_file += I.signal_def(32, "input", "instruction", num_spaces=2)
constraints_file += "\n"

constraints_file += "\n"
for bit_code in bit_codes:
    msb, lsb = bit_codes[bit_code]
    bits = int(msb) - int(lsb) + 1
    constraints_file += I.signal_def(bits, "wire", bit_code, num_spaces=2)
    constraints_file += "\n"

constraints_file += "\n"
for instruction_code in instruction_codes:
    constraints_file += I.signal_def(1, "wire", instruction_code, num_spaces=2)
    constraints_file += "\n"

constraints_file += "\n"
for bit_code in bit_codes:
    msb, lsb = bit_codes[bit_code]
    constraints_file += I.assign_def(bit_code, I.signal_index("instruction", msb, lsb), num_spaces=2)
    constraints_file += "\n"

constraints_file += "\n"
for instruction_code in instruction_codes:
    codes = instruction_codes[instruction_code]
    constraints = []
    for code in codes:
        req = codes[code]
        constraint = I._equals(code, I._constant(len(req), req), parens=True)
        constraints.append(constraint)

    expression = constraints[0]
    for i in range(1, len(constraints)):
        expression = I._and(expression, constraints[i], parens=False)
    constraints_file += I.assign_def(instruction_code, expression, num_spaces=2)
    constraints_file += "\n"

constraints_file += "\n"
constraints_file += I.module_footer()

f = open("inst_constraints.v", 'w')
f.write(constraints_file)
f.close()









