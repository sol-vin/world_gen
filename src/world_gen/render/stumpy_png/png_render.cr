require "stumpy_png"
require "yaml"

require "../../*"

require "./rgba"
require "./canvas"
require "./png_assets"

module PNGRender
  VIEWS = {"north_west" => "south_west", "north_east" => "north_west", "south_east" => "north_east", "south_west" => "south_east"}
  
  getter assets : PNGAssets = PNGAssets.new
  # Which direction the camera is facing currently
  getter view : String = VIEWS.values.last

    # Rotates the view counter clockwise
  def rotate_counter_clockwise
    @view = VIEWS[view]
  end
  
  # Rotates the view clockwise
  def rotate_clockwise
    @view = VIEWS.invert[view] 
  end

  # Gets the position of a tile, where it should be drawn at.
  def get_tile_position(x : Int32, y : Int32) : Vector2
    spacing = Vector2.new((assets.tile_width/2.0).ceil.to_i32, 
                          (assets.tile_height/2.0).ceil.to_i32)
    min_position_x = ((x_range.size * spacing.x) + x_range.size).abs
    min_position_y = ((assets.block_height - assets.tile_height) * (z_range.size)).abs
    Vector2.new((-x * spacing.x) + (y * spacing.x) - y + x + min_position_x - spacing.x,
                (x * spacing.y) + (y * spacing.y) - y - x + min_position_y) 
  end
  
  # Gets the position of a block, where it should be drawn at.
  def get_block_position(x : Int32, y : Int32, z : Int32) : Vector2
    position = get_tile_position(x, y)
    position.y -= (assets.block_height - assets.tile_height) * z 
    position
  end

  def calculate_image_bounds 
    {
      :width => get_tile_position(0, y_range.size).x + assets.tile_width,
      :height => get_tile_position(x_range.size, y_range.size).y + assets.block_height 
    }
  end

  private def get_layer_info(tile : Tile) : YAML::Any?
    if tile.type
      asset = @assets.tiles[tile.type]
      layers = YAML.parse("blank: []")
      if tile.rotation && asset.config["views"][view][tile.rotation.as(String)]?
        layers = asset.config["views"][view][tile.rotation.as(String)]
      elsif asset.config["views"][view]["none"]?
        layers = asset.config["views"][view]["none"]
      else
        raise "asset did not have any configuration for rotation #{tile.type} #{tile.rotation}"
      end
      return layers
    end
  end

  #TODO: Add flip_h
  private def draw_tile_layer(canvas : StumpyCore::Canvas , tile_type : String, tile_color : String?, layer : String, layer_info : YAML::Any, position : Vector2)
    asset = assets.tiles[tile_type][layer]
    if layer_info != "none" && layer_info["color"]?
      color = StumpyCore::RGBA.from_hex9(layer_info["color"].to_s)
      canvas.paste_and_tint(asset, position.x, position.y, color)          
    elsif tile_color
      color = StumpyCore::RGBA.from_hex9(tile_color.as(String))
      canvas.paste_and_tint(asset, position.x, position.y, color)          
    else
      canvas.paste(asset, position.x, position.y)
    end
  end

  def draw_tile(canvas : StumpyCore::Canvas, tile : Tile, position : Vector2)
    if tile.type
      layers = get_layer_info(tile).as(YAML::Any)

      layers.each do |layer_name, layer_info|
        if layer_name.to_s.includes?('.')
          draw_tile_layer(canvas, layer_name.to_s.split('.')[0], tile.color, layer_name.to_s.split('.')[1], layer_info, position)
        else
          draw_tile_layer(canvas, tile.type.as(String), tile.color, layer_name.to_s, layer_info, position)
        end
      end
    end
  end

  private def get_layer_info(block : Block) : YAML::Any?
    if block.type
      asset = @assets.blocks[block.type]
      layers = YAML.parse("blank: []")
      if block.rotation && asset.config["views"][view][block.rotation.as(String)]?
        layers = asset.config["views"][view][block.rotation.as(String)]
      elsif asset.config["views"][view]["none"]?
        layers = asset.config["views"][view]["none"]
      else
        raise "asset did not have any configuration for rotation #{block.type} #{block.rotation}"
      end
      return layers
    end
  end

  private def draw_block_layer(canvas : StumpyCore::Canvas , block_type : String, block_color : String?, layer : String, layer_info : YAML::Any, position : Vector2)
    asset = assets.blocks[block_type][layer]
    if layer_info != "none" && layer_info["color"]?
      color = StumpyCore::RGBA.from_hex9(layer_info["color"].to_s)
      canvas.paste_and_tint(asset, position.x, position.y, color)          
    elsif block_color
      color = StumpyCore::RGBA.from_hex9(block_color.as(String))
      canvas.paste_and_tint(asset, position.x, position.y, color)          
    else
      canvas.paste(asset, position.x, position.y)
    end
  end


  def draw_block(canvas : StumpyCore::Canvas, block : Block, position : Vector2)
    if block.type
      layers = get_layer_info(block).as(YAML::Any)

      layers.each do |layer_name, layer_info|
        if layer_name.to_s.includes?('.')
          draw_block_layer(canvas, layer_name.to_s.split('.')[0], block.color, layer_name.to_s.split('.')[1], layer_info, position)
        else
          draw_block_layer(canvas, block.type.as(String), block.color, layer_name.to_s, layer_info, position)
        end
      end
    end
  end

  def draw_tiles(canvas : StumpyCore::Canvas)
    case view
      when "south_east"
        y_range.each do |y|
          x_range.each do |x|
            tile = get_tile(x,y)
            position = get_tile_position(x - x_range.begin, y - y_range.begin)
            draw_tile(canvas, tile, position)
          end
        end
      when "south_west"
        x_range.each do |y|
          y_range.each do |x|
            tile = get_tile(x_range.size - 1 - y, x)
            position = get_tile_position(x - x_range.begin, y - y_range.begin)
            draw_tile(canvas, tile, position)
          end
        end
      when "north_west"
        y_range.each do |y|
          x_range.each do |x|
            tile = get_tile(x_range.size - 1 - x, y_range.size - 1 - y)
            position = get_tile_position(x - x_range.begin, y - y_range.begin)
            draw_tile(canvas, tile, position)
          end
        end
      when "north_east"
        x_range.each do |y|
          y_range.each do |x|
            tile = get_tile(y, y_range.size - 1 - x)
            position = get_tile_position(x - x_range.begin, y - y_range.begin)
            draw_tile(canvas, tile, position)
          end
        end
      else
        raise "view was wrong"
    end
  end
  
  def draw_blocks(canvas : StumpyCore::Canvas)
    case view
      when "south_east"
        y_range.each do |y|
          x_range.each do |x|
            z_range.each do |z|
              block = get_block(x, y, z)
              position = get_block_position(x - x_range.begin, y - y_range.begin, z - z_range.begin)
              draw_block(canvas, block, position)
            end
          end
        end
      when "south_west"
        x_range.each do |y|
          y_range.each do |x|
            z_range.each do |z|
              block = get_block(x_range.size - 1 - y, x, z)
              position = get_block_position(x - x_range.begin, y - y_range.begin, z - z_range.begin)
              draw_block(canvas, block, position)
            end
          end
        end
      when "north_west"
        y_range.each do |y|
          x_range.each do |x|
            z_range.each do |z|
              block = get_block(x_range.size - 1 - x, x_range.size - 1 - y, z)
              position = get_block_position(x - x_range.begin, y - y_range.begin, z - z_range.begin)
              draw_block(canvas, block, position)
            end
          end
        end
      when "north_east"
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
        raise "view was wrong #{view}"
    end
  end

  def draw_world(filename : String)
    image_bounds = calculate_image_bounds
    # TODO: ZOOM
    #   To zoom, use stumpy_png to zoom the canvas perfectly using the magnification provided.
    canvas = StumpyPNG::Canvas.new(image_bounds[:width], image_bounds[:height])
    
    draw_tiles(canvas)
    draw_blocks(canvas)
    StumpyPNG.write(canvas, filename)
  end
end
