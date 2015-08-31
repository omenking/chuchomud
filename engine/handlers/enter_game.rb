class EnterGameHandler < Handler
    def initialize(account,connection)
        @account,@conn = account,connection
    end

    def enter
        @account.characters.each do |c|
            @conn.display("#{c.oid} - #{c.name}")
        end
        @conn.prompt("Choice: ")
    end
    def leave
    end
    def handle(data)
        case data
        when /^0/
            @conn.remove_handler
        else
            @player = @account.characters.find{|c| c.oid==data.to_i}
            if not @player then
                @conn.display("Invalid Character.")
                @conn.prompt("Choice: ")
            else
                @conn.clear_screen
                @conn.switch_handler(
                    GameHandler.new(@player,@conn))
                update_player
                update_from_template($character_db)
                # update_from_template($item_db)
            end
        end
    end

    def update_player
        $command_db.give_commands(@player)
    end

    def update_from_template(db)
        db.each do |c|
            if c == @player then
                template = db.get_template(c.template_id)
                (template.logics - c.logics).each do |l|
                    c.add_logic(
                        $logic_db.generate(l,c)) 
                end
                template.attributes.each do |k,v|
                    c[k] = v unless c.has_key?(k)
                end
            end
        end
    end
end
