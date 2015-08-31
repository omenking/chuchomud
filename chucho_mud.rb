# file:: bmud.rb
# author::  Ralph M. Churchill
# version:: 
# date::    
#
# This source code copyright (C) 2005 by Ralph M. Churchill
# All rights reserved.
#
# Released under the terms of the GNU General Public License
# See LICENSE file for additional information.
require 'pry'
require 'optparse'
require 'ostruct'
require 'strscan'
require 'yaml'
require 'log4r'
require 'log4r/yamlconfigurator'

$ROOT_PATH = Dir.pwd

require_relative "conf/config"

require_relative "util/connection_utils"
require_relative "util/dir_strings"
require_relative "util/interaction_utils"
require_relative "util/simple_stack"

require_relative "engine/mixins/nameable"
require_relative "engine/mixins/game_functions"
require_relative "engine/mixins/entity_container"
require_relative "engine/entities"

require_relative "engine/accessor"
require_relative "engine/account"
require_relative "engine/action"
require_relative "engine/basic_timer"
require_relative "engine/command"
require_relative "engine/database"
require_relative "engine/dice"
require_relative "engine/game"
require_relative "engine/handler"


require_relative "engine/logic"

require_relative "engine/logic_entities/character"
require_relative "engine/logic_entities/region"
require_relative "engine/logic_entities/room"
require_relative "engine/logic_entities/item"
require_relative "engine/logic_entities/portal"

require_relative "engine/logics/effect"
require_relative "engine/logics/example"

require_relative "engine/telnet_commands"
require_relative "engine/util"

require_relative "engine/handlers/character"
require_relative "engine/handlers/enter_game"
require_relative "engine/handlers/game"
require_relative "engine/handlers/help"
require_relative "engine/handlers/logon"
require_relative "engine/handlers/menu"

require_relative "lib/commands/admincommands"
require_relative "lib/commands/bad"
require_relative "lib/commands/clear"
require_relative "lib/commands/emote"
require_relative "lib/commands/get"
require_relative "lib/commands/give"
require_relative "lib/commands/go"
require_relative "lib/commands/help"
require_relative "lib/commands/inventory"
require_relative "lib/commands/kick"
require_relative "lib/commands/look"
require_relative "lib/commands/quit"
require_relative "lib/commands/say"
require_relative "lib/commands/status"
require_relative "lib/commands/time"
require_relative "lib/commands/use"

require_relative "lib/logic/character"
require_relative "lib/logic/game"
require_relative "lib/logic/item"
require_relative "lib/logic/region"
require_relative "lib/logic/room"

require_relative "network/manager"
require_relative "network/server"
require_relative "network/telnet_commands"
require_relative "network/net_connection"
require_relative "network/listener"
require_relative "network/player_connection"
require_relative "network/user_connection"

require_relative "engine/boot"
