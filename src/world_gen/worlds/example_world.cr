require "../data/world"
require "../render/stumpy_png/*"
require "../passes/solid_on"
require "../passes/debug_color"

class ExampleWorld < World
  include PNGRender
  
  getter assets : PNGAssets

  def initialize(asset_directory : String, @x_range, @y_range, @z_range)
    @assets = PNGAssets.new asset_directory
    super(x_range, y_range, z_range)
  end

  def make_passes
    make_pass SolidOn
    make_pass DebugColor
  end
end