require "../data/world"
require "../render/stumpy_png/png_world"
require "../passes/solid_on"
require "../passes/debug/debug_color"

class ExampleWorld < PNGWorld
  def make_passes
    make_pass SolidOn
    make_pass DebugColor
  end
end