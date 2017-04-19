require "stumpy_core"
require "stumpy_png"

struct Color
  def to_scrgba : StumpyCore::RGBA
    StumpyCore::RGBA.from_rgba8(r, g, b, a)
  end
end