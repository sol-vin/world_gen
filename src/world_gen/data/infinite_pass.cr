require "./pass"

class InfinitePass < Pass
  getter world : World

  def initialize(@world, *args)
    super *args
  end
end