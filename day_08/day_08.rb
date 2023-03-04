def init_grid
  grid = []
  (0..5).each do |y|
    grid[y] = Array.new(50, 0)
  end
  grid
end

def read_instructions
  File.readlines('input.txt', chomp: true)
end

def light_rectangle(rectangle, grid)
  dimensions = rectangle.split('x').map(&:to_i)

  (0..dimensions[1] - 1).each do |y|
    (0..dimensions[0] - 1).each do |x|
      grid[y][x] = 1
    end
  end
end

def rotate_column(x, shift, grid)
  column_pixels = []
  (0..5).each do |y|
    column_pixels << grid[y][x]
  end

  column_pixels = column_pixels.rotate(-1 * shift)

  (0..5).each do |y|
    grid[y][x] = column_pixels[y]
  end
end

def rotate_row(y, shift, grid)
  grid[y] = grid[y].rotate(-1 * shift)
end

def execute_instructions(instructions, grid)
  instructions.each do |instruction|
    split_instruction = instruction.split
    if split_instruction[0] == 'rect'
      light_rectangle(split_instruction[1], grid)
    elsif split_instruction[1] == 'column'
      rotate_column(split_instruction[2][2..].to_i, split_instruction[4].to_i, grid)
    else
      rotate_row(split_instruction[2][2..].to_i, split_instruction[4].to_i, grid)
    end
  end
end

def lit_pixels_count(grid)
  grid.flatten.reduce(&:+)
end

def print_grid(grid)
  (0..5).each do |y|
    p grid[y].map { |pixel| pixel.zero? ? ' ' : '#' }.join
  end
end

grid = init_grid
instructions = read_instructions
execute_instructions(instructions, grid)
print_grid(grid)
p lit_pixels_count(grid)
