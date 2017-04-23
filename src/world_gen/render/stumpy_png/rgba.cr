struct StumpyCore::RGBA
  def self.from_hex9(string : String)
    r = string[1..2].to_u8(16)
    g = string[3..4].to_u8(16)
    b = string[5..6].to_u8(16)
    a = string[7..8].to_u8(16)
          
    StumpyCore::RGBA.from_rgba8(r, g, b, a)
  end
end