class Effect < Logic
    invoked_by :effect,:enterrealm,:leaverealm,:logged_out
    applicable_to Character,Region,Room,Item
    saveable

    # ##############################################
    # M E T A
    # ##############################################
    def self.metaclass
        class << self
            self
        end
    end
    def self.frequency_in_sec(sec)
        class_eval do
            define_method :freq do
                sec
            end
        end
    end
    def self.duration_in_sec(sec)
        class_eval do
            define_method :duration do
                sec
            end
        end
    end
    def self.delayed(d)
        class_eval do
            alias_method :_delayed, :delayed? 
            define_method :delayed? do
                d
            end
        end
    end
    def self.effect_message(msg)
        class_eval do
            define_method :effect do
                msg
            end
        end
    end
    # ##############################################
    # L O G I C
    # ##############################################
    def do_init
        @elapsed = 0
    end

    def do_added
        if not delayed? then
            apply_effect
        end
        send_effect_action
        @ends = send_end_action if ends?
    end

    def do_logic
        case @action
        when :effect
            apply_effect
            send_effect_action
            @elapsed += 1
        when :enterrealm
            @left ||= 0
            send_effect_action(@next-@left)
            @ends = send_end_action if ends?
        when :leaverealm
            @left = $game.time
        end
        true
    end
protected
    def apply_effect
        # needs to be implemented in subclass
    end
    def send_effect_action(at=freq*1_000)
        # action with effect
        inform(self.entity,effect)
        @next = $game.add_timed_action(Action.new(:effect,self),
            at, :relative => true)
    end
    def send_end_action
        $game.add_timed_action(Action.new(:dellogic,self.entity,{:logic=>self}),
                    ends*1_000, :relative => true)
    end
    def ends?
        defined?(duration)
    end
    def ends
        freq * ((duration/freq)-@elapsed)
    end
    def delayed?
        @delayed||=false
    end
end
