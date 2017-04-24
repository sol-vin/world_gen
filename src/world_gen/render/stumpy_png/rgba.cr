struct StumpyCore::RGBA
  def self.from_hex9(string : String)
    r = string[0..1].to_u8(16)
    g = string[2..3].to_u8(16)
    b = string[4..5].to_u8(16)
    a = string[6..7].to_u8(16)
          
    StumpyCore::RGBA.from_rgba8(r, g, b, a)
  end
end