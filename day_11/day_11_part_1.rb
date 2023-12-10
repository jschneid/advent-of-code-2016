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

  def can_be_moved_here?(cargo)
    combined_generators = cargo.generators + generators
    combined_microchips = cargo.microchips + microchips

    return true if combined_generators.empty?
    return true if combined_microchips.empty?
    return false if (combined_microchips - combined_generators).count > 0

    true
  end

  def possible_cargos
    cargos = []
    generators.each do |generator|
      cargos << Cargo.new([generator], [])
      generators.each do |generator2|
        cargos << Cargo.new([generator, generator2], []) if generator < generator2
      end
      cargos << Cargo.new([generator], [generator]) if microchips.include?(generator)
    end
    microchips.each do |microchip|
      cargos << Cargo.new([], [microchip])
      microchips.each do |microchip2|
        cargos << Cargo.new([], [microchip, microchip2]) if microchip < microchip2
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

      # To shorten runtime, let's assume there's never a reason to move down with 2 objects
      next if destination_floor_index < state.elevator_floor && ((cargo.microchips.count + cargo.generators.count) > 1)

      # To shorten runtime, let's assume that we should not move anything to the highest empty floor
      next if destination_floor_index == 0 && state.floors[0].generators.count == 0 && state.floors[0].microchips.count == 0
      next if destination_floor_index == 1 && state.floors[0].generators.count == 0 && state.floors[0].microchips.count == 0 && state.floors[1].generators.count == 0 && state.floors[1].microchips.count == 0

      # To shorten runtime, let's assume a generator should not be moved to a floor lower than its matching microchip
      if destination_floor_index < state.elevator_floor && cargo.generators.count > 0
        generator = cargo.generators[0]
        microchip_location = 0
        state.floors.each do |floor|
          break if floor.microchips.include?(generator)
          microchip_location += 1
        end
        next if microchip_location < state.elevator_floor
      end

      floors_clone = clone_floors(state.floors)
      next_state = State.new(floors_clone, destination_floor_index)

      source_floor = next_state.floors[state.elevator_floor]
      destination_floor = next_state.floors[destination_floor_index]

      source_floor.generators -= cargo.generators
      source_floor.microchips -= cargo.microchips
      destination_floor.generators += cargo.generators
      destination_floor.microchips += cargo.microchips

      next if states_seen.keys.include?(next_state)

      possible_moves << next_state
    end
  end
  possible_moves
end

def minimum_moves_to_solution(state, states_seen, solution_state)
  loop do
    possible_moves = possible_next_moves(state, states_seen)

    possible_moves.each do |possible_move|
      return states_seen[state] + 1 if possible_move == solution_state

      states_seen[possible_move] = states_seen[state] + 1
    end

    state.visited = true

    possible_next_states = states_seen.select { |s, v| s.visited == false }

    state = possible_next_states.min_by { |key, value| value }[0]
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

initial_state = State.new(floors, 0)

solution_floors = [Floor.new([], []), Floor.new([], []), Floor.new([], []), solution_top_floor]
solution_state = State.new(solution_floors, 3)

states_seen = { initial_state => 0 }

p minimum_moves_to_solution(initial_state, states_seen, solution_state)
