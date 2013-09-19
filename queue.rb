require 'csv'

class Queue

  def initialize(event_reporter)
    @event_reporter = event_reporter
  end

  def which_queue(parts)
    command = parts[0]
    case command
      when "count"  then count_queue
      when "clear"  then clear_queue
      when "print" 
        if parts[1] == 'by'
          @event_reporter.queue = @event_reporter.queue.sort_by { |row| row[parts[2].to_sym] }
          print_queue
        else
          print_queue
        end
      when "save"   then save_queue(parts[2])
      else
        puts "Sorry, I don't know to queue #{command}"
    end
  end

  def save_queue(filename)
    CSV.open(filename,'w') do |row|
      row << %w"id regdate first_name last_name email_address homephone street city state zipcode"
      @event_reporter.queue.each do |queue_row|
        row << [queue_row[:id], queue_row[:regdate].to_s, queue_row[:first_name].to_s.capitalize, queue_row[:last_name].to_s.capitalize, queue_row[:email_address].to_s, queue_row[:homephone].to_s, queue_row[:street].to_s, queue_row[:city].to_s, queue_row[:state].to_s, queue_row[:zipcode].to_s]
      end
    end
    puts "\nYour queue is now a fancy CSV file called #{filename}."
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
