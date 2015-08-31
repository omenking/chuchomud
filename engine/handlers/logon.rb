class LogonHandler < Handler
  def initialize connection
    super
    @conn.extend ConnectionUtils
    @state = :init
  end

  def handle(data)
    @data = data
    case @state
    when :init         then init
    when :entername    then enter_name
    when :enternewname then enter_new_name
    when :enternewpass then enter_new_pass
    when :enterpass
    end
  end

  def init
    @conn.clear_screen
    @conn.display "#############################################################################"
    @conn.display "#####[   Welcome to Chucho MUD.   ]##########################################"
    @conn.display "#####[                            ]##########################################"
    @conn.display "#####[                            ]##########################################"
    @conn.display "#############################################################################"
    @conn.display "-----------------------------------------------------------------------------"
    @conn.display "Enter your #{YELLOW}character#{RESET} name or type #{YELLOW}'NEW'#{RESET} to create a new character"
    @conn.display "-----------------------------------------------------------------------------"
    @conn.display "What is your name, stranger?"
    @conn.prompt "> "
    @state = :entername
  end

  def enter_name
    if @data =~ /new/ then
      @state = :enternewname
      @conn.prompt  "Please enter your desired username:"
    else
      if @account = $account_db.find_name(@data) 
        @state = :enterpass
        @conn.prompt("Password: ")
        @conn.prompt([:hide,true])
      else
        @conn.display("#{@data} not found.")
        @conn.prompt "Please enter your name or \"new\" if you are new: "
      end
    end
  end

  def enter_new_name
    if $account_db.find_name(@data) then
      @conn.display("Sorry, \"#{@data}\" is already taken.")
      @conn.prompt("Please enter another name: ")
    elsif not $account_db.acceptable_name?(@data) then
      @conn.display("Sorry, \"#{@data}\" is not acceptable.")
      @conn.prompt("Please enter another name: ")
    else
      @state = :enternewpass
      @name = @data
      @conn.prompt "Please enter your desired password: "

      #@conn.display "--------------------------------------------------------------------------"
      #@conn.display "Welcome to the Saltimes! First you need to choose the character name that you"
      #@conn.display "will be known by. Just type the name below to get started. You will probably"
      #@conn.display "find that more common names are already taken so try to be creative!"
      #@conn.display "---------------------------------------------------------------------------"
      #@conn.display "Please enter the character name you would like to use :"
      #@conn.prompt "> "

      @conn.prompt([:hide,true])
    end
  end

  def enter_new_pass
    # valid pass?
    @conn.display("Account Accepted. Entering...")
    @account = $account_db.create(@name,@data)
    $account_db.add(@account)
    @name = nil
    menu 
  end

  def enter_pass
    if @data == @account.password
      menu
    else
      @conn.display "Invalid Password!"
      @conn.prompt "Password: "
    end
  end

  def menu
    @conn.prompt([:hide,false])
    @conn.switch_handler(MenuHandler.new(@account,@conn))
    @state = nil
  end
end
