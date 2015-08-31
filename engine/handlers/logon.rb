class LogonHandler < Handler
  def initialize connection
    super
    goto :init
  end

  def init
    clear
    display :hardbar
    display "#####[   Welcome to Chucho MUD.   ]##########################################"
    display "#####[                            ]##########################################"
    display "#####[                            ]##########################################"
    display :hardbar
    display :softbar
    display "Enter your #{YELLOW}character#{RESET} name or type #{YELLOW}'NEW'#{RESET} to create a new character"
    display :softbar
    display "What is your name, stranger?"
    prompt "> "
    goto :enter_name
  end

  def enter_name
    if @data =~ /new/ then
      clear
      display :softbar
      display "Welcome to the Saltimes! First you need to choose the character name that you"
      display "will be known by. Just type the name below to get started. You will probably"
      display "find that more common names are already taken so try to be creative!"
      display :softbar
      display "Please enter the character name you would like to use :"
      prompt "> "
      goto :create_character
    else
      if @account = $account_db.find_name(@data) 
        @conn.prompt "Password: "
        @conn.prompt [:hide,true]
        goto :enterpass
      else
        @conn.display("#{@data} not found.")
        @conn.prompt "Please enter your name or \"new\" if you are new: "
      end
    end
  end

  def create_character
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



  def choose_class
    clear
    display "-[*]=--=[+]=--=[*]=--=[+]=--=[ #{GREEN}SALTMINE CLASSES#{RESET} ]=--=[+]=--=[*]=--=[+]=--=[*]-"
    display ""
    display "Mage     : High powered spellcasting class. Many offensive spells but weak"
    display "           in unarmed and weapon based combat."
    display "Warrior  : Pure fighting machine. Warriors thrive on combat but cannot"
    display "           master the subtlety of thieves or the magical talents of mages."
    display "Thief    : Masters of poison and treachery the thieves are a secretive class."
    display "           The thieves' mastery of darker magics makes them a deadly enemy."
    display "Ranger   : The protectors of the realm. Excellent fighters that can also draw "
    display "           magical powers from the forces of nature."
    display "Psi      : Mystical spellcasting class about which little is known. A"
    display "           psionicist's magical ability comes from within."
    display "Paladin  : Noble warriors that pride honor and justice above all else. Skilled "
    display "           in combat and holy magic but completely master neither."
    display "Cleric   : Spellcasting class more based upon defensive and healing magics."
    display "           Combat skill more effective than mages but weaker combat spells."
    display ""
    display "Choose your class wisely- it has to last you 200+ levels. You will be able"
    display "to add additional classes or change your class later in the game. You can "
    display "use 'help [classname]' ('help mage' for example) for more information."
    display :softbar
    display "#{GREEN}Choose your primary class, '?' to list or 'Back' to go back:#{RESET}"
    prompt "> "
    goto :choose_subclass
  end


  def choose_subclass
    clear
    display "-[*]=--=[+]=--=[*]=--=[+]=--=[ MAGE SUBCLASSES ]=--=[+]=--=[*]=--=[+]=--=[*]-"
    display ""
    display "  Elementalist: Masters of the elements, members of this subclass enjoy"
    display "  enhanced control over earth-, wind-, fire-, and water-related abilities,"
    display "  whether defensive or offensive in nature."
    display ""
    display "  Enchanter: Experts in truly understanding the nature of all items in the"
    display "  realm, Enchanters are able to magically alter and enhance many things."
    display "  Highly-trained enchanters have also been known to enchant themselves!"
    display ""
    display "  Sorcerer: Specialized in sorcery and witchcraft, sorcerers have a wide"
    display "  range of abilities to weaken, confuse, restrict and inflict extra damage"
    display "  upon their victims."
    display ""
    display :softbar
    display "Choose your subclass, '?' to list or 'back' to go back :"
    prompt "> "
    goto :choose_race
  end

  def choose_race
    clear
    display "-[*]=--=[+]=--=[*]=--=[+]=--=[ AARDWOLF RACES ]=--=[+]=--=[*]=--=[+]=--=[*]-"
    display ""
    display "Suggested Races for Mage:"
    display ""
    display "Eldar    : Mysterious ancient race, masters of magic and lore."
    display "Elf      : Mentally and physically agile race enamoured with magic."
    display "Half-Grif: Strong magically-constructed flying creatures."
    display "Quickling: Faerie offshoots with an innate speed boost."
    display "Ratling  : Large, very cunning, upright-standing rodents."
    display "Sprite   : Small, agile faeries with the power of invisibility."
    display "Vampire  : Strong, intelligent creatures of the night."
    display ""
    display "Other races available: Centaur, Dark elf, Diva, Dwarf, Giant, Halfling,"
    display "                      Human, Lizardman, Shadow, Triton, Troll, Wolfen"
    display ""
    display :softbar
    display "  More details on each race are available by typing 'help <racename>'"
    display :softbar
    display ""
    display "Choose your race, '?' to list or 'back' to go back: "
    prompt "> "
    goto :choose_gender
  end

  def choose_gender
    clear
    display :softbar
    display ""
    display "Your character's sex has no direct impact on gameplay, but some quests may"
    display "interact with you differently based on sex and, of course, other players"
    display "will too."
    display ""
    display :softbar
    display "Choose your sex or 'back' to race selection [M/F] : "
    prompt "> "
  end



  def menu
    @conn.prompt([:hide,false])
    @conn.switch_handler MenuHandler.new(@account,@conn)
    @state = nil
  end
end
