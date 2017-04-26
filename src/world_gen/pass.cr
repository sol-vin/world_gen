require "./data"

class Pass
  alias TileProc = Proc(Array(Tile), Array(Tile), Int32, Int32, Tile)
  alias BlockProc = Proc(Array(Block), Array(Block), Int32, Int32, Int32, Block)

  def initialize
    @tile_procs = [] of TileProc
    @block_procs = [] of BlockProc
    
    define_tile do |last_tiles, tiles, x, y|
      Tile.new
    end
    
    define_block do |last_blocks, blocks, x, y, z|
      Block.new
    end
  end

  # Makes a tile using the pass
  def get_tiles(last_tiles : Array(Tile), x : Int32, y : Int32) : Array(Tile)
    tiles = [] of Tile
    @tile_procs.each do |tile_proc|
      tiles << tile_proc.call(last_tiles, tiles, x, y)
    end
    tiles
  end
  
  # Makes a block using the pass
  def get_blocks(last_blocks : Array(Block), x : Int32, y : Int32, z : Int32) : Array(Block)
    blocks = [] of Block
    @block_procs.each do |block_proc|
      blocks << block_proc.call(last_blocks, blocks, x, y, z)
    end
    blocks
  end
  
  def define_tile(&block : TileProc)
    @tile_procs << block
  end

  def define_block(&block : BlockProc)
    @block_procs << block
  end
end