HELP=<<EOL
#{BOLD}Help#{RESET}
If you have not yet created a character, do so by selecting option #2. After you
create a character, select option #1 to enter the game. You will be presented
with a list of characters from which to choose. Enter a character's ID to begin 
the game!

Selecting "0" at any time will exit the current menu.
--- Press any key to continue ---
EOL
class HelpHandler < Handler
  def enter
    @conn.display(HELP)
  end

  def handle(data)
    @conn.remove_handler
  end
end
