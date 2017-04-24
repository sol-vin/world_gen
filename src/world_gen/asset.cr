abstract class Asset(T)
  getter asset_path : String
  getter tags : Hash(String, T)
  
  def initialize(@asset_path : String)
    @tags = {} of String => T
    Dir.entries(asset_path).each do |asset_file|
      next if asset_file.chars.first == '.'
      next if asset_file.chars.first == '_'
      next if Dir.exists?(asset_path + asset_file)
      asset_tag = asset_file.split('.').first

      tags[asset_tag] = load_asset(asset_path + asset_file)
    end
  end
  
  abstract def load_asset(path : String) : T

  def [](tag : String) : T
    tags[tag]
  end
end
