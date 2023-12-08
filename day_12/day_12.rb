def read_lines
  File.readlines('day_12/input.txt')
end

def process_instructions(instructions, registers)
  instruction_pointer = 0
  loop do
    instruction = instructions[instruction_pointer]
    split_instruction = instruction.split(' ')
    case split_instruction[0]
    when 'cpy'
      perform_cpy(split_instruction[1], split_instruction[2], registers)
      instruction_pointer += 1
    when 'inc'
      perform_inc(split_instruction[1], registers)
      instruction_pointer += 1
    when 'dec'
      perform_dec(split_instruction[1], registers)
      instruction_pointer += 1
    when 'jnz'
      instruction_pointer = perform_jnz(split_instruction[1], split_instruction[2], registers, instruction_pointer)
    end

    return if instruction_pointer >= instructions.length
  end
end

def perform_cpy(value, register, registers)
  registers[register] = value_to_integer(value, registers)
end

def perform_inc(register, registers)
  registers[register] += 1
end

def perform_dec(register, registers)
  registers[register] -= 1
end

def perform_jnz(value, offset, registers, instruction_pointer)
  value = value_to_integer(value, registers)

  return instruction_pointer + 1 if value.zero?

  instruction_pointer + value_to_integer(offset, registers)
end

def value_to_integer(value, registers)
  if Integer(value, exception: false)
    value.to_i
  else
    registers[value]
  end
end

registers = { 'a' => 0, 'b' => 0, 'c' => 1, 'd' => 0 }
instructions = read_lines
process_instructions(instructions, registers)
pp registers['a']
