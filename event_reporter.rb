require 'pry'
require './loader.rb'
require './queue.rb'
require './helper.rb'

class EventReporter

  attr_reader :attendee_data
  attr_accessor :queue
  
  def initialize
    puts 'Initializing Event Reporter'
    @queue = []
  end

  def queue_count
    @queue.count
  end

  def run
    puts "============================================\n\n Welcome to the Brian and George's\n Most Amazingest Event Reporter EVER!!!!!\n\n============================================\n\n\n\nYour wish is my command, but if you\nfind yourself unsure, just type help.\n\n\n"
    input = ""
    while input != "q"
      puts ""
      printf "Wish:"
      input = gets.downcase.chomp
      process_command(input)
    end  
  end

  def process_command(input)
    parts = input.split(" ")
    command = parts[0] 
    case command
      when "help"       then call_helper(parts)
      when "q"          then puts "\n\nGoodbye!"
      when "load"       then load_file(parts[1])
      when "find"       then find_records(parts[1..-1])
      when "queue"      then Queue.new(self).which_queue(parts[1..-1])
    else
      puts "\nSorry, I don't know to #{command}.\nYou can #{command} on your own time."
    end
  #end of process command
  end

  def call_helper(parts)
    text = Helper.new.which_help(parts)
    puts text
  end

  def load_file(filename)
    if filename.nil?
      puts "Do not recognize filename, loading default"
      @attendee_data = Loader.new.load_csv("event_attendees.csv")
    else
      @attendee_data = Loader.new.load_csv(filename)
    end
  end

  def find_records(parts)
    @queue.clear
    if parts[0] == 'all' 
      @queue = @attendee_data
    else
      attribute = parts[0].downcase.to_sym
      criteria = parts[1..-1].join(" ").downcase
      @attendee_data.each do |row|
        if row[attribute].downcase == criteria
          @queue << row
        end
      end
    end
  end

# end of EventReporter Class
end

# reporter = EventReporter.new
# reporter.run
