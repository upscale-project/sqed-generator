# Copyright (c) Stanford University
#
# This source code is patent protected and being made available under the
# terms explained in the ../LICENSE-Academic and ../LICENSE-GOV files.

# Author: Mario J Srouji
# Email: msrouji@stanford.edu

import re
import copy
import sys
sys.path.append("../FormatParsers/")
sys.path.append("../Interface/")

import format_parser as P
import module_interface as I

def take(outer_dict):
    l = outer_dict.keys()
    l.remove("CONSTRAINT")
    return l[0], outer_dict[l[0]]

def take_all(outer_dict):
    l = outer_dict.keys()
    l.remove("CONSTRAINT")
    return l, [outer_dict[l[i]] for i in range(len(l))]

def wrap(expression, bits, value, end=True):
    final = "(" + expression + " = " + value + "_" + bits + ")"
    if end:
        return final + ";"
    else:
        return final 

def apply_operator(arg1, arg2, op):
    if op is None:
        return arg1
    else:
        return "(" + arg1 + " " + op + " " + arg2 + ")"

def property_result(expression, value):
    return "(" + expression + " = " + value + ")"

def check_type(ins, types, format_dicts):
    for ins_type in types:
        if ins in format_dicts[ins_type]:
            return True
    return False

def build_operator_bank(OPSFILE):
    f = open(OPSFILE, 'r')
    lines = f.readlines()
    f.close()

    ins2cosa = {}
    for line in lines:
        definition = line.split(":")
        ins2cosa[definition[0]] = definition[1][0:-1]
    
    return ins2cosa

def find_cosa_operator(ins, ins2cosa):
    for key in ins2cosa:
        if key in ins:
            return ins2cosa[key]
    
    return None

def get_ins_type_def(ins, ins_types, format_dicts):
    if len(ins_types["CONSTRAINT"]) > 0:
        ins_types_defs = {}
        for c in ins_types["CONSTRAINT"]:
            parts = c.split(",")
            for t in parts[1:]:
                ins_types_defs[t] = parts[0]

        for t in ins_types:
            if t != "CONSTRAINT":
                if ins in format_dicts[t]:
                    return ins_types_defs[t]
            
        return None
    else:
        return None

def generate_init_ssts_file():
    pass

def generate_nop_ssts_file():
    text = ""

    # INPUT
    text += "INPUT"
    text += 2*"\n"

    # OUTPUT
    text += "OUTPUT"
    text += 2*"\n"

    # STATE
    text += "STATE"
    text += 2*"\n"

    # INIT
    text += "INIT"
    text += 2*"\n"

    # INVAR
    text += "INVAR"
    text += "\n"

    # TODO fix
    state_counter = "state_counter"
    module_name = "inst_constraint0"
    NOP = "NOP"

    text += "(" + state_counter + " >= 2_10) -> " + "(" + module_name + "." + NOP + " = 1_1);"
    text += 2*"\n"

    # TRANS
    text += "TRANS"

    f = open("../SICFiles/nop_m.ssts", 'w')
    f.write(text)
    f.close()

def generate_counter_ssts_file():
    text = ""

    # INPUT
    text += "INPUT"
    text += 2*"\n"

    # OUTPUT
    text += "OUTPUT"
    text += 2*"\n"

    # STATE
    text += "STATE"
    text += "\n"

    # TODO fix
    state_counter = "state_counter"
    bits = 10

    text += state_counter + " : " + "BV" + "(" + str(bits)+ ")" + ";"
    text += 2*"\n"

    # INIT 
    text += "INIT"
    text += "\n"
    text += state_counter + " = " + "0_" + str(bits) + ";"
    text += 2*"\n"

    # INVAR
    text += "INVAR"
    text += 2*"\n"

    # TRANS
    text += "TRANS"
    text += "\n"
    text += "next(" + state_counter + ")" + " = " + state_counter + " + " + "1_" + str(bits) + ";"

    f = open("../SICFiles/state_counter.ssts", 'w')
    f.write(text)
    f.close()

def generate_copy_ssts_file(bit_fields):
    text = ""

    # INPUT
    text += "INPUT"
    text += 2*"\n"

    # OUTPUT
    text += "OUTPUT"
    text += 2*"\n"

    # TODO STATE needs extension
    text += "STATE"
    text += "\n"
    for bit_field in bit_fields:
        if bit_field != "CONSTRAINT":
            msb, lsb = bit_fields[bit_field].split()
            bits = int(msb) - int(lsb) + 1
            
            text += bit_field + "_copy" + " : " + "BV" + "(" + str(bits)+ ")" + ";"
            text += "\n"


    text += "\n"

    # TODO INIT needs extension
    text += "INIT"
    text += "\n"
    for bit_field in bit_fields:
        if bit_field != "CONSTRAINT":
            msb, lsb = bit_fields[bit_field].split()
            bits = int(msb) - int(lsb) + 1
            
            text += bit_field + "_copy" + " = " + "0_" + str(bits) + ";"
            text += "\n"

    text += "\n"

    # INVAR
    text += "INVAR"
    text += 2*"\n"

    # TODO: TRANS needs extension
    text += "TRANS"
    text += "\n"

    # TODO: fix state_counter
    state_counter = "state_counter"
    check = state_counter + " = " + "1_10"
    for bit_field in bit_fields:
        if bit_field != "CONSTRAINT":
            copied =  bit_field + "_copy"
            # TODO: inline conditional - support more instructions
            text += "next(" + copied + ")" + " = " + I.inline_conditional(check, bit_field, copied, True)
            text += "\n"
            
    f = open("../SICFiles/state_copy.ssts", 'w')
    f.write(text)
    f.close()

