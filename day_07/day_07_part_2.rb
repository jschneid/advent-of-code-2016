def aba?(sequence)
  sequence[0] == sequence[2] && sequence[0] != sequence[1]
end

def supports_ssl(tokenized_line)
  abas = []
  (0..tokenized_line.length - 1).step(2) do |section|
    section_outside_brackets = tokenized_line[section]
    (0..section_outside_brackets.length - 3).each do |i|
      candidate_aba = section_outside_brackets[i..i + 2]
      abas << candidate_aba if aba?(candidate_aba)
    end
  end

  abas.each do |aba|
    bab = "#{aba[1]}#{aba[0]}#{aba[1]}"
    (1..tokenized_line.length - 1).step(2) do |section|
      section_in_brackets = tokenized_line[section]
      (0..section_in_brackets.length - 3).each do |i|
        return true if section_in_brackets[i..i + 2] == bab
      end
    end
  end

  false
end

lines_supporting_ssl = 0
File.foreach('input.txt', chomp: true) do |line|
  tokenized_line = line.split(/[\[\]]/)
  lines_supporting_ssl += 1 if supports_ssl(tokenized_line)
end

p lines_supporting_ssl
