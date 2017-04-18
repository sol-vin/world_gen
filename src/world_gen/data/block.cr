require "./color"

#TODO: Change to struct but first have to fix how set_block works in finite_world.cr
class Block
  property type : String?
  property rotation : String?
  property color : Color?

  def initialize(@type = nil, @rotation = nil, @color = nil)
  end

  def all_nil?
    type.nil? && rotation.nil? && color.nil?
  end

  def any_nil?
    type.nil? || rotation.nil? || color.nil?
  end
end