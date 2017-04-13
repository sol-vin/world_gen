require "./world"

abstract class InfiniteWorld < World
  @last_tile = Tile.new
  @last_block = Block.new

  # Gets a tile from the tiles array at a specified location.
  def get_tile(x : Int32, y : Int32) : Tile
    passes_clone = passes.dup
    while(passes_clone.size != 0)
      pass = passes_clone.shift
      new_tile = pass.get_tile(@last_tile, x, y)
      
      @last_tile.type = (new_tile.type.nil? ? @last_tile.type : new_tile.type)
      @last_tile.color = (new_tile.color ? new_tile.color : @last_tile.color)
      @last_tile.rotation = (new_tile.rotation ? new_tile.rotation : @last_tile.rotation)
    end
    @last_tile
  end
  
  # Gets a block from the blocks array at a specified location.
  def get_block(x : Int32, y : Int32, z : Int32) : Block
    passes_clone = passes.dup
    while(passes_clone.size != 0)
      pass = passes_clone.shift
      new_block = pass.get_block(@last_block, x, y, z)
      
      @last_block.type = (new_block.type ? new_block.type : @last_block.type)
      @last_block.color = (new_block.color ? new_block.color : @last_block.color)
      @last_block.rotation = (new_block.rotation ? new_block.rotation : @last_block.rotation)
    end 
    @last_block
  end

  def make_pass(pass, *args)
    if pass.is_a?(typeof(InfinitePass))
      super pass, *args
    else
      raise Exception.new("CANNOT ADD A FINITEPASS TO AN INFINITE WORLD #{pass}")
    end
  end
end