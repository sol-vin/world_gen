require "./pass"
require "./data"

#Class to make an isometric world.
abstract class World
  # The possible rotations of a block
  ROTATIONS = {
    "deg_0" => "deg_90",
    "deg_90" => "deg_180",
    "deg_180" => "deg_270",
    "deg_270" => "deg_0"}
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
  def get_tiles(x : Int32, y : Int32) : Array(Tile)
    last_tiles = [] of Tile
    passes.each do |pass|
      last_tiles = pass.get_tiles(last_tiles, x, y)
    end
    last_tiles
  end
  
  # Gets a block from the blocks array at a specified location.
  def get_blocks(x : Int32, y : Int32, z : Int32) : Array(Block)
    last_blocks = [] of Block
    passes.each do |pass|
      last_blocks = pass.get_blocks(last_blocks, x, y, z)
    end
    last_blocks
  end
end