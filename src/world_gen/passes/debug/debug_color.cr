require "../../data/pass"

class DebugColor < InfinitePass
  def get_tile_color(tile : Tile, x : Int32, y : Int32) : String?
    r = (UInt8::MAX * (x.to_f/world.x_range.size)).to_u8
    g = (UInt8::MAX * (y.to_f/world.y_range.size)).to_u8
    b = 0
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

    "\##{r_s}#{g_s}#{b_s}#{a_s}"
  end

  def get_block_color(block : Block, x : Int32, y : Int32, z : Int32) String?
    r = (UInt8::MAX * (x.to_f/world.x_range.size)).to_u8
    g = (UInt8::MAX * (y.to_f/world.y_range.size)).to_u8
    b = (UInt8::MAX * (z.to_f/world.z_range.size)).to_u8
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
    puts "#{x} #{y} #{z} \##{r_s}#{g_s}#{b_s}#{a_s}"
    "\##{r_s}#{g_s}#{b_s}#{a_s}"
  end
end