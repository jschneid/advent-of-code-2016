def perform_move(move, x, y)
  case move
  when 'U'
    y -= 1 if (y == 1 && x == 2) || (y == 2 && x > 0 && x < 4) || y >= 3
  when 'D'
    y += 1 if (y == 3 && x == 2) || (y == 2 && x > 0 && x < 4) || y <= 1
  when 'R'
    x += 1 if (x == 3 && y == 2) || (x == 2 && y > 0 && y < 4) || x <= 1
  when 'L'
    x -= 1 if (x == 1 && y == 2) || (x == 2 && y > 0 && y < 4) || x >= 3
  end
  [x, y]
end

def perform_moves(line, x, y)
  line.chars.each do |move|
    x, y = perform_move(move, x, y)
  end
  [x, y]
end

def button_at_position(x, y)
  return '1' if y == 0
  return '2' if y == 1 && x == 1
  return '3' if y == 1 && x == 2
  return '4' if y == 1 && x == 3
  return '5' if y == 2 && x == 0
  return '6' if y == 2 && x == 1
  return '7' if y == 2 && x == 2
  return '8' if y == 2 && x == 3
  return '9' if y == 2 && x == 4
  return 'A' if y == 3 && x == 1
  return 'B' if y == 3 && x == 2
  return 'C' if y == 3 && x == 3
  'D'
end

x = 0
y = 2
code = ''

File.foreach('input.txt') do |line|
  x, y = perform_moves(line, x, y)
  code += button_at_position(x, y)
end

p code
