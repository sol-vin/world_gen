class SineWave < Pass
  def get_block_type(x, y, z)
    two_pi = 2 * 3.141592
    height = (Math.sin(two_pi * (x - world.x_range.begin)/world.x_range.size * 4.0)) * (world.z_range.size/3.0) + (world.z_range.size/3.0)

    if z < height
      "block"
    else
      nil
    end
  end
end