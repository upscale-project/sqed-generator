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

def take(outer_dict):
    l = outer_dict.keys()
    l.remove("CONSTRAINT")
    return l[0], outer_dict[l[0]]

def wrap(expression, bits, value, end=True):
    final = "(" + expression + " = " + value + "_" + bits + ")"
    if end:
        return final + ";"
    else:
        return final 

def generate_SIC_files(format_dicts):
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
                reset, reset_bits = take(SIC_info["RESET"]) 
                counter, counter_bits = take(SIC_info["COUNTER"]) 
                module, _ = take(SIC_info["MODULENAME"])
                regfile, _ = take(SIC_info["REGFILE"])
                memory, _ = take(SIC_info["MEMORY"])

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
                    text += " & "
                    text += constraint
                text += ");"

                text += "\n"
                text += "properties: "
                text += wrap(counter, counter_bits, str(1 + int(isa_info["pipeline_depth"])), end=False)
                text += " -> "

                            


            text += "\n"

        f = open("../SICFiles/single_property_"+ins+".txt", 'w')
        f.write(text)
        f.close()



