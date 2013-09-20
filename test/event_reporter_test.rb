require 'minitest'
require 'minitest/autorun'
require './event_reporter'
require './helper'
require './queue'
require 'csv'

class EventReporterTest < MiniTest::Test

  def setup
    @reporter = EventReporter.new
  end

  def test_create_instance
    refute_nil @reporter
  end

  def test_load_csv
    @reporter.process_command('load event_attendees.csv')
    refute_nil @reporter.attendee_data
  end 

  def test_initial_queue_count_equals_zero
    assert_equal @reporter.queue_count, 0
  end

  def test_find_first_name_john
    @reporter.process_command("load")
    @reporter.process_command("find first_name John")
    assert_equal @reporter.queue_count, 63
    name = @reporter.queue.all? { |row| row[:first_name].downcase == "john"  }
    assert name
  end

  def test_find_state_ca
    @reporter.process_command("load")
    @reporter.process_command("find state CA")
    assert @reporter.queue.all? { |row| row[:state] == "CA" }
  end

  def load_queue
    @reporter.process_command("load")
    @reporter.process_command("find first_name John")
  end

  def test_clear_queue
    load_queue
    assert_equal @reporter.queue_count, 63
    @reporter.process_command("queue clear")
    assert_equal @reporter.queue_count, 0
  end

  def test_help_command
    @reporter.process_command("help")
    assert Helper.new.help_string, Helper.new.help
  end

  def test_help_load
    @reporter.process_command("help load")
    result = "\nLoads <filename>.  If no filename given, loads default."
    assert Helper.new.help_string, result
  end

  def test_queue_print
    @reporter.process_command("load")
    @reporter.process_command("find first_name John")
    @reporter.process_command("queue print") 
    assert @reporter.print_count, @reporter.queue_count
  end

  def test_queue_save
    filename = 'john.csv'
    @reporter.process_command("load")
    @reporter.process_command("find first_name John")
    @reporter.process_command("queue save to #{filename}")
    testfile = File.open(filename, 'r') 
    refute_nil testfile
  end

end

