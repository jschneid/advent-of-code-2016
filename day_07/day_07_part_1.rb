def abba?(sequence)
  sequence[0] == sequence[3] && sequence[1] == sequence[2] && sequence[0] != sequence[1]
end

def supports_tls(tokenized_line)
  (1..tokenized_line.length - 1).step(2) do |section|
    section_in_brackets = tokenized_line[section]
    (0..section_in_brackets.length - 4).each do |i|
      return false if abba?(section_in_brackets[i..i + 3])
    end
  end

  (0..tokenized_line.length - 1).step(2) do |section|
    section_outside_brackets = tokenized_line[section]
    (0..section_outside_brackets.length - 4).each do |i|
      return true if abba?(section_outside_brackets[i..i + 3])
    end
  end

  false
end

lines_supporting_tls = 0
File.foreach('input.txt', chomp: true) do |line|
  tokenized_line = line.split(/[\[\]]/)
  lines_supporting_tls += 1 if supports_tls(tokenized_line)
end

p lines_supporting_tls
