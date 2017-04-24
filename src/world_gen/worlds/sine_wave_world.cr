require "../data/world"
require "../render/stumpy_png/png_render"

class SineWaveWorld < World
  include PNGRender

  TWO_PI = 2 * 3.141592
  
  def initialize(x_range, y_range, z_range, @axis = :xy)
    super x_range, y_range, z_range
    assets.open_content "./content/tall_block/"
  end

  def get_height(n : Int32, n_range : Range(Int32, Int32), max_height : Int32)
    # Still dont know why 4.0 and 2.0 work right here?
    Math.sin(TWO_PI * (n - n_range.begin)/n_range.size * 4.0) * max_height/2.0 + max_height/2.0
  end
  
  protected def make_passes
    #make_pass SolidOn, block_type: "block", tile_type: "tile"
    #make_pass DebugColor
    pass = Pass.new
    passes << pass

    pass.define_block(:type) do |_, x, y, z|
      height = 0
      if @axis == :x
        height = get_height(x, x_range, z_range.size)
      elsif @axis == :y
        height = get_height(y, y_range, z_range.size)      
      elsif @axis == :xy
        x_height = get_height(x, x_range, z_range.size)
        y_height = get_height(y, y_range, z_range.size)

        max = [x_height, y_height].max
        min = [x_height, y_height].min

        height = ((max - min)/2.0 + min).to_i32
      end

      if z < height
        "block"
      else
        nil
      end
    end

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