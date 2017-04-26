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
    position.y -= (assets.block_height - assets.tile_height) * (z+1)
    position
  end

  def calculate_image_bounds 
    {
      :width => get_tile_position(0, y_range.size).x + assets.tile_width,
      :height => get_tile_position(x_range.size, y_range.size).y + assets.block_height 
    }
  end
  
  private def get_layer_info(data : Data) : YAML::Any?
    if data.type
      asset = if data.is_a?(Tile) 
                assets.tiles[data.type]
              elsif data.is_a?(Block)
                assets.blocks[data.type]
              else
                raise "data was not Data I guess IDK."
              end
      layers = YAML.parse("blank: []")
      if data[:rotation]? && asset.config["views"][view][data[:rotation].to_s]?
        layers = asset.config["views"][view][data[:rotation].to_s]
      elsif asset.config["views"][view]["none"]?
        layers = asset.config["views"][view]["none"]
      else
        raise "asset did not have any configuration for rotation #{data.type} #{data[:rotation]?}"
      end
      return layers
    end
  end

  private def draw_layer(canvas : StumpyCore::Canvas , data : Data, layer : String, layer_info : YAML::Any, position : Vector2)
    asset = if data.is_a?(Tile) 
              assets.tiles[data.type][layer]
            elsif data.is_a?(Block)
              assets.blocks[data.type][layer]
            else
              raise "data was not Data I guess IDK."
            end
    has_layer_color = layer_info != "none" && layer_info["color"]?
    has_layer_flip_h = layer_info != "none" && layer_info["flip_h"]? == "true"
    has_data_flip_h = data[:flip_h]? == "true"
    flip_h =  has_data_flip_h ^ has_layer_flip_h
    if has_layer_color && (layer_info["color"]? != "none") && !flip_h
      color = StumpyCore::RGBA.from_hex9(layer_info["color"].to_s)
      canvas.paste_and_tint(asset, position.x, position.y, color)
    elsif has_layer_color && (layer_info["color"]? != "none") && flip_h
      color = StumpyCore::RGBA.from_hex9(layer_info["color"].to_s)
      canvas.paste_and_flip_h_and_tint(asset, position.x, position.y, color)     
    elsif has_layer_color && (layer_info["color"]? == "none") && flip_h
      canvas.paste_and_flip_h(asset, position.x, position.y)
    elsif has_layer_color && (layer_info["color"]? == "none") && !flip_h
      canvas.paste(asset, position.x, position.y)
    elsif data[:color]? && !flip_h
      color = StumpyCore::RGBA.from_hex9(data[:color].to_s)
      canvas.paste_and_tint(asset, position.x, position.y, color) 
    elsif data[:color]? && flip_h
      color = StumpyCore::RGBA.from_hex9(data[:color].to_s)
      canvas.paste_and_flip_h_and_tint(asset, position.x, position.y, color)
    elsif flip_h
      canvas.paste_and_flip_h(asset, position.x, position.y)
    else
      canvas.paste(asset, position.x, position.y)
    end
  end


  def draw_data(canvas : StumpyCore::Canvas, data : Data, position : Vector2)
    if data.type
      layers = get_layer_info(data).as(YAML::Any)
      if layers.to_s != "none"
        layers.each do |layer_name, layer_info|
          # if the layer_name contains a . it is most likely 
          # trying to clone another types layer (ex: block.base)
          if layer_name.to_s.includes?('.')
            new_data = data
            new_data.type = layer_name.to_s.split('.')[0]
            draw_layer(canvas, new_data, layer_name.to_s.split('.')[1], layer_info, position)
          else
            draw_layer(canvas, data, layer_name.to_s, layer_info, position)
          end
        end
      end
    end
  end

  def draw_tiles(canvas, x, y)
    tiles = get_tiles(x,y)
    
    position = get_tile_position(x - x_range.begin, y - y_range.begin)
    tiles.each do |tile|
      draw_data(canvas, tile, position)
    end
  end

  def draw_blocks(canvas, x, y, z)
    blocks = get_blocks(x, y, z)
    position = get_block_position(x - x_range.begin, y - y_range.begin, z - z_range.begin)
    blocks.each do |block|
      draw_data(canvas, block, position)
    end
  end

  def draw_all_tiles(canvas : StumpyCore::Canvas)
    case view
      when "south_east"
        y_range.each do |y|
          x_range.each do |x|
            draw_tiles(canvas, x, y)
          end
        end
      when "south_west"
        x_range.each do |y|
          y_range.each do |x|
            draw_tiles(canvas, x_range.size - 1 - y, x)
          end
        end
      when "north_west"
        y_range.each do |y|
          x_range.each do |x|
            draw_tiles(canvas, x_range.size - 1 - x, y_range.size - 1 - y)
          end
        end
      when "north_east"
        x_range.each do |y|
          y_range.each do |x|
            draw_tiles(canvas, y, y_range.size - 1 - x)
          end
        end
      else
        raise "view was wrong"
    end
  end
  
  def draw_all_blocks(canvas : StumpyCore::Canvas)
    case view
      when "south_east"
        y_range.each do |y|
          x_range.each do |x|
            z_range.each do |z|
              draw_blocks(canvas, x, y, z)
            end
          end
        end
      when "south_west"
        x_range.each do |y|
          y_range.each do |x|
            z_range.each do |z|
              draw_blocks(canvas, x_range.size - 1 - y, x, z)
            end
          end
        end
      when "north_west"
        y_range.each do |y|
          x_range.each do |x|
            z_range.each do |z|
              draw_blocks(canvas, x_range.size - 1 - x, x_range.size - 1 - y, z)
            end
          end
        end
      when "north_east"
        x_range.each do |y|
          y_range.each do |x|
            z_range.each do |z|
              draw_blocks(canvas, y, x_range.size - 1 - x, z)
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
    
    draw_all_tiles(canvas)
    draw_all_blocks(canvas)
    StumpyPNG.write(canvas, filename)
  end
end
