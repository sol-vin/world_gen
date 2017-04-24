require "./block"
require "./tile"

class Pass
  alias TileProc = Proc(Tile, Int32, Int32, String?)
  alias BlockProc = Proc(Block, Int32, Int32, Int32, String?)
  
  def initialize
    @tile_procs = {} of Symbol => TileProc
    @block_procs = {} of Symbol => BlockProc
    
    define_tile(:type) do |last_tile, x, y|
      nil
    end
    
    define_tile(:color) do |last_tile, x, y|
      nil
    end
    
    define_tile(:rotation) do |last_tile, x, y|
      nil
    end

    define_tile(:flip_h) do |last_tile, x, y|
      nil
    end
    
    define_block(:type) do |last_block, x, y, z|
      nil
    end
    
    define_block(:color) do |last_block, x, y, z|
      nil
    end
    
    define_block(:rotation) do |last_block, x, y, z|
      nil
    end

    define_block(:flip_h) do |last_block, x, y, z|
      nil
    end
  end

  # Makes a tile using the pass
  def get_tile(last_tile : Tile, x : Int32, y : Int32) : Tile
    tile = Tile.new
    tile.type = @tile_procs[:type].call(last_tile, x, y)
    tile.rotation = @tile_procs[:rotation].call(last_tile, x, y)
    tile.color = @tile_procs[:color].call(last_tile, x, y)
    tile.flip_h = @tile_procs[:flip_h].call(last_tile, x, y)
    tile
  end
  
  # Makes a block using the pass
  def get_block(last_block : Block, x : Int32, y : Int32, z : Int32) : Block
    block = Block.new
    block.type = @block_procs[:type].call(last_block, x, y, z)
    block.rotation = @block_procs[:rotation].call(last_block, x, y, z)
    block.color = @block_procs[:color].call(last_block, x, y, z)
    block.flip_h = @block_procs[:flip_h].call(last_block, x, y, z)
    block
  end
  
  def define_tile(name : Symbol, &block : TileProc)
    @tile_procs[name] = block
  end

  def define_block(name : Symbol, &block : BlockProc)
    @block_procs[name] = block
  end
end