require "./data"

class Pass
  alias TileProc = Proc(Array(Tile), Array(Tile), Int32, Int32, Tile)
  alias BlockProc = Proc(Array(Block), Array(Block), Int32, Int32, Int32, Block)
  
  BASIC_TILE_PROC =  ->(last_tiles : Array(Tile), tiles : Array(Tile), x : Int32, y : Int32) do
    Tile.new
  end

  BASIC_BLOCK_PROC = ->(last_blocks : Array(Block), blocks : Array(Block), x : Int32, y : Int32, z : Int32) do
    Block.new
  end


  def initialize(defaults = false)
    @tile_procs = [] of TileProc
    @block_procs = [] of BlockProc
    if defaults
      define_tile &BASIC_TILE_PROC
      define_block &BASIC_BLOCK_PROC
    end
  end

  # Makes a tile using the pass
  def get_tiles(last_tiles : Array(Tile), x : Int32, y : Int32) : Array(Tile)
    tiles = [] of Tile
    @tile_procs.each do |tile_proc|
      tile = tile_proc.call(last_tiles, tiles, x, y)
      tiles << tile if tile.type
    end
    tiles
  end
  
  # Makes a block using the pass
  def get_blocks(last_blocks : Array(Block), x : Int32, y : Int32, z : Int32) : Array(Block)
    blocks = [] of Block
    @block_procs.each do |block_proc|
      block = block_proc.call(last_blocks, blocks, x, y, z)
      blocks << block if block.type
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