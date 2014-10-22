require_relative 'board'
require 'timeout'
require 'io/console'
require_relative 'menu'

class Rubtris
  
  REFRESH_RATE            = 0.05
  BEGINNING_ADVANCE_RATE  = 0.3
  MINIMUM_ADVANCE_RATE    = 0.05
  DIF_BTWN_LEVEL          = 0.04


  def run
    set_up_game
    until over?
      do_turn
    end
    end_game
    run if !force_quit? && play_again
  end
  
  def get_mode
    options = [
      {title: "Unlimited", type: :none, value: true},
      {title: "Timed", type: :increment, value: 3, unit: 'min.'},
      {title: "Lines", type: :increment, value: 40}
    ]
    prompt = "Welcome to Tetris.\nSelect the mode you want to play!"
    menu = Menu.new(options, prompt)
    menu.open
  end
  
  def play_again
    options = [
      {title: "Yes", type: :none, value: true},
      {title: "No", type: :none, value: false}
    ]
    prompt = "#{@board.summary_s}\nPlay again?"
    menu = Menu.new(options, prompt)
    menu.open[:value]
  end
  
  def set_up_game
    config = get_mode
    add_win_condition(config[:title], config[:value])
    @board = Board.new
    STDIN.echo = false
    @force_quit = false
    @board.add_block
    @board.render
    @start_time, @last_advanced, @level = Time.now, Time.now, 0
    @time_limit = 0
    
  end
  
  def do_turn
    auto_advance if auto_advance_needed?
    system "clear" or system "cls"
    @board.render
    action = get_input
    take_action(action) if action
  end
  
  def end_game
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
  
  def force_quit?
    @force_quit
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
    when "["
      @board.rotate_selected_left
    when "]"
      @board.rotate_selected_right
    when "p"
      @force_quit = true
    when "\e"
      @force_quit = true
    end
    nil
  end
  
  def over?
    force_quit? || @board.over? || over_time? || over_lines?
  end
  
  def over_time?
    p "#{@start_time} && (#{@last_advanced} - #{@start_time}) >= #{@time_limit}"
    @start_time && (@last_advanced - @start_time) >= @time_limit
  end
  
  def over_lines?
    @line_limit && @board.completed_lines >= @line_limit
  end
  
  def add_win_condition(condition, value)
    case condition
    when "Timed"
      @time_limit = value * 60
    when "Lines"
      @line_limit = value
    end
  end

end

t = Rubtris.new
t.run