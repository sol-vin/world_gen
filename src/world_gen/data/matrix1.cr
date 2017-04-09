class Matrix1(T)
  include Enumerable(T)

  getter size : Int32

  getter buffer : Slice(T)
  
  def initialize(@size : Int32, &block)
    @buffer = Slice(T).new(size) {yield}
  end

  def [](x)
    raise IndexError.new unless check_bounds(x)
    @buffer[x]
  end
  
  def []=(x, value : T)
    raise IndexError.new unless check_bounds(x)  
    @buffer[x] = value
  end

  def each
    size.times do |item|
      yield @buffer[item]
    end
  end

  def check_bounds(x : Int32) : Bool
    !(x < 0 || x >= size)
  end
end