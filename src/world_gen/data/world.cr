require "./*"

#Class to make an isometric world.
abstract class World
  # The different faces of a block
  DIRECTIONS = [:north, :south, :east, :west]

  # The different camera rotations. 
  VIEWS = {:north_west => :south_west, :north_east => :north_west, :south_east => :north_east, :south_west => :south_east}

  # The possible rotations of a block
  ROTATIONS = [:deg0, :deg90, :deg180, :deg270]

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

  # Which direction the camera is facing currently
  getter view : Symbol = VIEWS.values.last

  # The assets for this world
  #getter assets : T

  # The X range of the world.
  getter x_range : Range(Int32, Int32)

  # The Y range of the world.
  getter y_range : Range(Int32, Int32)

  # The Z range of the world.
  getter z_range : Range(Int32, Int32)

  # The passes used to construct the world
  getter passes : Array(Pass)
  
  # A Matrix3 of the blocks in this world
  getter blocks : Matrix3(Block)

  # A Matrix2 of the tiles of this world
  getter tiles : Matrix2(Tile)

  # Blocks modified in this pass, that have yet to be commited to ```blocks```
  getter block_canvas : Matrix3(Block?)

  # Tiles modified in this pass, that have yet to be commited to ```tiles```  
  getter tile_canvas : Matrix2(Tile?)

  def initialize(@x_range : Range(Int32, Int32), @y_range : Range(Int32, Int32), @z_range : Range(Int32, Int32))
    @passes = clear_passes
    @tiles = clear_tiles
    @blocks = clear_blocks
    @tile_canvas = clear_tile_canvas
    @block_canvas = clear_block_canvas

    make_passes
  end

  # Rotates the view counter clockwise
  def rotate_counter_clockwise
    @view = VIEWS[view]
  end

  # Rotates the view clockwise
  def rotate_clockwise : Nil
    @view = Views.invert[view] 
  end

  # Clears the pass list
  def clear_passes : Array(Pass)
    [] of Pass
  end

  # Clears the tiles
  def clear_tiles : Matrix2(Tile)
    Matrix2(Tile).new(x_range.size, y_range.size) {Tile.new}
  end

  # Clears the tile canvas
  def clear_tile_canvas : Matrix2(Tile?)
    Matrix2(Tile?).new(x_range.size, y_range.size) {nil.as(Tile?)}
  end

  # Clears the blocks
  def clear_blocks : Matrix3(Block)
    Matrix3(Block).new(x_range.size, y_range.size, z_range.size) {Block.new}
  end

  # Clears the block canvas
  def clear_block_canvas : Matrix3(Block?)
    Matrix3(Block?).new(x_range.size, y_range.size, z_range.size) {nil.as(Block?)}
  end
  
  abstract def make_passes

  def make_pass(pass : typeof(Pass), *args)
    passes << pass.new(self, *args)
  end

  # Merges the block_canvas with blocks, and the tile_canvas with tiles
  def merge_canvases : Nil
    x_range.size.times do |x|
      y_range.size.times do |y|
        tile = tile_canvas[x, y]
        unless tile.nil?
          tiles[x, y].type = tile.type unless tile.type.nil?
          tiles[x, y].rotation = tile.rotation unless tile.rotation.nil?
          tiles[x, y].color = tile.color unless tile.color.nil?
        end
      end
    end

    x_range.size.times do |x|
      y_range.size.times do |y|
        z_range.size.times do |z|
          block = block_canvas[x, y, z]
          unless block.nil?
            blocks[x, y, z].type = block.type unless block.type.nil?
            blocks[x, y, z].rotation = block.rotation unless block.rotation.nil?
            blocks[x, y, z].color = block.color unless block.color.nil?
          end
        end
      end
    end
  end

  # Gets a block from the blocks array at a specified location.
  def get_block(x : Int32, y : Int32, z : Int32) : Block
    blocks[x - x_range.begin, y - y_range.begin, z - z_range.begin]
  end

  # Sets a block from the blocks array at a specified location.
  def set_block(x : Int32, y : Int32, z : Int32, block : Block) : Nil
    block_canvas[x - x_range.begin, y - y_range.begin, z - z_range.begin] = block
  end

  # Returns all the number combinations (x, y, z) for every block.
  def each_block(&block) : Nil
    x_range.each do |x|
      y_range.each do |y|
        z_range.each do |z|
          yield x, y, z
        end
      end
    end
  end

  def map_blocks(&block) : Nil
    x_range.size.times do |x|
      y_range.size.times do |y|
        z_range.size.times do |z|
          blocks[x, y, z] = yield blocks[x, y, z], x, y, z
        end
      end
    end
  end

  # Gets a tile from the tiles array at a specified location.
  def get_tile(x : Int32, y : Int32) : Tile
    @tiles[x - x_range.begin, y - y_range.begin]
  end

  # Sets a tile from the tiles array at a specified location.
  def set_tile(x : Int32, y : Int32, tile : Tile) : Nil 
    tile_canvas[x - x_range.begin, y - y_range.begin] = tile
  end

  # Returns all the number combinations (x, y) for every tile.
  def each_tile(&block) : Nil
    x_range.each do |x|
      y_range.each do |y|
        yield x, y
      end
    end
  end

  def map_tiles(&block) : Nil
    x_range.each do |x|
      y_range.each do |y|
        tiles[x, y] = yield tiles[x, y], x, y
      end
    end
  end

  # Runs a pass on the world
  def run_pass(pass : Pass) : Nil
    each_block do |x, y, z|
      set_tile x, y, pass.get_tile(x, y)
      set_block x, y, z, pass.get_block(x, y, z)
    end
  end

  # Generates the world
  def make_world : Nil
    passes.each do |op|
      run_pass op
      merge_canvases
    end
  end

  def find_block_neighbors(x : Int32, y : Int32, z : Int32)
    #TODO:  Write this
  end

  def find_tile_neighbors(x : Int32, y : Int32)
    #TODO:  Write this  
  end
end
