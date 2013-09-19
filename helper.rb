class Helper

  def which_help(parts)
    command = parts[1..-1].join(" ").to_s
    case command
      when ""       then help
      when "load"
        text = "\nLoads <filename>.  If no filename given, loads default."
      when "queue"
        text = "\nERROR: Specify <count> <clear> or <print>."
      when "queue count"
        text = "\nProvides current queue count."
      when "queue clear"
        text = "\nClears current queue."
      when "queue print"
        text = "\nPrints current queue.\nEnter 'queue print <attribute>' to sort list on attribute."
      when "queue save"
        text = "\nSaves current queue to FILENAME.csv.\nSYNTAX: queue save to <filename>"
    else
      text = "\n\nI'd help you '#{command}', if I knew what '#{command}' meant.\n\n"
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

#end of Helper class
end
