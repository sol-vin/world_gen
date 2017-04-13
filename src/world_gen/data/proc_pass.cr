require "./pass"

class FiniteProcPass < FinitePass
  alias TileProc = Proc(FiniteWorld, Tile, Int32, Int32, (String | Color | Nil))
  alias BlockProc = Proc(FiniteWorld, Block, Int32, Int32, Int32, (String | Color | Nil))

  def initialize(world, *args)
    @tile_procs = {} of Symbol => TileProc
    @block_procs = {} of Symbol => BlockProc
    define_tile(:type) do |world, last_tile, x, y|
      nil
    end

    define_tile(:color) do |world, last_tile, x, y|
      nil
    end

    define_tile(:rotation) do |world, last_tile, x, y|
      nil
    end

    define_block(:type) do |world, last_block, x, y, z|
      nil
    end

    define_block(:color) do |world, last_block, x, y, z|
      nil
    end

    define_block(:rotation) do |world, last_block, x, y, z|
      nil
    end

    super world, *args
  end
  
  def define_tile(name : Symbol, &block)
    @tile_procs[name] = block
  end

  def define_block(name : Symbol, &block)
    @block_procs[name] = block
  end

  def get_tile_type(last_tile : Tile, x : Int32, y : Int32) : String?
    @tile_procs[:type].call(world, last_tile, x, y).as(String?)
  end

  # Gets a tile rotation. If this returns ```nil```, this option will not get changed on a worlds tile 
  def get_tile_rotation(last_tile : Tile, x : Int32, y : Int32) : String?
    @tile_procs[:rotation].call(world, last_tile, x, y).as(String?)
  end
  # Gets a tile color. If this returns ```nil```, this option will not get changed on a worlds tile 
  def get_tile_color(last_tile : Tile, x : Int32, y : Int32) : Color? 
    @tile_procs[:color].call(world, last_tile, x, y).as(Color?)
  end

  # Gets a block type. If this returns ```nil```, this option will not get changed on a worlds block 
  def get_block_type(last_block : Block, x : Int32, y : Int32, z : Int32) : String?
    @block_procs[:type].call(world, last_block, x, y, z).as(String?)
  end

  # Gets a block rotation. If this returns ```nil```, this option will not get changed on a worlds block 
  def get_block_rotation(last_block : Block, x : Int32, y : Int32, z : Int32) : String?
    @block_procs[:rotation].call(world, last_block, x, y, z).as(String?)
  end

  # Gets a block color. If this returns ```nil```, this option will not get changed on a worlds block
  def get_block_color(last_block : Block, x : Int32, y : Int32, z : Int32) : Color?
    @block_procs[:color].call(world, last_block, x, y, z).as(Color?)
  end
end

class InfiniteProcPass < InfinitePass
  alias TileProc = Proc(World, Tile, Int32, Int32, (String | Color | Nil))
  alias BlockProc = Proc(World, Block, Int32, Int32, Int32, (String | Color | Nil))

  def initialize(world, *args)
    @tile_procs = {} of Symbol => TileProc
    @block_procs = {} of Symbol => BlockProc
    define_tile(:type) do |world, last_tile, x, y|
      nil
    end

    define_tile(:color) do |world, last_tile, x, y|
      nil
    end

    define_tile(:rotation) do |world, last_tile, x, y|
      nil
    end

    define_block(:type) do |world, last_block, x, y, z|
      nil
    end

    define_block(:color) do |world, last_block, x, y, z|
      nil
    end

    define_block(:rotation) do |world, last_block, x, y, z|
      nil
    end

    super world, *args
  end
  
  def define_tile(name : Symbol, &block : TileProc)
    @tile_procs[name] = block
  end

  def define_block(name : Symbol, &block : BlockProc)
    @block_procs[name] = block
  end

  def get_tile_type(last_tile : Tile, x : Int32, y : Int32) : String?
    @tile_procs[:type].call(world, last_tile, x, y).as(String?)
  end

  # Gets a tile rotation. If this returns ```nil```, this option will not get changed on a worlds tile 
  def get_tile_rotation(last_tile : Tile, x : Int32, y : Int32) : String?
    @tile_procs[:rotation].call(world, last_tile, x, y).as(String?)
  end
  # Gets a tile color. If this returns ```nil```, this option will not get changed on a worlds tile 
  def get_tile_color(last_tile : Tile, x : Int32, y : Int32) : Color? 
    @tile_procs[:color].call(world, last_tile, x, y).as(Color?)
  end

  # Gets a block type. If this returns ```nil```, this option will not get changed on a worlds block 
  def get_block_type(last_block : Block, x : Int32, y : Int32, z : Int32) : String?
    @block_procs[:type].call(world, last_block, x, y, z).as(String?)
  end

  # Gets a block rotation. If this returns ```nil```, this option will not get changed on a worlds block 
  def get_block_rotation(last_block : Block, x : Int32, y : Int32, z : Int32) : String?
    @block_procs[:rotation].call(world, last_block, x, y, z).as(String?)
  end

  # Gets a block color. If this returns ```nil```, this option will not get changed on a worlds block
  def get_block_color(last_block : Block, x : Int32, y : Int32, z : Int32) : Color?
    @block_procs[:color].call(world, last_block, x, y, z).as(Color?)
  end
end