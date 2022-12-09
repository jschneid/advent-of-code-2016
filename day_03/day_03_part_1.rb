valid_triangles = 0

File.foreach('input.txt') do |line|
  sides = line.split.map(&:to_i).sort
  valid_triangles += 1 if sides[0] + sides[1] > sides[2]
end

p valid_triangles
