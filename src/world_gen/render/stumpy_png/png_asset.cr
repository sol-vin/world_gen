require "stumpy_core"
require "stumpy_png"
require "yaml"

require "../../data/asset"

class PNGAsset < Asset(StumpyCore::Canvas)
  getter config : YAML::Any
  
  def initialize(asset_path)
    super asset_path
    @config = YAML.parse(File.read(asset_path + "_config.yml"))
  end
  
  def load_asset(asset_path) : StumpyCore::Canvas
    #TODO: add checks for PNG! Not a png file error is because of this!
    StumpyPNG.read(asset_path)
  end
end