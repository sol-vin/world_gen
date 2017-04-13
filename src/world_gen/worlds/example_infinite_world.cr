require "../data/infinite_world"
require "../data/pass"
require "../render/stumpy_png/png_render"
require "../passes/solid_on"
require "../passes/debug/debug_color"

class ExampleInfiniteWorld < InfiniteWorld
  include PNGRender

  def initialize(x_range, y_range, z_range)
    super x_range, y_range, z_range
    assets.open_content "./content/test_basic/"
  end

  protected def make_passes
    make_pass SolidOn   
    make_pass DebugColor
  end
end