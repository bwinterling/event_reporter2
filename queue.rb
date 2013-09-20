require 'csv'

class Queue

  def initialize(event_reporter)
    @event_reporter = event_reporter
  end

  def which_queue_command(parts)
    command = parts[0]
    case command
      when "count"
        count_the_queue
      when "clear"
        clear_the_queue
      when "print" 
        printer = PrintQueue.new(@event_reporter)
        printer.which_print_command(parts[1..-1])
      when "save"
        save_queue(parts[2])
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

  def count_the_queue
    # @queue_count = 0 if @queue.count.nil? else @queue_count = @queue.count
    count = @event_reporter.queue_count
    puts "There are #{count} records in the queue."
    count
  end

  def clear_the_queue
    @event_reporter.queue.clear
    count_queue
  end

#end of Queue class
end

class PrintQueue

  def initialize(event_reporter)
    @event_reporter = event_reporter
    @event_reporter.print_count = 0
  end

  def which_print_command(parts)
    if parts[0] == 'by'
      @event_reporter.queue = @event_reporter.queue.sort_by { |row| row[parts[1].to_sym] }
      print_to_screen
    else
      print_to_screen
    end
  end

  def set_column_widths_to_longest_record
    col_last = [10]
    col_first = [10]
    col_email = [20]
    col_city = [10]
    col_str = [20]
    padding = 2

    @event_reporter.queue.each do |row|
      col_last << row[:last_name].length
      col_first << row[:first_name].length
      col_email << row[:email_address].length
      col_city << row[:city].length
      col_str << row[:street].length
    end

    @col1 = col_last.max + padding
    @col2 = col_first.max + padding
    @col3 = col_email.max + padding
    @col4 = 9
    @col5 = col_city.max + padding
    @col6 = 7
    @col7 = col_str.max + padding
    @col8 = 13
  end

  def print_to_screen
    set_column_widths_to_longest_record 
    @event_reporter.print_count = 0 #print count is for testing, to compare with queue count
    puts "LAST NAME".ljust(@col1) + " | " + "FIRST NAME".ljust(@col2) + " | " + "EMAIL".ljust(@col3) + " | " + "ZIPCODE".ljust(@col4) + " | " + "CITY".ljust(@col5) + " | " + "STATE".ljust(@col6) + " | " + "ADDRESS".ljust(@col7) + " | " + "PHONE".ljust(@col8)
    @event_reporter.queue.each do |row|
      @event_reporter.print_count += 1
      puts row[:last_name].ljust(@col1) +  " | " + row[:first_name].ljust(@col2) + " | " + row[:email_address].ljust(@col3) + " | " + row[:zipcode].ljust(@col4) + " | " + row[:city].ljust(@col5) + " | " + row[:state].ljust(@col6) + " | " + row[:street].ljust(@col7) + " | " + row[:homephone].ljust(@col8)
    end
  end
# end of PrintQueue class
end

