def update_facing(facing, turn)
  (facing + (turn == 'R' ? 1 : -1)) % 4
end

x = y = 0
facing = 0 # 0 == North, 1 == East, 2 == South, 3 == West

File.read('input.txt').split(', ').each do |move|
  facing = update_facing(facing, move.chr)

  distance = move[1..].to_i

  y += distance if facing == 0
  x += distance if facing == 1
  y -= distance if facing == 2
  x -= distance if facing == 3
end

p x.abs + y.abs
