

def module_def(module, name, args, num_spaces=2):
    module_definition = " "*num_spaces
    module_definition = module_definition + module + " " + name + " ("

    spaces_so_far = len(module_definition)

    args_length = len(args)

    i = 0
    for arg in args:
        i += 1
        module_definition = module_definition + "." + arg + "(" + args[arg] + ")"
        if i < args_length:
            module_definition = module_definition + ",\n" + " "*spaces_so_far

    module_definition = module_definition + ");"

    return module_definition

def signal_def(bits, signal_type, signal_name, num_spaces=2):
    if bits == 1:
        return " "*num_spaces + signal_type + signal_name + ";"
    else:
        return " "*num_spaces + signal_type + " [" + str(bits-1) + ":0] " + signal_name + ";"

def module_header(name, inputs, outputs, num_spaces=2):
    header = "module " + name + " (\n"

    if len(outputs) > 0:
        header = header + " "*num_spaces + "// Outputs\n"

    i = 0
    for out in outputs:
        i += 1
        header = header + " "*num_spaces + out
        if len(inputs) > 0 or i < len(outputs):
            header = header + ",\n"

    if len(inputs) > 0:
        header = header + " "*num_spaces + "// Inputs\n"

    i = 0
    for inp in inputs:
        i += 1
        header = " "*num_spaces + header + inp
        if i < len(inputs):
            header = header + ",\n"

    header = header + ");"

    return header

def module_footer():
    return "endmodule"

def assign_def(name, expression, num_spaces=2):
    return " "*num_spaces + "assign " + name + " = " + expression + ";"

def operator(op, left, right, parens):
    if parens:
        return "(" + left + " " + op + " " + right + ")"
    else:
        return left + " " + op + " " + right

def _equals(left, right, parens=False):
    return operator("==", left, right, parens)

def _and(left, right, parens=False):
    return operator("&&", left, right, parens)

def _or(left, right, parens=False):
    return operator("||", left, right, parens)

def _lt(left, right, parens=False):
    return operator("<", left, right, parens)

def _le(left, right, parens=False):
    return operator("<=", left, right, parens)

def _gt(left, right, parens=False):
    return operator(">", left, right, parens)

def _ge(left, right, parens=False):
    return operator(">=", left, right, parens)

def _constant(bits, value):
    return str(bits) + "'" + value

def bit_vector(signals):
    vector = "{"
    i = 0
    for signal in signals:
        i += 1
        vector = vector + signal
        if i < len(signals):
            vector = vector + ", "

    vector = vector + "}"

    return vector

def always_def(signal, num_spaces=2):
    return " "*num_spaces + "always @(posedge " + signal + ")"

def begin():
    return "begin"

def end():
    return "end"

def inline_conditional(check, true, false):
    return check + " ? " + true + " : " + false

def conditional_header(conditional, expression, num_spaces=2):
    return return " "*num_spaces + conditional + " (" + expression + ") begin"

def if_header(expression, num_spaces=2):
    return conditional_header("if", expression, num_spaces=2)

def else_if_header(expression, num_spaces=2):
    return conditional_header("else if", expression, num_spaces=2)

def else_header(expression, num_spaces=2):
    return conditional_header("else", expression, num_spaces=2)



