require 'timeout'
require 'io/console'
class Block
end

def update_output(val)
  puts val
end



while true
  begin
  a = Timeout::timeout(0.01) {
    STDIN.getch
  }
  rescue
    break if a == "c"
    
  end
  system('clear')
  update_output(a)
end

