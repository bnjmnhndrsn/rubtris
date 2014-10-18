require 'timeout'
require 'io/console'
require "debugger"

class Block
  
  attr_accessor :upper_left, :rotation, :pattern
  
  PATTERN_SIZES = {
    square: 2,
    lines: 4,
    left_l: 3,
    right_l: 3,
    t_block: 3
  }
  
  PATTERN_NAMES = [:square, :line, :left_l, :right_l, :t_block]
  
  PATTERNS = {
    square: [[0, 0], [0, 1], [1, 0], [1, 1]],
    line: [[0, 1], [1, 1], [2, 1], [3, 1]],
    left_l: [[0, 0], [1, 0], [2, 0], [2, 1]],
    right_l: [[0, 2], [1, 2], [2, 2], [2, 1]],
    t_block: [[1, 1], [2, 0], [2, 1], [2, 2]]
  }
  
  def initialize(pattern, upper_left)
    @pattern, @upper_left, @rotation = pattern, upper_left, 0
  end
  
  def self.random(upper_left)
    Block.new(PATTERN_NAMES.sample, upper_left)
  end
  
  def spaces_occupied(pos: @upper_left, rotation: @rotation)
    get_vectors(rotation).map do |vector|
      [vector.first + pos.first, vector.last + pos.last]
    end
  end
  
  def get_vectors(rotation)
    vectors = PATTERNS[@pattern].dup
    
    (rotation.abs % 4 ).times do
      vectors.map! do |coord|
        rotation > 0 ? rotate_coord_right(coord) : rotate_coord_left(coord)
      end
    end
    
    vectors
  end
    
  def rotate_coord_right(coord)
    i, j = coord
    size = PATTERN_SIZES[@pattern]
    [j , (size - 1) - i]
  end
  
  def rotate_coord_left(coord)
    i, j = coord
    size = PATTERN_SIZES[@pattern]
    [(size - 1) - j, i]
  end  
end