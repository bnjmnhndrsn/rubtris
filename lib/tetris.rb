require_relative '../../shared/lib/board_ui'
require_relative 'board'
require 'timeout'
require 'io/console'

class Tetris
  
  REFRESH_RATE  = 0.03
  ADVANCE_RATE  = 0.5

  def initialize
    @board = Board.new
    @ui = BoardUI.new
  end

  def run
    @board.add_block
    @ui.load(@board.serialize)
    @ui.display(spaces: 0, labels: false)
    @last_advanced = Time.now
    while true
      if Time.now - @last_advanced > ADVANCE_RATE
        @last_advanced = Time.now
        @board.push_selected_down
      end
      system('clear')
      action = nil
      @ui.display(spaces: 0, labels: false)
      begin
        action = Timeout::timeout(REFRESH_RATE) { STDIN.getch }
      rescue
      end
      @ui.load(@board.serialize)
      take_action(action) if action
    end
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

  
end

t = Tetris.new
t.run
