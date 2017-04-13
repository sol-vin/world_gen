require "../../data/infinite_pass"

class DebugColor < InfinitePass
  def get_tile_color(tile : Tile, x : Int32, y : Int32) : Color?
    r = (UInt8::MAX * (x.to_f/world.x_range.size)).to_u8
    b = (UInt8::MAX * (y.to_f/world.y_range.size)).to_u8

    Color.new(r, 0_u8, b, UInt8::MAX)
  end

  def get_block_color(block : Block, x : Int32, y : Int32, z : Int32) Color?
    r = (UInt8::MAX * (x.to_f/world.x_range.size)).to_u8
    g = (UInt8::MAX * (y.to_f/world.y_range.size)).to_u8
    b = (UInt8::MAX * (z.to_f/world.y_range.size)).to_u8
    Color.new(r, g, b, UInt8::MAX)
  end
end