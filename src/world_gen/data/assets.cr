require "./asset"

class Assets(T)
  getter blocks : Hash(String, T)
  getter tiles : Hash(String, T)
  
  def initialize
    @blocks = {} of String => T
    @tiles = {} of String => T
  end

  def open_content(asset_directory : String) : Nil
    #Go through each type, the key is the folder, the value is the Hash of Assets
    if asset_directory[-1] != '/'
      asset_directory += '/'
    end

    types = {"tiles/" => tiles, "blocks/" => blocks}
    types.each do |type_dir, type_collection|
      Dir.entries(asset_directory + type_dir).each do |asset_name|
        #Skip files that start with a dot. (., .., .*) you can name files to be avoided this way
        next if asset_name.chars.first == '.'
        #Skip "hidden" files without using .
        next if asset_name.chars.first == '_'
        asset_path = asset_directory + type_dir + asset_name + '/'
        next unless Dir.exists?(asset_path)

        type_collection[asset_name] = T.new(asset_path)
        added_asset(asset_name, type_collection[asset_name], type_dir.gsub('/', ""))
      end
    end
  end

  protected def added_asset(name : String, asset : T, type : String)
  end
end