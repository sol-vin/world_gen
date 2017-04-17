require "./world"

abstract class FiniteWorld < World
  # A Matrix3 of the blocks in this world
  getter blocks : Matrix3(Block)

  # A Matrix2 of the tiles of this world
  getter tiles : Matrix2(Tile)

  # Blocks modified in this pass, that have yet to be commited to ```blocks```
  getter block_canvas : Matrix3(Block?)

  # Tiles modified in this pass, that have yet to be commited to ```tiles```  
  getter tile_canvas : Matrix2(Tile?)
  
  def initialize(x_range, y_range, z_range)
    @tiles = clear_tiles
    @blocks = clear_blocks
    @tile_canvas = clear_tile_canvas
    @block_canvas = clear_block_canvas

    super

    make_world
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

  def map_tiles(&block) : Nil
    x_range.each do |x|
      y_range.each do |y|
        tiles[x, y] = yield tiles[x, y], x, y
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

  # Gets a block from the blocks array at a specified location.
  def get_block(x : Int32, y : Int32, z : Int32) : Block
    blocks[x - x_range.begin, y - y_range.begin, z - z_range.begin]
  end

  # Sets a block from the blocks array at a specified location.
  def set_block(x : Int32, y : Int32, z : Int32, block : Block) : Nil
    block_canvas[x - x_range.begin, y - y_range.begin, z - z_range.begin] = block
  end

  # Gets a tile from the tiles array at a specified location.
  def get_tile(x : Int32, y : Int32) : Tile
    @tiles[x - x_range.begin, y - y_range.begin]
  end

  # Sets a tile from the tiles array at a specified location.
  def set_tile(x : Int32, y : Int32, tile : Tile) : Nil 
    tile_canvas[x - x_range.begin, y - y_range.begin] = tile
  end

  def find_block_neighbors(x : Int32, y : Int32, z : Int32)
    #TODO:  Write this
  end

  def find_tile_neighbors(x : Int32, y : Int32)
    #TODO:  Write this  
  end

  # Generates the world
  def make_world : Nil
    passes.each do |pass|
      each_tile do |tile, x, y|
        set_tile x, y, pass.get_tile(tile, x, y)      
      end

      each_block do |block, x, y, z|
        set_block x, y, z, pass.get_block(block, x, y, z)
      end
      merge_canvases
    end
  end
end