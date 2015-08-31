class LogonHandler < Handler
  def initialize connection
    super
    @conn.extend ConnectionUtils
    @state = :init
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
    @state = :enter_name
  end

  def choose_class
    @conn.clear_screen
    @conn.display "-[*]=--=[+]=--=[*]=--=[+]=--=[ #{GREEN}SALTMINE CLASSES#{RESET} ]=--=[+]=--=[*]=--=[+]=--=[*]-"
    @conn.display ""
    @conn.display "Mage     : High powered spellcasting class. Many offensive spells but weak"
    @conn.display "           in unarmed and weapon based combat."
    @conn.display "Warrior  : Pure fighting machine. Warriors thrive on combat but cannot"
    @conn.display "           master the subtlety of thieves or the magical talents of mages."
    @conn.display "Thief    : Masters of poison and treachery the thieves are a secretive class."
    @conn.display "           The thieves' mastery of darker magics makes them a deadly enemy."
    @conn.display "Ranger   : The protectors of the realm. Excellent fighters that can also draw "
    @conn.display "           magical powers from the forces of nature."
    @conn.display "Psi      : Mystical spellcasting class about which little is known. A"
    @conn.display "           psionicist's magical ability comes from within."
    @conn.display "Paladin  : Noble warriors that pride honor and justice above all else. Skilled "
    @conn.display "           in combat and holy magic but completely master neither."
    @conn.display "Cleric   : Spellcasting class more based upon defensive and healing magics."
    @conn.display "           Combat skill more effective than mages but weaker combat spells."
    @conn.display ""
    @conn.display "Choose your class wisely- it has to last you 200+ levels. You will be able"
    @conn.display "to add additional classes or change your class later in the game. You can "
    @conn.display "use 'help [classname]' ('help mage' for example) for more information."
    @conn.display "-----------------------------------------------------------------------------"
    @conn.display "#{GREEN}Choose your primary class, '?' to list or 'Back' to go back:#{RESET}"
    @conn.prompt "> "
    @state = :choose_subclass
  end


  def choose_subclass
    @conn.clear_screen
    @conn.display "-[*]=--=[+]=--=[*]=--=[+]=--=[ MAGE SUBCLASSES ]=--=[+]=--=[*]=--=[+]=--=[*]-"
    @conn.display ""
    @conn.display "  Elementalist: Masters of the elements, members of this subclass enjoy"
    @conn.display "  enhanced control over earth-, wind-, fire-, and water-related abilities,"
    @conn.display "  whether defensive or offensive in nature."
    @conn.display ""
    @conn.display "  Enchanter: Experts in truly understanding the nature of all items in the"
    @conn.display "  realm, Enchanters are able to magically alter and enhance many things."
    @conn.display "  Highly-trained enchanters have also been known to enchant themselves!"
    @conn.display ""
    @conn.display "  Sorcerer: Specialized in sorcery and witchcraft, sorcerers have a wide"
    @conn.display "  range of abilities to weaken, confuse, restrict and inflict extra damage"
    @conn.display "  upon their victims."
    @conn.display ""
    @conn.display "-----------------------------------------------------------------------------"
    @conn.display "Choose your subclass, '?' to list or 'back' to go back :"
    @conn.prompt "> "
    @state = :choose_race
  end

  def choose_race
    @conn.clear_screen
    @conn.display "-[*]=--=[+]=--=[*]=--=[+]=--=[ AARDWOLF RACES ]=--=[+]=--=[*]=--=[+]=--=[*]-"
    @conn.display ""
    @conn.display "Suggested Races for Mage:"
    @conn.display ""
    @conn.display "Eldar    : Mysterious ancient race, masters of magic and lore."
    @conn.display "Elf      : Mentally and physically agile race enamoured with magic."
    @conn.display "Half-Grif: Strong magically-constructed flying creatures."
    @conn.display "Quickling: Faerie offshoots with an innate speed boost."
    @conn.display "Ratling  : Large, very cunning, upright-standing rodents."
    @conn.display "Sprite   : Small, agile faeries with the power of invisibility."
    @conn.display "Vampire  : Strong, intelligent creatures of the night."
    @conn.display ""
    @conn.display "Other races available: Centaur, Dark elf, Diva, Dwarf, Giant, Halfling,"
    @conn.display "                      Human, Lizardman, Shadow, Triton, Troll, Wolfen"
    @conn.display ""
    @conn.display "----------------------------------------------------------------------------"
    @conn.display "  More details on each race are available by typing 'help <racename>'"
    @conn.display "----------------------------------------------------------------------------"
    @conn.display ""
    @conn.display "Choose your race, '?' to list or 'back' to go back: "
    @conn.prompt "> "
    @state = :choose_gender
  end

  def choose_gender
    @conn.clear_screen
    @conn.display "-------------------------------------------------------------------------------"
    @conn.display ""
    @conn.display "Your character's sex has no direct impact on gameplay, but some quests may"
    @conn.display "interact with you differently based on sex and, of course, other players"
    @conn.display "will too."
    @conn.display ""
    @conn.display "------------------------------------------------------------------------------"
    @conn.display "Choose your sex or 'back' to race selection [M/F] : "
    @conn.prompt "> "
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
    @conn.switch_handler MenuHandler.new(@account,@conn)
    @state = nil
  end
end
