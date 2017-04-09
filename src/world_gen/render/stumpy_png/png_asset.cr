require "stumpy_core"
require "stumpy_png"

require "../../data/asset"

class PNGAsset < Asset(StumpyCore::Canvas)
  def load_asset(asset_path) : StumpyCore::Canvas
    StumpyPNG.read(asset_path)
  end
end