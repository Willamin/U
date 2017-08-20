require 'io/console'

def start
  now = DateTime.now.strftime("%m/%d/%Y - %I:%M %p")
  write "Started at #{now}"
end

def stop message
  now = DateTime.now.strftime("%m/%d/%Y - %I:%M %p")
  write "Stopped at #{now}"
  write "\t#{message}\n\n"
end

def write line
  open('tracker.txt', 'a') do |f|
    f.puts line
  end
end

class Tracker < U::Package
  script 'tracker' do |action|
    if action == 'start'
      start
    elsif action == 'stop'
      stop $stdin.gets.chomp
    end
  end
end