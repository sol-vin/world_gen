class SineWave < Pass
  getter axis : Symbol

  def initialize(world, @axis = :x)
    super world
  end
   
  # TODO: Add controls for length
  def get_block_type(x, y, z)
    two_pi = 2 * 3.141592
    if axis == :x
      height = (Math.sin(two_pi * (x - world.x_range.begin)/world.x_range.size * 4.0)) * (world.z_range.size/3.0) + (world.z_range.size/3.0)
    elsif axis == :y
      height = (Math.sin(two_pi * (y - world.y_range.begin)/world.y_range.size * 4.0)) * (world.z_range.size/3.0) + (world.z_range.size/3.0)      
    elsif axis == :xy
      x_height = (Math.sin(two_pi * (x - x_range.begin)/x_range.size * 4.0)) * (z_range.size/3.0) + (z_range.size/3.0)
      y_height = (Math.sin(two_pi * (y - y_range.begin)/y_range.size * 4.0)) * (z_range.size/3.0) + (z_range.size/3.0)

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
end