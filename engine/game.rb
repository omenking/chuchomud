# file:: game.rb
# author::  Ralph M. Churchill
# version:: 
# date::    
#
# This source code copyright (C) 2005 by Ralph M. Churchill
# All rights reserved.
#
# Released under the terms of the GNU General Public License
# See LICENSE file for additional information.
$: << "vendor"
require 'pqueue'

class Game
  include GameFunctions
  attr_accessor :running

  def initialize
    @timer_registery = PQueue.new(proc{|x,y| x<y})
    @running         = true
    @players         = []
    @basic_timer     = Timer.new
  end

  def time
    @basic_timer.ms
  end

  def setup
    $log.info("Resetting time to #{@time}")
    @basic_timer.reset(@time)
    @timer_registery = PQueue.new(proc{|x,y| x<y})

    @reg.reject!{|act| act.when < @time} # clear old data !!

    @timer_registery.replace_array(@reg) if @reg
    $command_db   = CommandDatabase.new
    $logic_db     = LogicDatabase.new
    $character_db = CharacterDatabase.new
    $item_db      = ItemDatabase.new
    $room_db      = RoomDatabase.new
    $portal_db    = PortalDatabase.new
    $region_db    = RegionDatabase.new
    $account_db   = AccountDatabase.new
  end

  def shutdown
    @players.dup.each do |p|
      p.do_action(Action.new(:leave,p))
    end
  end

  def running?
    @running
  end

  def execute_loop
      while (not @timer_registery.empty?) and @timer_registery.top.when <= time
          t_act = @timer_registery.pop
          if t_act.valid? then
              t_act.unhook
              begin
                  do_action(t_act.action)
              rescue => e
                  $log.error(e.backtrace.join("\n"))
                  $log.error("Error #{e} in execute loop")
              end
          else
              $log.debug("Discarded #{t_act}(#{t_act.action})")
          end
      end
  end

  def do_action(action)
      $evt_log.info("Game wants to handle => #{action}")
      case action.type
      when :spawnitem          then spawn_item(action.data[:item],action.data[:where])
      when :spawncharacter     then spawn_char(action.data[:character],action.data[:where])
      when :attemptgetitem     then get_item(action.performer,action.data[:item],action.data[:quantity])
      when :attemptdropitem    then give_item(action.performer,action.performer.room,action.data[:item],action.data[:quantity])
      when :attempttransport   then transport(action.performer,action.data[:room])
      when :attemptenterportal then transport(action.performer,action.data[:room], action.data[:portal])
      when :enterrealm         then login(action.performer)
      when :leaverealm         then logout(action.performer)
      when :command
        return if not action.data[:data] or action.data[:data].empty?
        do_command(action.performer,action.data[:data])
      when :attemptsay  then say(action.performer,action.data[:msg])
      when :attemptlook then look(action.performer,action.data[:target])
      when :vision,:sound
        action.performer.characters.each do |occ|
          occ.do_action(action)
        end
      when :attemptgiveitem then give_item(action.performer,action.data[:to],action.data[:item],action.data[:quantity])
      when :deleteitem      then delete_item(action.data[:item])
      when :addlogic        then action.performer.add_logic(action.data[:logic])
      when :dellogic        then action.performer.del_logic(action.data[:logic])
      when :attemptuseitem  then use_item(action.performer,action.data[:item])
      else
        $log.error("Game cannot handle => #{action.type}")
        # -------------------------------------------------------------------
        # This is kind of a Hack for message_logic... see TODO
        # -------------------------------------------------------------------
        action.performer.do_action(action) if action.performer
      end
  end


  def load_all
    $command_db.load_all
    $logic_db.load_all
    $account_db.load_all
    $character_db.load_templates
    $item_db.load_templates

    $region_db.load_all
    $character_db.load_players
    #load_timers
  end

  def save_all
    $account_db.save_all
    $character_db.save_players
    $region_db.save_all
  end

  def to_yaml_properties
    @time = @basic_timer.ms
    @reg  = @timer_registery.to_a
    instance_variables - ['@timer_registery']
  end

  def add_timed_action(action,time,opts)
    $evt_log.info(
    "#{action} will fire at #{Timer.digital(time+self.time)}; it is #{@basic_timer.digital}")
    ta = TimedAction.new(action,(opts[:relative] or not opts[:absolute]) ? time + self.time : time)
    @timer_registery.push(ta)
    ta.hook
    ta.when
  end
end
