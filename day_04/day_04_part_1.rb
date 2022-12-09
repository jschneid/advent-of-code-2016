def expected_checksum(encrypted_name)
  occurrence_counts = Hash.new(0)
  encrypted_name.chars.each do |char|
    occurrence_counts[char] += 1
  end

  sorted_occurrence_counts = occurrence_counts.to_a.sort { |a, b| [-1 * a[1], a[0]] <=> [-1 * b[1], b[0]] }

  sorted_occurrence_counts.take(5).map { |a| a[0] }.join
end

real_room_sector_ids_sum = 0

File.foreach('input.txt', chomp:true) do |line|
  checksum = line[-6..-2]
  sector_id = line[-10..-8].to_i
  encrypted_name = line[0..-11].delete('-')

  real_room_sector_ids_sum += sector_id if expected_checksum(encrypted_name) == checksum
end

p real_room_sector_ids_sum
