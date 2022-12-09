def update_facing(facing, turn)
  (facing + (turn == 'R' ? 1 : -1)) % 4
end

def distance_to_first_location_visited_twice
  x = y = 0
  facing = 0 # 0 == North, 1 == East, 2 == South, 3 == West
  locations_visited = [{x: 0, y: 0}]

  File.read('input.txt').split(', ').each do |move|
    facing = update_facing(facing, move.chr)

    distance = move[1..].to_i

    # We need to move just one block (unit) at a time because the first
    # location visited twice could be DURING a given move.
    distance.times do
      y += 1 if facing == 0
      x += 1 if facing == 1
      y -= 1 if facing == 2
      x -= 1 if facing == 3

      current_location = { x: x, y: y }
      return x.abs + y.abs if locations_visited.include?(current_location)
      locations_visited << current_location
    end
  end
end

p distance_to_first_location_visited_twice