def generate_SIC_files(format_dicts, OPSFILE):
    # Single instruction checking information
    SIC_info = format_dicts["SIC"]
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
    for instype in format_dicts["INSTYPES"].keys():
        if instype != "CONSTRAINT":
            for ins in format_dicts[instype]:
                if ins != "CONSTRAINT":
                    instructions[ins] = format_dicts[instype][ins]

    # Generates .ssts files for COSA 
    generate_copy_ssts_file(bit_fields)
    generate_counter_ssts_file()
    generate_nop_ssts_file()

    # Gather all needed data from format file 
    reset, reset_bits = take(SIC_info["RESET"]) 
    counter, counter_bits = take(SIC_info["COUNTER"]) 
    module, _ = take(SIC_info["MODULENAME"])
    regfile, _ = take(SIC_info["REGFILE"])
    memory, _ = take(SIC_info["MEMORY"])
    destination_reg, _ = take(SIC_info["DESTINATIONREG"])
    immediate, _ = take(SIC_info["IMMEDIATE"])

    reg_vals, reg_vals_bits = take_all(SIC_info["REGVALUE"])
    delay, delay_vals = take_all(SIC_info["DELAY"])
                
    ins2cosa = build_operator_bank(OPSFILE)

    # Generates all SIC files for each instruction
    for ins in instructions:
        # Text file
        text = ""

        sections = ["GENERAL", "DEFAULT", "CHECK"]
        for section in sections:
            if section == "CHECK":
                text += "[" + section + " for " + ins + "]"
            else:
                text += "[" + section + "]"
            text += "\n"

            section_info = SIC_info[section]
            for definition in section_info:
                if definition == "CONSTRAINT":
                    continue
                else:
                    text += definition + ": "
                    if type(section_info[definition]) == type([]):
                        for val in section_info[definition]:
                            text += val + ","
                        text = text[:-1]
                    else:
                        text += section_info[definition]
                    
                    text += "\n"

            if section == "CHECK":
                text += "assumptions: "
                text += wrap(reset, reset_bits, isa_info["active_low"])
                text += wrap(counter, counter_bits, "0", end=False)
                text += " -> "
                text += wrap(module+"."+ins, "1", "1")
                text += wrap(counter, counter_bits, "1", end=False)
                text += " -> "
                text += "("
                text += wrap(module+"."+ins, "1", "1", end=False)
                for constraint in SIC_info["ASSUMPTIONS"]["CONSTRAINT"]:
                    parts = constraint.split(",")
                    affected_types = parts[0:-1]
                    requirement = parts[-1]
                    if check_type(ins, affected_types, format_dicts):
                        text += " & "
                        text += requirement
                text += ");"

                text += "\n"
                text += "properties: "
                cycle_delay = int(delay_vals[delay.index(ins)]) if ins in delay else 0
                text += wrap(counter, counter_bits, str(1 + int(isa_info["pipeline_depth"]) + cycle_delay), end=False)
                text += " -> "
                
                cosa_op = find_cosa_operator(ins, ins2cosa)

                ins_type_def = get_ins_type_def(ins, ins_types, format_dicts)
                if ins_type_def is None:
                    continue 
    
                # TODO fix arg1 and value 
                if ins_type_def == "MEMORYTYPE":
                    arg1 = memory
                    arg2 = None
                    value = regfile + "[" + destination_reg + "]"

                # TODO: fix arg2 immediate fields used (shimm needed etc...)
                elif ins_type_def == "IMMEDIATETYPE":
                    arg1 = min(reg_vals)
                    arg2 = immediate
                    value = regfile + "[" + destination_reg + "]"

                # TODO: SLTU etc... are not correct 
                elif ins_type_def == "REGISTERTYPE":
                    arg1 = min(reg_vals)
                    arg2 = max(reg_vals)
                    value = regfile + "[" + destination_reg + "]"

                else:
                    continue

                expression = apply_operator(arg1, arg2, cosa_op)
                text += property_result(expression, value)
    
            text += "\n"

        f = open("../SICFiles/single_property_"+ins+".txt", 'w')
        f.write(text)
        f.close()

    






