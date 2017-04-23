require "../../data/pass"

class SolidOn < InfinitePass
  property block_type : String = "block"
  property tile_type : String = "tile"
  
  def initialize(world, **args)
    super world
    @block_type = args[:block_type]? || block_type
    @tile_type = args[:tile_type]? || tile_type
  end
  
  def get_block_type(last_block : Block, x : Int32, y : Int32, z : Int32) : String?
    block_type
  end

  def get_tile_type(last_tile : Tile, x : Int32, y : Int32, z : Int32) : String?
    tile_type
  end
end