require 'timeout'
require 'io/console'
require_relative 'pattern'

class Block
  
  attr_accessor :upper_left, :rotation, :pattern
  
  PATTERN = [ # Name, Pattern, Size, Color
    Pattern.new(:square,     [[0, 0], [0, 1], [1, 0], [1, 1]], 2, :red),
    Pattern.new(:line,       [[0, 1], [1, 1], [2, 1], [3, 1]], 4, :cyan),
    Pattern.new(:left_l,     [[0, 0], [1, 0], [2, 0], [2, 1]], 3, :blue),
    Pattern.new(:right_l,    [[0, 2], [1, 2], [2, 2], [2, 1]], 3, :green),
    Pattern.new(:t_block,    [[1, 1], [2, 0], [2, 1], [2, 2]], 3, :red),
    Pattern.new(:n_block_1,  [[0, 0], [1, 0], [1, 1], [2, 1]], 3, :yellow),
    Pattern.new(:n_block_2,  [[0, 1], [1, 1], [1, 0], [2, 0]], 3, :black)
  ]
  
  
  def initialize(pattern, upper_left)
    @pattern, @upper_left, @rotation = pattern, upper_left, 0
  end
  
  def self.random(upper_left)
    Block.new(PATTERN.sample, upper_left)
  end
  
  def spaces_occupied(options = {})
    rotation = options[:rotation] || @rotation
    pos = options[:pos] || @upper_left
    get_vectors(rotation).map do |vector|
      [vector.first + pos.first, vector.last + pos.last]
    end
  end
  
  def get_vectors(rotation)
    vectors = @pattern.pattern
    
    (rotation.abs % 4 ).times do
      vectors.map! do |coord|
        rotation > 0 ? rotate_coord_right(coord) : rotate_coord_left(coord)
      end
    end
    
    vectors
  end
    
  def rotate_coord_right(coord)
    i, j = coord
    size = @pattern.size
    [j , (size - 1) - i]
  end
  
  def rotate_coord_left(coord)
    i, j = coord
    size = @pattern.size
    [(size - 1) - j, i]
  end  
end