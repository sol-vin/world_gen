struct Vector3
  def self.one
    Vector3.new(1, 1, 1)
  end

  def self.zero
    Vector3.new(0, 0, 0)
  end

  property x, y, z

  def initialize(@x : Int32, @y : Int32, @z : Int32)
  end

  #TODO: Write macro!

  def +(other : Vector3)
    Vector3.new(x + other.x, y + other.y, z + other.z)
  end

  def +(other : Int32)
    Vector3.new(x + other, y + other, z + other)
  end

  def -(other : Vector3)
    Vector3.new(x - other.x, y - other.y, z - other.z)
  end

  def -(other : Int32)
    Vector3.new(x - other, y - other, z - other)
  end

  def *(other : Vector3)
    Vector3.new(x * other.x, y * other.y, z * other.z)
  end

  def *(other : Int32)
    Vector3.new(x * other, y * other, z * other)
  end

  def /(other : Vector3)
    Vector3.new(x / other.x, y / other.y, z / other.z)
  end

  def /(other : Int32)
    Vector3.new(x / other, y / other, z / other)
  end

  def ==(other : Vector3)
    x == other.x && y == other.y && other.z
  end
end

