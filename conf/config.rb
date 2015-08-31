# file:: config.rb
# author::  Ralph M. Churchill
# version:: 
# date::    
#
# This source code copyright (C) 2006 by Ralph M. Churchill
# All rights reserved.
#
# Released under the terms of the GNU General Public License
# See LICENSE file for additional information.

require 'singleton'
require 'pathname'

module ChuchoMUD
  class Config
    include Singleton

    attr_accessor :module_name

    def module_directory
      @module_directory ||= Pathname.new(File.join($ROOT_PATH,'modules', self.module_name))
    end
  end
end
