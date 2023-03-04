data = File.readlines('input.txt', chomp: true).join
pointer = 0
decompressed_length = 0
while pointer < data.length
  if data[pointer] != '('
    decompressed_length += 1
    pointer += 1
  else
    right_paren_index = data.index(')', pointer)
    marker = data[pointer + 1..right_paren_index - 1]
    split_marker = marker.split('x')
    marker_length = split_marker[0].to_i
    marker_repeat = split_marker[1].to_i
    decompressed_length += marker_length * marker_repeat
    pointer = right_paren_index + marker_length + 1
  end
end
p decompressed_length
