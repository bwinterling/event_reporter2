require 'csv'

class Queue

  attr_accessor :print_count

  def print_count
    @print_count
  end

  def initialize(event_reporter)
    @event_reporter = event_reporter
    @print_count = 0
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

  def column_widths
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

  def print_queue
    column_widths #sets column widths to longest record in column
    @print_count = 0 #print count is for testing, to compare with queue count
    puts "LAST NAME".ljust(@col1) + " | " + "FIRST NAME".ljust(@col2) + " | " + "EMAIL".ljust(@col3) + " | " + "ZIPCODE".ljust(@col4) + " | " + "CITY".ljust(@col5) + " | " + "STATE".ljust(@col6) + " | " + "ADDRESS".ljust(@col7) + " | " + "PHONE".ljust(@col8)
    @event_reporter.queue.each do |row|
      @print_count += 1
      puts row[:last_name].ljust(@col1) +  " | " + row[:first_name].ljust(@col2) + " | " + row[:email_address].ljust(@col3) + " | " + row[:zipcode].ljust(@col4) + " | " + row[:city].ljust(@col5) + " | " + row[:state].ljust(@col6) + " | " + row[:street].ljust(@col7) + " | " + row[:homephone].ljust(@col8)
    end
  end

#end of Queue class
end
