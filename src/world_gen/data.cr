abstract struct Data
  property type : String?
  property rotation : String?
  property color : String?
  property flip_h : String?

  def initialize(@type = nil, @rotation = nil, @color = nil)
  end

  def all_nil?
    type.nil? && rotation.nil? && color.nil?
  end

  def any_nil?
    type.nil? || rotation.nil? || color.nil?
  end
end

struct Tile < Data
end

struct Block < Data
end
