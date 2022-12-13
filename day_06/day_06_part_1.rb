data = File.readlines('input.txt', chomp: true)

message = ''

data[0].length.times do |i|
  message += data.map { |line| line[i] }.tally.max_by(&:last).first
end

p message
