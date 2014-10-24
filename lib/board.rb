require_relative 'block'
require_relative 'pattern'
require 'colorize'

class Board
  
  attr_reader :completed_lines
  
  WIDTH = 10
  
  HEIGHT = 22
  
  STARTING_POINT = [0, 4]
  
  SCORE_MULTIPLIER = 2
  
  def initialize
    @grid, @over, @completed_lines = Array.new(HEIGHT) { Array.new(WIDTH) }, false, 0
    @start_time, @time_limit, @line_limit = Time.now, nil, nil
    @score, @level =  0, 0
  end
  
  def [](coord)
    @grid[coord.first][coord.last]
  end
  
  def []=(coord, val)
    @grid[coord.first][coord.last] = val
  end
  
  def render
    str = ""
    @grid.each_with_index do |row, i|
      row.each do |pos|
         str += pos.nil? ? "  " : "[]".colorize(pos.pattern.color)
      end
      str+= "*"
      if i == 2
        str += "    #{summary_s}"
      end
      str += "\n"
    end
    str = "  " * (WIDTH + 1) + "\n" + str + "* " * (WIDTH + 1) + "\n"
    puts str
  end
  
  def summary_s
    "LINES: #{@completed_lines}  LEVEL: #{level}  SCORE: #{@score}"
  end
  
  def level
    @completed_lines / 10
  end
  
  def filled?(space)
    !self[space].nil?
  end
  
  def any_filled?(spaces)
    spaces.any?{ |space| filled?(space) }
  end
  
  def all_filled?(spaces)
    spaces.all?{ |space| filled?(space) }
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
    return false if any_filled?(spaces)
    add_to_spaces(block, spaces)
    @selected.upper_left = nil unless @selected.nil?
    @selected = block
    true
  end
  
  def change_direction(block, options = {})
    i, j, turn = options[:i], options[:j], options[:turn]
    
    new_upper_left = (i && j) ? [block.upper_left.first + i, block.upper_left.last + j] : block.upper_left
    new_rotation = (turn) ? block.rotation + turn : block.rotation
    old_spaces = block.spaces_occupied
    new_spaces = block.spaces_occupied(pos: new_upper_left, rotation: new_rotation)
    old_territory = old_spaces - new_spaces
    new_territory = new_spaces - old_spaces
    return false unless new_spaces.all? { |coord| on_board?(coord) }
    return false if any_filled?(new_territory)
    remove_from_spaces(old_territory)
    add_to_spaces(block, new_territory)
    block.upper_left, block.rotation = new_upper_left, new_rotation
    true 
  end
  
  def on_board?(space)
    space.first.between?(0, HEIGHT - 1) && space.last.between?(0, WIDTH - 1)
  end
  
  def push_selected_down
    unless change_direction(@selected, i: 5, j: 0)
      move_selected_down
    end
  end
  
  def move_selected_down
    unless change_direction(@selected, i: 1, j: 0)
      remove_completed_line_and_increase_score
      @over = !add_block
    end
  end
  
  def move_selected_left
    change_direction(@selected, i: 0, j: -1)
  end
  
  def move_selected_right
    change_direction(@selected, i: 0, j: 1)
  end
  
  def rotate_selected_left
    change_direction(@selected, turn: -1)
  end
  
  def rotate_selected_right
    change_direction(@selected, turn: 1)
  end
  
  def remove_and_shift(row_num)
    @grid[row_num] = Array.new(WIDTH)
    until @grid[row_num - 1].all?(&:nil?)
      @grid[row_num] = @grid[row_num -= 1]
      @grid[row_num] = Array.new(WIDTH)
    end
  end
  
  def remove_completed_line_and_increase_score
    lines = 0
    i = HEIGHT - 1
    until i == 0
      spaces_on_row = [i].product((0...WIDTH).to_a)
        if all_filled?(spaces_on_row)
          remove_and_shift(i)
          lines += 1
        else
          i -= 1
        end
    end
    @completed_lines += lines
    @score += (lines * SCORE_MULTIPLIER) ** 2
  end
  
  def over?
    @over
  end
  


end