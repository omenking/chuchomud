class GameHandler < Handler
  def initialize(player,connection)
      @player,@conn = player,connection
  end

  def enter
    $evt_log.debug("GameHandler::enter")
    @player.add_logic(TelnetReporter.new(@player,@conn))
    $game.do_action(Action.new(:enterrealm,@player))
  end

	def leave
    $evt_log.debug("GameHandler::leave")
    $game.do_action(Action.new(:leaverealm,@player))
    tr = @player.find_logic_by_name("TelnetReporter")
    @player.del_logic(tr) if tr
	end

  def handle(data)
    $game.do_action(Action.new(:command,@player,
        { :data => data }))
  end
end
