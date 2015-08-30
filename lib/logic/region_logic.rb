# file:: region_logic.rb
# author::  Ralph M. Churchill
# version:: 
# date::    
#
# This source code copyright (C) 2005 by Ralph M. Churchill
# All rights reserved.
#
# Released under the terms of the GNU General Public License
# See LICENSE file for additional information.

require "#{$ROOT_PATH}/engine/logic"
require "#{$ROOT_PATH}/engine/region"

class DayNight < Effect
    frequency_in_sec 5*60
    delayed false
    applied_message ""
    effect_message  ""
    removed_message ""

    def apply_effect
        @daytime = !@daytime
        show(self.entity,(@daytime) ? 
        "The sun rises." :
        "The sun set.")
    end
end
