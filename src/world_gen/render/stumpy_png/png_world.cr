require "./png_assets"
require "./png_render"
require "../../data/world"

class PNGWorld < World
  include PNGRender
  
  getter assets : PNGAssets

  def initialize(asset_directory : String, @x_range, @y_range, @z_range)
    @assets = PNGAssets.new asset_directory
    super(x_range, y_range, z_range)
  end
end