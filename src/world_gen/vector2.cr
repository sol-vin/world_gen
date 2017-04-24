struct Vector2
  def self.one
    Vector2.new(1, 1)
  end
  
  def self.zero
    Vector2.new(0, 0)
  end

  property x, y

  def initialize(@x : Int32, @y : Int32)
  end

  def +(other : Vector2)
    Vector2.new(x + other.x, y + other.y)
  end
  
  def +(other : Int32)
    Vector2.new(x + other, y + other)
  end

  def -(other : Vector2)
    Vector2.new(x - other.x, y - other.y)
  end

  def -(other : Int32)
    Vector2.new(x - other, y - other)
  end

  def *(other : Vector2)
    Vector2.new(x * other.x, y * other.y)
  end

  def *(other : Int32)
    Vector2.new(x * other, y * other)
  end

  def /(other : Vector2)
    Vector2.new(x / other.x, y / other.y)
  end

  def /(other : Int32)
    Vector2.new(x / other, y / other)
  end

  def ==(other : Vector2)
    x == other.x && y == other.y
  end
end


