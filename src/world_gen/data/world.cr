require "./pass"
require "./tile"
require "./block"

#Class to make an isometric world.
abstract class World
  # The different faces of a block
  DIRECTIONS = ["north", "south", "east", "west"]
  
  # The possible rotations of a block
  ROTATIONS = ["deg_0", "deg_90", "deg_180", "deg_270"]
  
  # The potential neighbors of a block
  POSSIBLE_BLOCK_NEIGHBORS = {:front => {:x => 0, :y => 1, :z => 0},
                              :left => {:x => 1, :y => 0, :z => 0},
                              :right => {:x => -1, :y => 0, :z => 0},
                              :back => { :x => 0, :y => -1, :z => 0},
                              :top => {:x => 0, :y => 0, :z => -1},
                              :bottom => {:x => 0, :y => 0, :z => 1}}
  # The potential neighbors of a tile
  POSSIBLE_TILE_NEIGHBORS = {:front => {:x => 0, :y => 1},
                             :left => {:x => 1, :y => 0},
                             :right => {:x => -1, :y => 0},
                             :back => { :x => 0, :y => -1}}
  
  # The X range of the world.
  getter x_range : Range(Int32, Int32)
  
  # The Y range of the world.
  getter y_range : Range(Int32, Int32)
  
  # The Z range of the world.
  getter z_range : Range(Int32, Int32)
  
  # The passes used to construct the world
  getter passes : Array(Pass)
  
  
  def initialize(@x_range : Range(Int32, Int32), @y_range : Range(Int32, Int32), @z_range : Range(Int32, Int32))
    @passes = clear_passes

    make_passes
  end
  

  # Clears the pass list
  def clear_passes : Array(Pass)
    [] of Pass
  end
  
  # Weak abstraction for assets
  abstract def assets
  
  # Abstraction for where the user makes the passes they want.
  protected abstract def make_passes
  
  # Returns all the number combinations (x, y) for every tile.
  def each_tile(&block) : Nil
    x_range.each do |x|
      y_range.each do |y|
        yield get_tile(x, y), x, y
      end
    end
  end
  
  # Returns all the number combinations (x, y, z) for every block.
  def each_block(&block) : Nil
    x_range.each do |x|
      y_range.each do |y|
        z_range.each do |z|
          yield get_block(x, y, z), x, y, z
        end
      end
    end
  end

  # Gets a tile from the tiles array at a specified location.
  def get_tile(x : Int32, y : Int32) : Tile
    last_tile = Tile.new
    i = 0
    while(i < passes.size)
      new_tile = passes[i].get_tile(last_tile, x, y)
      i += 1
      if new_tile.type == ":erase:"
        last_tile.type = nil 
      else
        last_tile.type = (new_tile.type ? new_tile.type : last_tile.type) 
      end

      if new_tile.color == ":erase:"
        last_tile.color = nil 
      else
        last_tile.color = (new_tile.color ? new_tile.color : last_tile.color) 
      end

      if new_tile.rotation == ":erase:"
        last_tile.rotation = nil 
      else
        last_tile.rotation = (new_tile.rotation ? new_tile.rotation : last_tile.rotation) 
      end
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
      if new_block.type == ":erase:"
        last_block.type = nil
      else
        last_block.type = (new_block.type ? new_block.type : last_block.type)
      end

      if new_block.color == ":erase:"
        last_block.color = nil
      else
        last_block.color = (new_block.color ? new_block.color : last_block.color)
      end

      if new_block.rotation == ":erase:"
        last_block.rotation = nil
      else
        last_block.rotation = (new_block.rotation ? new_block.rotation : last_block.rotation)
      end
    end 
    last_block
  end
end