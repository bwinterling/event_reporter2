require 'csv'
require 'pry'

class EventReporter

  attr_reader :file_data
  attr_accessor :queue
  
  def initialize
    puts 'Initializing Event Reporter'
    @queue = []
  end

  def queue_count
    @queue.count
  end

  def run
    puts "Welcome to the Brian and George Amazing Event Reporter!!"
    input = ""
    while input != "q"
      puts ""
      printf "enter command:"
      input = gets.downcase.chomp
      process_command(input)
    end  
  end

  def process_command(input)
    parts = input.split(" ")
    command = parts[0] 
    case command
      when "help"       then which_help(parts)
      when "q"          then puts "Goodbye!"
      when "load"       then load_file(parts[1])
      when "find"       then find_records(parts[1..-1])
      when "queue"      then Queue.new(self).which_queue(parts[1..-1])
    else
      puts "Sorry, I don't know to #{command}"
    end
  #end of process command
  end

  def load_file(filename)
    if filename.nil?
      puts "Do not recognize #{filename}, loading default"
      filename = "event_attendees.csv"
    end
      @file_data = CSV.read "#{filename}", headers: true, header_converters: :symbol
      @attendee_data = @file_data.collect do |row|
        attendee = {
            :id             =>  row[0].to_s,
            :last_name      =>  row[:last_name].to_s,
            :first_name     =>  row[:first_name].to_s,
            :email_address  =>  row[:email_address].to_s,
            :zipcode        =>  clean_zipcode(row[:zipcode]),
            :city           =>  row[:city].to_s,
            :state          =>  row[:state].to_s,
            :street         =>  row[:street].to_s,
            :homephone      =>  clean_phonenum(row[:homephone]).to_s,
            :regdate        =>  row[:regdate].to_s,
            }
      end
  end

  def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5,"0")[0..4]
  end

  def clean_phonenum(phonenum)
    phone = phonenum.gsub(/\D/, "")
    case 
      when phone.length == 11 && phone[0] == "1" then phone[1..-1]
      when phone.length == 10 then phone
      else "0000000000"
    end
  end

  def find_records(parts)
    @queue.clear
    attribute = parts[0].downcase.to_sym
    criteria = parts[1].downcase
    @attendee_data.each do |row|
      if row[attribute].downcase == criteria
        @queue << row
      end
    end
  end

  def which_help(parts)
    command = parts[1..-1]
    case command
      when []       then help
      when ["queue", "count"]   then puts "Provides current queue count."
      when ["queue", "clear"]   then puts "Clears current queue."
      when ["queue", "print"]   then puts "Prints current queue.\nEnter 'queue print <attribute>' to sort list on attribute."
      when ["queue", "save"]   then puts "Clears current queue."
    else
      puts "Sorry, I don't know to #{command}"
    end
  end

  def help
    text = '
    """
    == DESCRIPTION

    Event Reporter is a terminal client, built by Brian and George  

    == COMMAND SYNTAX
    command content_1 content_2 (no special characters required)

    == COMMANDS
    q                         :: Quit this application
    find attribute criteria   :: Search loaded file for matches
    load filename             :: Load filename.csv
    queue count               :: Count records in the queue
    help                      :: View help information
    
    """
    '
    puts text
    text
  end
# end of EventReporter Class
end

class Queue

  def initialize(event_reporter)
    @event_reporter = event_reporter
  end

  def which_queue(parts)
    command = parts[0]
    case command
      when "count"  then count_queue
      when "clear"  then clear_queue
      when "print"  then print_queue
     # queue print by attribute
     # queue save to filename.csv
    else
      puts "Sorry, I don't know to queue #{command}"
    end
  end

  def count_queue
    # @queue_count = 0 if @queue.count.nil? else @queue_count = @queue.count
    count = @event_reporter.queue_count
    puts "There are #{count} records in the queue."
    count
  end

  def clear_queue
    @event_reporter.queue.clear
    count_queue
  end

  def print_queue
    puts "LAST NAME".ljust(15) + " | " + "FIRST NAME".ljust(12) + " | " + "EMAIL".ljust(45) + " | " + "ZIPCODE".ljust(10) + " | " + "CITY".ljust(30) + " | " + "STATE".ljust(6) + " | " + "ADDRESS".ljust(50) + " | " + "PHONE".ljust(14)
    @event_reporter.queue.each do |row|
      puts row[:last_name].ljust(15) +  " | " + row[:first_name].ljust(12) + " | " + row[:email_address].ljust(45) + " | " + row[:zipcode].ljust(10) + " | " + row[:city].ljust(30) + " | " + row[:state].ljust(6) + " | " + row[:street].ljust(50) + " | " + row[:homephone].ljust(14)
    end
  end

#end of Queue class
end


reporter = EventReporter.new
reporter.run
