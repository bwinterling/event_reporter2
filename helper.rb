class Helper

  attr_reader :help_string

  def initialize
    @help_string = ""
  end

  def which_help_command(parts)
    command = parts[1..-1].join(" ").to_s
    case command
      when ""       then help
      when "load"
        @help_string = "\nLoads <filename>.  If no filename given, loads default."
      when "queue"
        @help_string = "\nERROR: Specify <count> <clear> or <print>."
      when "queue count"
        @help_string = "\nProvides current queue count."
      when "queue clear"
        @help_string = "\nClears current queue."
      when "queue print"
        @help_string = "\nPrints current queue.\nEnter 'queue print <attribute>' to sort list on attribute."
      when "queue save"
        @help_string = "\nSaves current queue to FILENAME.csv.\nSYNTAX: queue save to <filename>"
    else
      @help_string = "\n\nI'd help you '#{command}', if I knew what '#{command}' meant.\n\n"
    end
    puts_help_string_to_terminal
  end

  def help
    @help_string = '
    """
    == DESCRIPTION

    Event Reporter is a terminal client, built by Brian and George  

    == COMMAND SYNTAX
    command content_1 content_2 (no special characters required)

    == COMMANDS
    q                         :: Quit this application
    load filename             :: Load filename.csv
    find attribute criteria   :: Search loaded file for matches
                                 Don\'t forget to load the file first!
    queue clear               :: Clears the queue
    queue count               :: Count records in the queue
    queue print               :: Prints the queue
    queue print by <attr>     :: Prints by <attribute>
    queue save to <file>      :: Creates CSV from queue and saves as <filename>
    help                      :: View help information
    
    """
    '
  end

  def puts_help_string_to_terminal
    puts @help_string
  end


#end of Helper class
end
