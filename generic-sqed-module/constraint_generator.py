import module_interface as I

f = open("RV32M-ridecore_format.txt", 'r')
lines = f.readlines()

num_registers = lines[0]
reg_index = num_registers.find("=")
num_registers = num_registers[reg_index+2:]

lines = lines[1:]
while lines[0] == "\n":
    lines = lines[1:]

bit_codes = {}

while lines[0] != "\n":
    code = lines[0]
    code_end = code.find(":")
    code_name = code[1:code_end]
    code_bits = code[code_end+2:].split()
    code_bits = (code_bits[0], code_bits[1])

    bit_codes[code_name] = code_bits
    lines = lines[1:]

while lines[0] == "\n":
    lines = lines[1:]

instruction_codes = {}

while True:
    if lines == []:
        break
    elif lines[0][0] == "_" or lines[0] == "\n":
        lines = lines[1:]
        continue
    else:
        if lines[0].find(":") != -1:
            instruction_name = lines[0]
            instruction_name = instruction_name[0:-2]
            lines = lines[1:]
            instruction_reqs = {}
            while lines[0] != "\n":
                req = lines[0]
                req_index = req.find("=")
                req_name = req[0:req_index-1]
                req = req[req_index+2:-1]
                instruction_reqs[req_name] = req
                lines = lines[1:]
            instruction_codes[instruction_name] = instruction_reqs
        else:
            lines = lines[1:]

f.close()

constraints_file = I.module_header("inst_constraint", ["clk", "instruction"], [], num_spaces=2)

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









