class SolidOn < Pass
  property block_type : String = "block"
  property tile_type : String = "tile"

  def get_block_type(x, y, z)
    block_type
  end

  def get_tile_type(x, y, z)
    tile_type
  end
end