class Pattern
  attr_accessor :name, :size, :color, :pattern
  def initialize(name, pattern, size, color)
    @name, @pattern, @size, @color = name, pattern, size, color
  end
  
  def pattern
    @pattern.map(&:dup)
  end
end