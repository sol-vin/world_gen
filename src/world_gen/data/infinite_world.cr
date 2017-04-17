require "./world"

abstract class InfiniteWorld < World
  # Gets a tile from the tiles array at a specified location.
  def get_tile(x : Int32, y : Int32) : Tile
    last_tile = Tile.new
    i = 0
    while(i < passes.size)
      new_tile = passes[i].get_tile(last_tile, x, y)
      i += 1
      last_tile.type = (new_tile.type ? new_tile.type : last_tile.type)
      last_tile.color = (new_tile.color ? new_tile.color : last_tile.color)
      last_tile.rotation = (new_tile.rotation ? new_tile.rotation : last_tile.rotation)
    end
    last_tile
  end
  
  # Gets a block from the blocks array at a specified location.
  def get_block(x : Int32, y : Int32, z : Int32) : Block
    i = 0
    last_block = Block.new
    while(i < passes.size)
      new_block = passes[i].get_block(last_block, x, y, z)
      i += 1
      last_block.type = (new_block.type ? new_block.type : last_block.type)
      last_block.color = (new_block.color ? new_block.color : last_block.color)
      last_block.rotation = (new_block.rotation ? new_block.rotation : last_block.rotation)
    end 
    last_block
  end

  def make_pass(pass, *args)
    if pass.is_a?(typeof(InfinitePass))
      super pass, *args
    else
      raise Exception.new("CANNOT ADD A FINITEPASS TO AN INFINITE WORLD #{pass}")
    end
  end
end