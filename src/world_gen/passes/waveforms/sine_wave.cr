require "../../data/pass"

class SineWave < InfinitePass
  TWO_PI = 2 * 3.141592
  getter axis : Symbol
  property block_type : String = "block"

  def initialize(world, @axis = :x)
    super world
  end
   
  # TODO: Add controls for length and phase
  def get_block_type(block, x, y, z)
    height = 0
    if axis == :x
      height = get_height(x, world.x_range, world.z_range.size)
    elsif axis == :y
      height = get_height(y, world.y_range, world.z_range.size)      
    elsif axis == :xy
      x_height = get_height(x, world.x_range, world.z_range.size)
      y_height = get_height(y, world.y_range, world.z_range.size)

      max = [x_height, y_height].max
      min = [x_height, y_height].min

      height = ((max - min)/2.0 + min).to_i32
    end

    if z < height
      block_type
    else
      nil
    end
  end

  def get_height(n : Int32, n_range : Range(Int32, Int32), max_height : Int32)
    # Still dont know why 4.0 and 2.0 work right here?
    Math.sin(TWO_PI * (n - n_range.begin)/n_range.size * 4.0) * max_height/2.0 + max_height/2.0
  end
end