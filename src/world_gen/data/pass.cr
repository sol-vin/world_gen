require "./block"
require "./tile"

class Pass
  def initialize(*args)
  end

  # Makes a tile using the pass
  def get_tile(x : Int32, y : Int32) : Tile
    tile = Tile.new
    tile.type = get_tile_type(x, y)
    tile.rotation = get_tile_rotation(x, y)
    tile.color = get_tile_color(x, y)
    tile
  end
  
  # Makes a block using the pass
  def get_block(x : Int32, y : Int32, z : Int32) : Block
    block = Block.new
    block.type = get_block_type(x, y, z)
    block.rotation = get_block_rotation(x, y, z)
    block.color = get_block_color(x, y, z)
    block
  end

  # Gets a tile type. If this returns ```nil```, this option will not get changed on a worlds tile 
  def get_tile_type(last_tile : Tile?, x : Int32, y : Int32) : String?
    nil
  end

  # Gets a tile rotation. If this returns ```nil```, this option will not get changed on a worlds tile 
  def get_tile_rotation(last_tile : Tile?, x : Int32, y : Int32) : String?
    nil
  end
  # Gets a tile color. If this returns ```nil```, this option will not get changed on a worlds tile 
  def get_tile_color(last_tile : Tile?, x : Int32, y : Int32) : Color? 
    nil
  end

  # Gets a block type. If this returns ```nil```, this option will not get changed on a worlds block 
  def get_block_type(last_block : Block?, x : Int32, y : Int32, z : Int32) : String?
    nil
  end

  # Gets a block rotation. If this returns ```nil```, this option will not get changed on a worlds block 
  def get_block_rotation(last_block : Block?, x : Int32, y : Int32, z : Int32) : String?
    nil
  end

  # Gets a block color. If this returns ```nil```, this option will not get changed on a worlds block
  def get_block_color(last_block : Block?, x : Int32, y : Int32, z : Int32) : Color?
    nil
  end
end