class DebugColor < Pass
  def get_tile_color(x, y)
    r = (UInt8::MAX * (x.to_f/world.x_range.size)).to_u8
    b = (UInt8::MAX * (y.to_f/world.y_range.size)).to_u8

    Color.new(r, 0_u8, b, UInt8::MAX)
  end

  def get_block_color(x, y, z)
    r = (UInt8::MAX * (x.to_f/world.x_range.size)).to_u8
    g = (UInt8::MAX * (y.to_f/world.y_range.size)).to_u8
    b = (UInt8::MAX * (z.to_f/world.y_range.size)).to_u8
    Color.new(r, g, b, UInt8::MAX)
  end
end