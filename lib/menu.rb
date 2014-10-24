class Menu

  
  def initialize(options, prompt)
    @prompt = prompt.center(33)
    @options = options
    @selected = 0
    @done = false
  end
  
  def open
    until done?
      system "clear" or system "cls"
      render
      input = STDIN.getch
      take_action(input)
    end
    return @options[@selected]
  end

  def render
    str = @options.map.with_index do |option, i|
      if option[:type] == :increment
        line = "◀ #{option[:title]}: #{option[:value]} #{option[:unit]} ►".center(33)
      else
        line = "#{option[:title]}".center(33)
      end
      i == @selected ? line.on_yellow : line
      end.join("\n")
    puts @prompt
    puts str
  end
  
  def take_action(input)
    case input
    when "w"
     @selected = (@selected - 1) % @options.length
    when "a"
      increment_selected(-1) 
    when "s"
     @selected = (@selected + 1) % @options.length
    when "d"
      increment_selected(1)
    when "\r"
      @done = true
    when "p"
      @done = true
    when "\e"
      @done = true
    end
    nil
  end
  
  def increment_selected(num)
    return nil unless @options[@selected][:type] == :increment
    new_val = @options[@selected][:value] + num
    @options[@selected][:value] = [new_val, 1].max
  end
  
  def done?
    @done
  end

end