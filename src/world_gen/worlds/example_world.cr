require "../data/world"
require "../render/stumpy_png/png_world"
require "../passes/solid_on"
require "../passes/debug/debug_color"

class ExampleWorld < InfiniteWorld
  include PNGRender

  def initialize(x_range, y_range, z_range)
    super x_range, y_rage, z_range
    assets.open_content "../../../content/test_basic"
  end

  def make_passes
    make_pass SolidOn
    make_pass DebugColor
  end
end