def add_chip_to_bot(bots, bot_id, chip_number)
  bots[bot_id] = [] unless bots.key?(bot_id)
  bots[bot_id] << chip_number.to_i
  bots[bot_id].sort!
end

def add_chip_to_output_bin(output_bins, bin_id, chip_number)
  output_bins[bin_id] = chip_number
end

def distribute_initially_held_chips(instructions, bots)
  instructions.each do |instruction|
    next unless instruction.start_with?('value')

    tokenized_instruction = instruction.split
    bot_id = tokenized_instruction.last
    add_chip_to_bot(bots, bot_id, tokenized_instruction[1].to_i)
  end
end

def handoff_instructions_by_bot_id(instructions)
  handoff_instructions = {}

  instructions.each do |instruction|
    next unless instruction.start_with?('bot')

    tokenized_instruction = instruction.split
    bot_id = tokenized_instruction[1]
    handoff_instructions[bot_id] = instruction
  end

  handoff_instructions
end

def execute_chip_handoff_instructions(handoff_instructions, bots, output_bins)
  loop do
    bot = bots.find { |_key, value| value.length == 2 }
    return if bot.nil?

    bot_id = bot[0]
    instruction = handoff_instructions[bot_id]

    tokenized_instruction = instruction.split
    recipient_of_low_value = tokenized_instruction[6]
    recipient_of_high_value = tokenized_instruction[11]
    low_value = bots[bot_id][0]
    high_value = bots[bot_id][1]

    if low_value == 17 && high_value == 61
      p "The bot responsible for comparing chip 17 and 61 is #{bot_id}"
    end

    add_chip_to_bot(bots, recipient_of_low_value, low_value) if tokenized_instruction[5] == 'bot'
    add_chip_to_bot(bots, recipient_of_high_value, high_value) if tokenized_instruction[10] == 'bot'
    bots[bot_id] = []

    add_chip_to_output_bin(output_bins, recipient_of_low_value, low_value) if tokenized_instruction[5] == 'output'
    add_chip_to_output_bin(output_bins, recipient_of_high_value, high_value) if tokenized_instruction[10] == 'output'
  end
end

instructions = File.readlines('input.txt', chomp: true)
bots = {}
distribute_initially_held_chips(instructions, bots)
handoff_instructions = handoff_instructions_by_bot_id(instructions)
output_bins = {}
execute_chip_handoff_instructions(handoff_instructions, bots, output_bins)
p output_bins['0'] * output_bins['1'] * output_bins['2']
