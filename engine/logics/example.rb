class ExampleLogic < Logic
    #applicable_to_entity
    applicable_to Character
    #invoked_by_action
    invoked_by :cangetitem,:canreceiveitem,:getitem,:dropitem,:giveitem
    needs_data :item,:quantity
    stackable :stackable

    def do_logic
        puts("#{self.entity} doing: #{@action} using Item: #{@item} and Quantity: #{@quantity}")
    end
end
