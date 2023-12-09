class Cargo
  attr_accessor :generators, :microchips
  def initialize(generators, microchips)
    @generators = generators
    @microchips = microchips
  end
end

class Floor
  attr_accessor :generators, :microchips
  def initialize(generators, microchips)
    @generators = generators
    @microchips = microchips
  end

  def ==(other)
    generators.sort == other.generators.sort && microchips.sort == other.microchips.sort
  end

  def vulnerable_microchips
    microchips - generators
  end

  def can_be_moved_here?(cargo)
    (vulnerable_microchips - cargo.generators).empty?
  end

  def possible_cargos
    cargos = []
    generators.each do |generator|
      cargos << Cargo.new([generator], [])
      generators.each do |generator2|
        cargos << Cargo.new([generator, generator2], []) if generator != generator2
      end
      microchips.each do |microchip|
        cargos << Cargo.new([generator], [microchip]) if generator == microchip
      end
    end
    microchips.each do |microchip|
      cargos << Cargo.new([], [microchip])
      microchips.each do |microchip2|
        cargos << Cargo.new([], [microchip, microchip2]) if microchip != microchip2
      end
    end
    cargos
  end
end

class State
  attr_accessor :floors, :elevator_floor, :visited
  def initialize(floors, elevator_floor)
    @floors = floors
    @elevator_floor = elevator_floor
    @visited = false
  end

  def ==(other)
    floors[0] == other.floors[0] &&
      floors[1] == other.floors[1] &&
      floors[2] == other.floors[2] &&
      floors[3] == other.floors[3] &&
      elevator_floor == other.elevator_floor
  end

  def eql?(other)
    self == other
  end

  def hash
    floors[0].hash ^ floors[1].hash ^ floors[2].hash ^ floors[3].hash ^ elevator_floor.hash
  end

  def to_str
    str = "Elevator on floor #{elevator_floor}\n"
    floors.each_with_index do |floor, index|
      str += "Floor #{index}: Generators: #{floor.generators} Microchips: #{floor.microchips}\n"
    end
    str
  end
end

def read_input
  File.readlines('day_11/input.txt')
end

def generators(line)
  line.scan(/(\w+) generator/).flatten
end

def microchips(line)
  line.scan(/(\w+)-compatible microchip/).flatten
end

def possible_destination_floors(elevator_floor)
  possible_floors = []
  possible_floors << elevator_floor + 1 if elevator_floor < 3
  possible_floors << elevator_floor - 1 if elevator_floor > 0
  possible_floors
end

def clone_floors(floors)
  clone = []
  floors.each do |floor|
    clone << Floor.new(floor.generators.dup, floor.microchips.dup)
  end
  clone
end

def possible_next_moves(state, states_seen)
  possible_moves = []
  possible_destination_floors = possible_destination_floors(state.elevator_floor)

  state.floors[state.elevator_floor].possible_cargos.each do |cargo|
    possible_destination_floors.each do |destination_floor_index|
      next unless state.floors[destination_floor_index].can_be_moved_here?(cargo)

      floors_clone = clone_floors(state.floors)
      next_state = State.new(floors_clone, destination_floor_index)

      source_floor = floors_clone[state.elevator_floor]
      destination_floor = floors_clone[destination_floor_index]

      source_floor.generators -= cargo.generators
      source_floor.microchips -= cargo.microchips
      destination_floor.generators += cargo.generators
      destination_floor.microchips += cargo.microchips

      next if states_seen.keys.any? { |s| s == next_state }

      # p "We could move #{cargo.generators} generators and #{cargo.microchips} microchips from floor #{state.elevator_floor} to floor #{destination_floor}"
      possible_moves << next_state
    end
  end
  possible_moves
end

def minimum_moves_to_solution(state, states_seen, solution_state)
  loop do
    # p "Checking state with hash #{state.hash}"

    possible_moves = possible_next_moves(state, states_seen)

    #    p "Possible moves: #{possible_moves.length}"

    possible_moves.each do |possible_move|
      # p "#{possible_move.to_str}"

      return states_seen[state] + 1 if possible_move == solution_state

      states_seen[possible_move] = states_seen[state] + 1
    end

    state.visited = true

    possible_next_states = states_seen.keys.select { |s| s.visited == false }
    state = possible_next_states.sort_by { |key, value| value }.last

    # p "States seen: #{states_seen.length}"
    # p "Next state: #{state.to_str}"
    # p "Steps to get there: #{states_seen[state]}"
  end
end

lines = read_input

solution_top_floor = Floor.new([], [])
floors = []
lines[0..2].each do |line|
  generators = generators(line)
  microchips = microchips(line)
  floors << Floor.new(generators, microchips)

  solution_top_floor.generators.push(*generators)
  solution_top_floor.microchips.push(*microchips)
end
floors << Floor.new([], [])

initial_state = State.new(floors, 2)

p "Initial: #{initial_state.to_str}"

solution_floors = [Floor.new([], []), Floor.new([], []), Floor.new([], []), solution_top_floor]
solution_state = State.new(solution_floors, 3)

p "Solution: #{solution_state.to_str}"

states_seen = { initial_state => 0 }

p minimum_moves_to_solution(initial_state, states_seen, solution_state)
