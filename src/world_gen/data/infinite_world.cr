require "./world"

abstract class InfiniteWorld < World
  # Gets a tile from the tiles array at a specified location.
  def get_tile(x : Int32, y : Int32) : Tile
    tile = nil
    passes.each do |pass|
      tile = pass.get_tile(tile, x, y)
    end
    tile
  end
  
  # Gets a block from the blocks array at a specified location.
  def get_block(x : Int32, y : Int32, z : Int32) : Block
    block = nil
    passes.each do |pass|
      tile = pass.get_tile(block, x, y, z)
    end  
    block
  end

  def make_pass(pass, *args)
    if pass.is_a?(InfinitePass)
      make_pass pass, *args
    else
      raise Exeption.new("CANNOT ADD A FINITEPASS TO AN INFINITE WORLD")
    end
  end
end