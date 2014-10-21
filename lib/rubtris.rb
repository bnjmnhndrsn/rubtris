require_relative 'board'
require 'timeout'
require 'io/console'

class Rubtris
  
  REFRESH_RATE            = 0.05
  BEGINNING_ADVANCE_RATE  = 0.3
  MINIMUM_ADVANCE_RATE    = 0.05
  DIF_BTWN_LEVEL          = 0.04

  def initialize
    @board = Board.new
  end

  def run
    set_up_game
    
    until @board.over?
      do_turn
    end
    
    end_game
  end
  
  def set_up_game
    STDIN.echo = false
    @board.add_block
    render(@board.to_s)
    @last_advanced, @level = Time.now, 0
  end
  
  def do_turn
    auto_advance if auto_advance_needed?
    system "clear" or system "cls"
    render(@board.to_s)
    action = get_input
    take_action(action) if action
    update_level
  end
  
  def end_game
    render(@board.to_s)
    puts "GAME OVER. Lines: #{@board.completed_lines} Level: #{@level}"
    STDIN.echo = true
  end
  
  def current_advance_rate
    [BEGINNING_ADVANCE_RATE - (@level * DIF_BTWN_LEVEL), MINIMUM_ADVANCE_RATE].max
  end
  
  def auto_advance_needed?
    Time.now - @last_advanced > current_advance_rate
  end
  
  def auto_advance
    @last_advanced = Time.now
    @board.move_selected_down
  end
  
  def get_input
    action = nil
    begin
      action = Timeout::timeout(REFRESH_RATE) { STDIN.getch }
    rescue
    end
    action
  end
  
  def force_quit
    STDIN.echo = true
    fail "quitting gracefully"
  end

  def take_action(action)
    case action.downcase
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
    when "e"
      @board.rotate_selected_right
    when "q"
      @board.rotate_selected_left
    when "p"
      force_quit
    end
    nil
  end
  
  def update_level
    @level = @board.completed_lines / 10
  end
  
  def render(grid_string)
    puts grid_string
  end

  
end

t = Rubtris.new
t.run
