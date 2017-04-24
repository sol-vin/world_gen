require "../data/world"
require "../render/stumpy_png/png_render"

class ExampleInfiniteWorld < World
  include PNGRender
  
  def initialize(x_range, y_range, z_range)
    super x_range, y_range, z_range
    assets.open_content "./content/test_basic/"
  end
  
  protected def make_passes
    #make_pass SolidOn, block_type: "block", tile_type: "tile"
    #make_pass DebugColor
    pass = Pass.new
    passes << pass

    pass.define_block(:type) {|_, _, _, _| "block"}
    pass.define_block(:color) do |_, x, y, z|
      r = (UInt8::MAX * (x.to_f/x_range.size)).to_u8
      g = (UInt8::MAX * (y.to_f/y_range.size)).to_u8
      b = (UInt8::MAX * (z.to_f/z_range.size)).to_u8
      a = UInt8::MAX

      r_s = r.to_s(16)
      g_s = g.to_s(16)
      b_s = b.to_s(16)
      a_s = a.to_s(16)

      if r_s.size == 1
        r_s = r_s.insert(0, "0") 
      end

      if g_s.size == 1
        g_s = g_s.insert(0, "0") 
      end

      if b_s.size == 1
        b_s = b_s.insert(0, "0") 
      end

      if a_s.size == 1
        a_s = a_s.insert(0, "0") 
      end
      "#{r_s}#{g_s}#{b_s}#{a_s}"
    end
  end
end