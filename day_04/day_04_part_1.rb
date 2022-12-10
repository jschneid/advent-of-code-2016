def expected_checksum(encrypted_name)
  occurrence_counts = Hash.new(0)
  encrypted_name.chars.each do |char|
    occurrence_counts[char] += 1
  end

  sorted_occurrence_counts = occurrence_counts.sort_by { |key, value| [-1 * value, key] }
  
  sorted_occurrence_counts.take(5).map(&:first).join
end

real_room_sector_ids_sum = 0

File.foreach('input.txt', chomp:true) do |line|
  checksum = line[-6..-2]
  sector_id = line[-10..-8].to_i
  encrypted_name = line[0..-11].delete('-')

  real_room_sector_ids_sum += sector_id if expected_checksum(encrypted_name) == checksum
end

p real_room_sector_ids_sum
