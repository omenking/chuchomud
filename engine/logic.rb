# file:: logic.rb
# author::  Ralph M. Churchill
# version:: 
# date::    
#
# This source code copyright (C) 2005 by Ralph M. Churchill
# All rights reserved.
#
# Released under the terms of the GNU General Public License
# See LICENSE file for additional information.

# need a better name for the @entity... owner?
# Logic Function "API"
    # do_init: called when Logic created, allows for Logic initialization
    # do_added: called when Logic is added to @entity
    # do_removed: called when Logic is removed from @entity
    # do_logic: called when Logic is invoked
# Logic Assembly "API"
    # invoked_by
    # needs_data
    # optionally
    # saveable
    # applicable_to
    # applied_message
    # removed_message

# for flavor, could have messages for added,deleted,"acted upon" (i.e. when
# do_logic is called)!
class Logic
    include Observable,HasEntity,
            PlayerInteractionUtils,
            CharacterInteractionUtils,
            AreaInteractionUtils

    def stacking_rule
        @stacking_rule||=:exclusive
        @stacking_rule
    end

    def self.metaclass
        class << self
            self
        end
    end

    def self.invoked_by(*arr)
        class_eval do
            invokers=[]
            for i in arr
                invokers << i
            end
            define_method :invokers do
                invokers
            end
        end
    end
    def self.needs_data(*arr)
        attr_accessor *arr
        class_eval do
            data=[]
            for i in arr
                data << i
            end
            define_method :needed_data do
                data
            end
        end
    end
    def self.optionally(*arr)
        attr_accessor *arr
        class_eval do
            data=[]
            for i in arr
                data << i
            end
            define_method :optional_data do
                data
            end
        end
    end
    def self.saveable
        class_eval do
            define_method :save do
                true
            end
        end
    end
    def self.stackable(s=:exclusive)
        class_eval do
            raise "#{s} is not a valid stacking rule" unless \
                [:exclusive,:replaceable,:stackable].include?(s)
            instance_variable_set("@stacking_rule",s)
        end
    end
    def self.applicable_to(*arr)
        valid_for = []
        for i in arr
            valid_for << i
        end
        class_eval do
            define_method :initialize do |entity|
                raise "#{entity.class} not supported by this Logic" unless \
                    valid_for.include?(entity.class)
                    # instance_variable_set("@entity",entity)
                self.entity = entity
                do_init
            end
        end
    end
    def self.applied_message(msg)
        class_eval do
            define_method :applied do
                msg
            end
        end
    end
    def self.removed_message(msg)
        class_eval do
            define_method :removed do
                msg
            end
        end
    end
    # can this *method* be "frozen" ?
    def do_action(action)
        return true unless invokers.include?(action.type)
        @action = action.type
        @performer = action.performer
        needed_data.each do |k|
            d = action.data[k]
            # return true unless d
            raise "Missing required data \"#{k}\"." unless d
            instance_variable_set("@#{k}",d)
        end if respond_to?(:needed_data)

        optional_data.each do |k|
            d = action.data[k]
            instance_variable_set("@#{k}",d)
        end if respond_to?(:optional_data)

        $evt_log.debug("\t Applying #{self}")
        result = do_logic
        # should I "clear" the action data?
        @action = nil
        @performer = nil
        result
    end

    def should_save?
        (respond_to?(:save)) ? save : false
    end

    # function for logic initialization
    def do_init
    end

    # function for setting up, "starting" when a logic module is added
    # *successfylly* to an entity
    def do_added
    end

    def do_removed
    end

    #def method_missing
    #true
    #end
    def clear_timers
        $evt_log.info("#{self} wants to clear (#{self.count_observers}) timers")
        changed
        notify_observers(self)
    end
end
