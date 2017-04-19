require "./pass"
require "./tile"
require "./block"

#Class to make an isometric world.
abstract class World
  # The different faces of a block
  DIRECTIONS = [:north, :south, :east, :west]
  
  # The possible rotations of a block
  ROTATIONS = ["deg0", "deg90", "deg180", "deg270"]
  
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
  
  def make_pass(pass : Pass.class, *args)
    passes << pass.new(self, *args)
  end
  
  abstract def get_tile(x : Int32, y : Int32) : Tile
  
  # Returns all the number combinations (x, y) for every tile.
  def each_tile(&block) : Nil
    x_range.each do |x|
      y_range.each do |y|
        yield get_tile(x, y), x, y
      end
    end
  end

  abstract def get_block(x : Int32, y : Int32, z : Int32) : Block
  
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
end