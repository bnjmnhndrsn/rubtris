require_relative 'board'
require 'timeout'
require 'io/console'

class Rubtris
  
  REFRESH_RATE  = 0.03
  BEGINNING_ADVANCE_RATE  = 0.3
  MINIMUM_ADVANCE_RATE = 0.05
  DIF_BTWN_LEVEL = 0.04

  def initialize
    @board = Board.new
  end

  def run
    @board.add_block
    render(@board.to_s)
    @last_advanced, @level = Time.now, 0
    
    until @board.over?
      current_advance_rate = [BEGINNING_ADVANCE_RATE - (@level * DIF_BTWN_LEVEL), MINIMUM_ADVANCE_RATE].max
      if Time.now - @last_advanced > current_advance_rate
        @last_advanced = Time.now
        @board.move_selected_down
      end
      system('clear')
      action = nil
      render(@board.to_s)
      begin
        action = Timeout::timeout(REFRESH_RATE) { STDIN.getch }
      rescue
      end
      take_action(action) if action
      @level = @board.completed_lines / 10
    end
    render(@board.to_s)
    puts "GAME OVER. Lines: #{@board.completed_lines} Level: #{@level}"
  end

  def take_action(action)
    case action
    when "w"
      @board.push_selected_down
    when "a"
      @board.move_selected_left
    when "s"
      @board.move_selected_down
    when "d"
      @board.move_selected_right
    when "\r"
      @board.push_selected_down
    when "p"
      @board.rotate_selected_right
    when "l"
      @board.rotate_selected_left
    when "\e"
      fail "quitting gracefully"
    when "\u0003"
      fail "quitting gracefully"
    end
    nil
  end
  
  def render(grid_string)
    puts grid_string
  end

  
end

t = Rubtris.new
t.run
