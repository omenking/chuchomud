# file:: help.rb
# author::  Ralph M. Churchill
# version:: 
# date::    
#
# This source code copyright (C) 2005 by Ralph M. Churchill
# All rights reserved.
#
# Released under the terms of the GNU General Public License
# See LICENSE file for additional information.

class Help < Command
    def initialize(char)
      super char,
            'help',
            'help [command]',
            'Print the list of commands or get help on a specific command.'
    end

    def execute(args)
        helpon = args.join(' ') if args
        msg =
        if helpon and (not helpon.empty?) then
          if cmd = self.character.find_command(helpon) 
            cmd.usage+EOL+cmd.description
          else
            "No help available for \"#{helpon}\""
          end
        else
          commands = [
            ['/' , 'repeat the last command'],
            ['\'', 'alias for "say"'],
            ['me', 'alias for  "emote"']
          ]
          self.character.commands.each{|c|commands << [c.name,c.description]}
          len = commands.max_by{|c| c[0].size}.size+2

          commands.map do |c|
            space = len - c[0].size
            space = space.times.map{''}.join(' ')
            "#{BOLD+c[0]+RESET}#{space}- #{c[1]}"
          end.join(EOL)
        end
        self.inform msg
    end
end
