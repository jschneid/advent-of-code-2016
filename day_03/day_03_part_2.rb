valid_triangles = 0

group_0_sides = []
group_1_sides = []
group_2_sides = []

File.foreach('input.txt') do |line|
  sides = line.split.map(&:to_i)

  group_0_sides << sides[0]
  group_1_sides << sides[1]
  group_2_sides << sides[2]

  if group_0_sides.length == 3
    group_0_sides.sort!
    group_1_sides.sort!
    group_2_sides.sort!

    valid_triangles += 1 if group_0_sides[0] + group_0_sides[1] > group_0_sides[2]
    valid_triangles += 1 if group_1_sides[0] + group_1_sides[1] > group_1_sides[2]
    valid_triangles += 1 if group_2_sides[0] + group_2_sides[1] > group_2_sides[2]

    group_0_sides.clear
    group_1_sides.clear
    group_2_sides.clear
  end
end

p valid_triangles
