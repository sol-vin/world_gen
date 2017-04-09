require "../data/world"
require "../render/stumpy_png/*"
require "../passes/sine_wave"
require "../passes/debug_color"

class ExampleWorld < World
  include PNGRender
  
  getter assets : PNGAssets

  def initialize(asset_directory : String, @x_range, @y_range, @z_range)
    @assets = make_assets(asset_directory)
    super(x_range, y_range, z_range)
  end

  def make_passes
    make_pass SineWave
    make_pass DebugColor
  end

  def make_assets(asset_directory) : PNGAssets
    PNGAssets.new asset_directory
  end
end