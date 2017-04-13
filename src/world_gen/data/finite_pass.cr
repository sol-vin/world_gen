require "./pass"

class FinitePass < Pass
  getter world : FiniteWorld

  def initialize(@world, *args)
    super *args
  end
end