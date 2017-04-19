require "../../data/pass"

class SquareWave < InfinitePass
  getter axis : Symbol
  getter wave_length : UInt32 = 10

  # TODO: Add controls for phase
  def initialize(world, @axis = :x)
    super world
  end
   
  
  def get_block_type(last_block : Block, x, y, z)
    if axis == :x
      if x % wave_length*2 < wave_length && (z - wolrd.z_range.begin) < world.z_range.size
        "block"
      else
        nil
      end
    elsif axis == :y
      if y % wave_length*2 < wave_length && (z - wolrd.z_range.begin) < world.z_range.size
        "block"
      else
        nil
      end
    elsif axis = :xy
      if x % wave_length*2 < wave_length && y % wave_length*2 < wave_length && (z - wolrd.z_range.begin) < world.z_range.size
        "block"
      else
        nil
      end
    end 
  end
end