import module_interface as I

def parse_format(filename):
    f = open(filename, 'r')
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

    f.close()

    return bit_codes, instruction_codes

