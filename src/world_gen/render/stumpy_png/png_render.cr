require "stumpy_png"
require "./color"

module PNGRender
  # Gets the real position of a tile, where it should be drawn at.
  def get_tile_position(x : Int32, y : Int32) : Vector2
    spacing = Vector2.new((@assets.tile_width/2.0).round.to_i32, 
                          (@assets.tile_height/2.0).round.to_i32)
    min_position_x = ((x_range.size * spacing.x) + x_range.size).abs
    min_position_y = ((@assets.block_height / 2.0).round.to_i32 * (z_range.size + 1)).abs
    Vector2.new((-x * spacing.x) + (y * spacing.x) - y + x + min_position_x,
                (x * spacing.y) + (y * spacing.y) - y - x + min_position_y) 
  end
  
  # Gets the position of a block, where it should be drawn at.
  def get_block_position(x : Int32, y : Int32, z : Int32) : Vector2
    position = get_tile_position(x, y)
    #TODO: Fix this! Needs to move the block up z by aligning the bottom of the top block with the top
    #      of the bottom block, then subtract one tile height
    position.y -= (@assets.block_height / 2.0).round.to_i32 * (z + 1)
    position
  end

  def calculate_image_bounds 
    {
      :width => get_tile_position(0, y_range.size).x + @assets.tile_width,
      :height => get_tile_position(x_range.size, y_range.size).y + @assets.tile_height
    }
  end

  def draw_tile(canvas : StumpyCore::Canvas, tile : Tile, position : Vector2)
    unless tile.type.nil?
      unless tile.color.nil?
        asset = @assets.blocks[tile.type]["base"].map {|p, x, y| p.multiply(tile.color.as(Color).to_scrgba)}
      else
        asset = @assets.blocks[tile.type]["base"]
      end
      canvas.paste(asset, position.x, position.y)
    end
  end

  def draw_block(canvas : StumpyCore::Canvas, block : Block, position : Vector2)
    unless block.type.nil?
      unless block.color.nil?
        asset = @assets.blocks[block.type]["base"].map {|p, x, y| p.multiply(block.color.as(Color).to_scrgba)}
      else
        asset = @assets.blocks[block.type]["base"]
      end
      canvas.paste(asset, position.x, position.y)
    end
  end

  def draw_tiles(canvas : StumpyCore::Canvas)
    case view
      when :south_east
        y_range.each do |y|
          x_range.each do |x|
            tile = get_tile(x,y)
            position = get_tile_position(x - x_range.begin, y - y_range.begin)
            draw_tile(canvas, tile, position)
          end
        end
      when :south_west
        x_range.each do |y|
          y_range.each do |x|
            tile = get_tile(x_range.size - 1 - y, x)
            position = get_tile_position(x - x_range.begin, y - y_range.begin)
            draw_tile(canvas, tile, position)
          end
        end
      when :north_west
        y_range.each do |y|
          x_range.each do |x|
            tile = get_tile(x_range.size - 1 - x, y_range.size - 1 - y)
            position = get_tile_position(x - x_range.begin, y - y_range.begin)
            draw_tile(canvas, tile, position)
          end
        end
      when :north_east
        x_range.each do |y|
          y_range.each do |x|
            tile = get_tile(y, y_range.size - 1 - x)
            position = get_tile_position(x - x_range.begin, y - y_range.begin)
            draw_tile(canvas, tile, position)
          end
        end
      else
        raise Exception.new("view was wrong")  
    end
  end

  def draw_blocks(canvas : StumpyCore::Canvas)
    case view
      when :south_east
        y_range.each do |y|
          x_range.each do |x|
            z_range.each do |z|
              block = get_block(x, y, z)
              position = get_block_position(x - x_range.begin, y - y_range.begin, z - z_range.begin)
              draw_block(canvas, block, position)
            end
          end
        end
      when :south_west
        x_range.each do |y|
          y_range.each do |x|
            z_range.each do |z|
              block = get_block(x_range.size - 1 - y, x, z)
              position = get_block_position(x - x_range.begin, y - y_range.begin, z - z_range.begin)
              draw_block(canvas, block, position)
            end
          end
        end
      when :north_west
        y_range.each do |y|
          x_range.each do |x|
            z_range.each do |z|
              block = get_block(x_range.size - 1 - x, x_range.size - 1 - y, z)
              position = get_block_position(x - x_range.begin, y - y_range.begin, z - z_range.begin)
              draw_block(canvas, block, position)
            end
          end
        end
      when :north_east
        x_range.each do |y|
          y_range.each do |x|
            z_range.each do |z|
              block = get_block(y, x_range.size - 1 - x, z)
              position = get_block_position(x - x_range.begin, y - y_range.begin, z - z_range.begin)
              draw_block(canvas, block, position)
            end
          end
        end
      else
        raise Exception.new("view was wrong") 
    end
  end

  def draw_world
    make_world
    #TODO:  Write 
    image_bounds = calculate_image_bounds
    # TODO: ZOOM
    #   To zoom, use stumpy_png to zoom the canvas perfectly using the magnification provided.
    canvas = StumpyPNG::Canvas.new(image_bounds[:width], image_bounds[:height])

    draw_tiles(canvas)
    draw_blocks(canvas)
    StumpyPNG.write(canvas, "world.png")
  end
end
