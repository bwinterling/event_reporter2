require 'minitest'
require 'minitest/autorun'
require './event_reporter'

class EventReporterTest < MiniTest::Test

  def setup
    @reporter = EventReporter.new
  end

  def test_create_instance
    refute_nil @reporter
  end

  def test_load_csv
    @reporter.load_file('event_attendees.csv')
    refute_nil @reporter.file_data
  end 

  def test_initial_queue_count_equals_zero
    assert_equal @reporter.queue.count, 0
  end

  def test_find_first_name_john
    @reporter.process_command("load")
    @reporter.process_command("find first_name John")
    assert_equal @reporter.queue.count, 63
    name = @reporter.queue.all? { |row| row[:first_name].downcase == "john"  }
    assert name
  end

  def load_queue
    @reporter.process_command("load")
    @reporter.process_command("find first_name John")
  end

  def test_clear_queue
    load_queue
    assert_equal @reporter.queue.count, 63
    @reporter.process_command("queue clear")
    assert_equal @reporter.queue.count, 0
  end

  def test_help_command
    @reporter.process_command("help")   
    refute @reporter.help.nil?
  end

  def test_help_load
    @reporter.process_command("help load")
  end

  # def test_queue_print
  #   @reporter.process_command("load")
  #   @reporter.process_command("find first_name John")
  #   @reporter.process_command("queue print") 
  # end

  # def test_find_first_name_john
  # end

# queue count should return 63
# queue clear
# queue count should return 0
# help should list the commands
# help queue count should explain the queue count function
# help queue print should explain the printing function



end

