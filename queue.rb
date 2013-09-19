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
