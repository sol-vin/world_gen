abstract struct Data
  property type : String?
  getter tags = {} of Symbol => String

  def []=(key, value)
    @tags[key] = value
  end

  def [](key)
    @tags[key]
  end

  def []?(key)
    @tags[key]?
  end
end

struct Tile < Data
end

struct Block < Data
end
