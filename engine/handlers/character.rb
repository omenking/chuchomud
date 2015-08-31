RACES=<<EOF
EOF
class NewCharacterHandler < Handler
    def initialize(account,connection)
        @account,@conn,@char = account,connection,nil
    end

    def enter
        # print templates
        @conn.prompt(
"--------------------------------------------------------------------------------
Please select a template:
--------------------------------------------------------------------------------
")
        $character_db.templates.each do |t|
            @conn.display(
            "#{t.oid} - #{t.name}: #{t.description}") if t and t.playable?
        end
        @conn.prompt(
"--------------------------------------------------------------------------------
Choice: ")

    end

    def leave
    end
    def handle(data)
        @conn.remove_handler if data=~/^0/

        if @char then
            if not $account_db.acceptable_name?(data) then
                @conn.display("Sorry, \"#{data}\" is not acceptable.")
                @conn.prompt("Please enter another name: ")
            elsif $character_db.find{|c|c.named?(data)} then
                @conn.display("Sorry, \"#{data}\" is already taken.")
                @conn.prompt("Please enter another name: ")
            else
                @char.name = data

                # go BACK to menu?
                @conn.remove_handler
                return
            end
        end

        @conn.remove_handler if data=~/0/

        tmpl = $character_db.get_template(data.to_i) # from list of races/templates
        if not tmpl
            @conn.prompt(
            "Invalid option, please try again: ")
            return
        end

        @char = $character_db.generate(data.to_i)
        @char.account = @account.oid
        @account.add_character(@char)
        setup(@char)
        @conn.prompt(
        "Please enter your desired name: ")
    end

    def setup(char)
        # could be moved to something fancier, but for now:
        $command_db.give_commands(char)
        char.room=$room_db.get(1)
        char.region=$region_db.get(1)
    end
end

