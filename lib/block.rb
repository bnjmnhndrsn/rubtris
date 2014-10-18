require 'timeout'
require 'io/console'

class Block
  
  attr_accessor :upper_left, :selected
  
  PATTERNS = {
    square: [[0, 0], [0, 1], [1, 0], [1, 1]],
    line: [[0, 0], [1, 0], [2, 0], [3, 0]],
  }
  
  def initialize(pattern, upper_left)
    @pattern, @upper_left = pattern, upper_left
  end
  
  def spaces_occupied(pos = @upper_left)
      PATTERNS[@pattern].map do |vector|
        [vector.first + pos.first, vector.last + pos.last]
      end
  end
  
end