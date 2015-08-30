require "#{$ROOT_PATH}/engine/character"
require "#{$ROOT_PATH}/engine/item"
require "#{$ROOT_PATH}/engine/portal"
require "#{$ROOT_PATH}/engine/room"
require "#{$ROOT_PATH}/engine/region"

# Anything that has an entity associated with it. HasEntity
# generalizes the accessor, so that any type of entity (e.g. Character,
# Room, Item) can be used.
module HasEntity
  def entity
    db = case @entity_type
    when Character.to_s then $character_db
    when Room.to_s      then $room_db
    when Item.to_s      then $item_db
    when Portal.to_s    then $portal_db
    when Region.to_s    then $region_db
    else
      $log.error("@{entity_type} not found")
      nil
    end
    if @entity_logic!=nil
      db.get(@entity_id).find_logic_by_name(@entity_logic)
    else
      db.get(@entity_id)
    end
  end

  def entity=(entity)
    if entity.kind_of?(Logic) then
      @entity_type  = entity.entity.class.to_s
      @entity_id    = entity.entity.oid
      @entity_logic = entity.class.to_s
    else
      @entity_type  = entity.class.to_s
      @entity_id    = entity.oid
      @entity_logic = nil
    end
  end
end
=begin
    def performer=(p)
        room.char,item,region,logic,logic_owner=nil
        case p.kind
        when Room
            room = p.oid
        when Character
            char = p.oid
        when Logic,Effect
            logic = p.name
            logic_owner = p.entity # owner
    end

    def performer
        if logic!=nil then
            logic_owner.find_logic_by_type(logic)
        else 
            [room,char,item,region].find {|e| e!=nil}
        end
    end
=end
