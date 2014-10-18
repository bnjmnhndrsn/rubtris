require_relative 'block'
require 'debugger'
class Board
  
  STRINGS = {
    Block => "x",
    NilClass => " " 
  }
  
  WIDTH = 10
  
  HEIGHT = 22
  
  STARTING_POINT = [0, 4]
  
  def initialize
    @grid = Array.new(HEIGHT) { Array.new(WIDTH) }
  end
  
  def [](coord)
    @grid[coord.first][coord.last]
  end
  
  def []=(coord, val)
    @grid[coord.first][coord.last] = val
  end
  
  def serialize
    @grid.map do |row|
       row.map do |square|
         STRINGS[square.class]
       end
     end
  end
  
  def filled?(spaces)
    spaces.each do |space|
      return true unless self[space].nil?
    end
    false
  end
  
  def add_to_spaces(block, spaces)
    spaces.each do |space| 
      self[space] = block
    end
  end
  
  def remove_from_spaces(spaces)
    spaces.each do |space|
      self[space] = nil
    end
  end
  
  def add_block
    block = Block.random(STARTING_POINT)
    spaces = block.spaces_occupied
    return false if filled?(spaces)
    add_to_spaces(block, spaces)
    @selected = block
    true
  end
  
  def shift_direction(block, i, j)
    old_spaces = block.spaces_occupied
    new_spaces = old_spaces.map { |space| [space.first + i, space.last + j] }
    old_territory = old_spaces - new_spaces
    new_territory = new_spaces - old_spaces
    return false unless new_spaces.all? { |coord| on_board?(coord) }
    return false if filled?(new_territory)
    remove_from_spaces(old_territory)
    add_to_spaces(block, new_territory)
    block.upper_left = [block.upper_left.first + i, block.upper_left.last + j]
    true 
  end
  
  def on_board?(space)
    space.first.between?(0, HEIGHT - 1) && space.last.between?(0, WIDTH - 1)
  end
  
  def push_selected_down
    add_block unless shift_direction(@selected, 1, 0)
  end
  
  def move_selected_down
    add_block unless shift_direction(@selected, 1, 0)
  end
  
  def move_selected_left
    shift_direction(@selected, 0, -1)
  end
  
  def move_selected_right
    shift_direction(@selected, 0, 1)
  end
  
  def rotate_selected_left
  end
  
  def rotate_selected_right
  end

end

class InvalidMoveError < RuntimeError
end