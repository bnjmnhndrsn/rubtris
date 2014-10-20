require 'io/console'

class RubtrisUI
  
  attr_accessor :grid, :selected, :cursor, :flash, :title
  
  def initialize(size = 8)
    @size = size
    @cursor = nil
    @grid = nil
    @flash = nil
    @selected = []
    @title = nil
  end
  
  def load(grid)
    @grid = grid
  end
  
  def display(spaces: 1, message: nil, labels: true)
    raise "No grid to display!" if @grid.nil?
    
    first_row = ("a".."z").to_a[0...@size].join(" " * spaces)
    col_numbers = (1..@size).to_a.reverse
    
    rows = @grid.map.with_index do |row, i|
       "#{col_numbers[i] if labels} " + row.map.with_index do |space, j|
        if [i, j] == @cursor
          "0"
        elsif @selected.include?([i, j])
          "X"
       else
          space
        end
      end.join(" " * spaces)
    end.join("\n")
    
    puts title if title
    puts " #{first_row if labels}\n#{rows}"
    puts message if message
  end
  
  def get_selection(message)
    @cursor ||= [0, 0]
    action = nil
    while action.nil?
      begin
        system("clear")
        display(message: (@flash.nil? ? message : @flash))
        input = STDIN.getch
        action = process_input(input)
        @flash = nil
      rescue InputError => e
        @flash = e.message
        retry
      end
    end
    action
  end
  
  def ask_question(message)
    begin
      system("clear")
      display(message: message)
      input = STDIN.getch.downcase
      raise InputError unless input =~ /[yn]/
    rescue InputError => e
      @flash = e.message
      retry
    end
    
    input == "y"
    
  end
  
  def process_input(input)
    i, j = @cursor

    case input
    when "w"
      @cursor = [(i - 1) % @size, j]
    when "a"
      @cursor = [i, (j - 1) % @size]
    when "s"
      @cursor = [(i + 1) % @size, j]
    when "d"
      @cursor = [i, (j + 1)  % @size]
    when "\r"
      return @cursor
    when "\e"
      return false
    when "\u0003"
      fail "quitting gracefully"
    else
      raise InputError.new("Please use WASD to move, enter to select.")
    end
    nil
  end
end

class InputError < RuntimeError
end
