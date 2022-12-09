def perform_move(move, x, y)
  case move
  when 'U'
    y -= 1 if y > 0
  when 'D'
    y += 1 if y < 2
  when 'R'
    x += 1 if x < 2
  when 'L'
    x -= 1 if x > 0
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
  (1 + x + (3 * y)).to_s
end

x = y = 1
code = ''

File.foreach('input.txt') do |line|
  x, y = perform_moves(line, x, y)
  code += button_at_position(x, y)
end

p code
