class Repeater
  attr_reader :end_position, :multiplier

  def initialize(end_position, multiplier)
    @end_position = end_position
    @multiplier = multiplier
  end
end

def active_multiplier(repeaters, position)
  multiplier = 1
  repeaters.each do |repeater|
    multiplier *= repeater.multiplier if position <= repeater.end_position
  end
  multiplier
end

repeaters = []

data = File.readlines('input.txt', chomp: true).join
pointer = 0
decompressed_length = 0
while pointer < data.length
  multiplier = active_multiplier(repeaters, pointer)
  if data[pointer] != '('
    decompressed_length += multiplier
    pointer += 1
  else
    right_paren_index = data.index(')', pointer)
    marker = data[pointer + 1..right_paren_index - 1]
    split_marker = marker.split('x')
    marker_length = split_marker[0].to_i
    marker_repeat = split_marker[1].to_i

    repeaters << Repeater.new(right_paren_index + marker_length, marker_repeat)
    pointer = right_paren_index + 1
  end
end

p decompressed_length
