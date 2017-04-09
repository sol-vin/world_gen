# world_gen

A layered logic world generation library. You layer on passes of logic that change the landscape however you want.

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  world_gen:
    github: redcodefinal/world_gen
```


## Usage

```crystal
require "world_gen"

class ExampleWorld < World
  include PNGRender # Include to allow your world to be draw isometrically to a png
  
  getter assets : PNGAssets # Needed to hold the PNG assets

  def initialize(asset_directory : String, @x_range, @y_range, @z_range)
    @assets =  PNGAssets.new asset_directory
    super(x_range, y_range, z_range)
  end

  def make_passes
    make_pass SolidOn    # Tells every block to be on always
    make_pass DebugColor # Tells every block what color it will be.
  end
end

ExampleWorld.new("./content/test_basic", (0..10),(0..10),(0..10)).draw_world # Draws to a PNG
```

Should produce this

![test_world](http://i.imgur.com/jLC0oMm.png)

## Development

Open a pull request you nerd.

## Contributing

1. Fork it ( https://github.com/redcodefinal/world_gen/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [redcodefinal](https://github.com/redcodefinal) Ian Rash - creator, maintainer
