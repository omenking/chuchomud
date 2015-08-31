MENU=<<EOH
--------------------------------------------------------------------------------
Welcome to #{BOLD}#{MAGENTA}Chucho MUD#{RESET}
--------------------------------------------------------------------------------
0 - Quit
1 - Enter Game
2 - Create New Character
3 - Delete Existing Character
4 - Help
--------------------------------------------------------------------------------
EOH
class MenuHandler < Handler
  def initialize(account,connection)
      @account,@conn = account,connection
  end

  def enter
    # handle already logged in
    @account.logged_in = true
    @conn.clear_screen
    @conn.prompt(MENU+"Choice: ")
  end

  def leave
    @account.logged_in = false
  end

  def handle(data)
    case data
    when /0/ then @conn.close
    when /1/ then @conn.add_handler(EnterGameHandler.new(@account,@conn))
    when /2/ then @conn.add_handler(NewCharacterHandler.new(@account,@conn))
    when /3/ then # add menu delete
    when /4/ then @conn.add_handler(HelpHandler.new(@conn))
    else
      @conn.display("Unrecognized Option.")
      @conn.prompt(MENU+"Choice: ")
    end
  end
end
