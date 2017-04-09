class Matrix3(T)
  include Enumerable(T)
  getter size_x : Int32
  getter size_y : Int32
  getter size_z : Int32

  getter buffer : Slice(T)
  
  def initialize(@size_x : Int32, @size_y : Int32, @size_z : Int32)
    @buffer = Slice(T).new(size_x * size_y * size_z) {yield}
  end

  def [](x, y, z)
    raise IndexError.new unless check_bounds(x, y, z)
    @buffer[@size_x *  @size_y * z + @size_x * y + x]
  end
  
  def []=(x, y, z, value : T)
    raise IndexError.new unless check_bounds(x, y, z)  
    @buffer[@size_x *  @size_y * z + @size_x * y + x] = value
  end

  def each
    size_x.times do |x|
      size_y.times do |y|
        size_z.times do |z|
          yield @buffer[x, y, z]
        end
      end
    end
  end

  def check_bounds(x : Int32, y : Int32, z : Int32) : Bool
    !(x < 0 || x >= size_x || y < 0 || y >= size_y || z < 0 || z >= size_z)
  end
end