abstract struct Data
  property type : String?
  property tags = {} of Symbol => String?

  def []=(key, value)
    @tags[key] = value
  end

  def [](key)
    @tags[key]
  end

  def []?(key)
    @tags[key]?
  end

  def clone : Data
    new_data = self
    new_data.tags = @tags.dup
    new_data
  end
end

struct Tile < Data
end

struct Block < Data
end
