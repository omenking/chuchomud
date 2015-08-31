# file:: handler.rb
# author::  Ralph M. Churchill
# version:: 
# date::    
#
# This source code copyright (C) 2005 by Ralph M. Churchill
# All rights reserved.
#
# Released under the terms of the GNU General Public License
# See LICENSE file for additional information.

class Handler
  def initialize connection
    @conn = connection
  end

  def enter
    #define yourself
  end

  def leave
    #define yourself
  end

  def handle data
    @data = data
    if self.respond_to? @state
      self.public_send @state
    else
      raise "state does not exist for handler #{@state}"
    end
  end
end
