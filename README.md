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

### InfiniteWorld and FiniteWorld
There are two types of worlds available to you, InfiniteWorld and FiniteWorld. InfiniteWorld is a world type where blocks can have no knowledge of it's neighbors (while this isn't entirely true, it's the standard you should hold for yourself when making InfiniteWorlds as accessing neighbors can cause infinite recursion.). FiniteWorlds are built with a backing 3D array of blocks, allowing you to get blocks from the set you are generating.

### Passes
Along with the two types of worlds, there are two types of Passes, InfinitePass and FinitePass. A FiniteWorld can use both InfinitePass and FinitePass where as an InfiniteWorld can only use an InfinitePass. Passes are used to describe how blocks are generated, and contain methods that are overridable or changable. 

#### Adding passes

The Class way.

```crystal
require "../data/infinite_world"
require "../data/pass"
require "../passes/solid_on"
require "../passes/debug/debug_color"

class ExampleInfiniteWorld < InfiniteWorld
  def initialize(x_range, y_range, z_range)
    super x_range, y_range, z_range
    assets.open_content "./content/test_basic/"
  end

  # override this in your World class to layer the passes you want.
  protected def make_passes
    make_pass SolidOn   
    make_pass DebugColor
  end
end
```

The Proc way

```crystal
require "../data/infinite_world"
require "../data/proc_pass"
require "../passes/solid_on"
require "../passes/debug/debug_color"

class ExampleInfiniteWorld < InfiniteWorld
  def initialize(x_range, y_range, z_range)
    super x_range, y_range, z_range
    assets.open_content "./content/test_basic/"
  end

  # override this in your World class to layer the passes you want.
  protected def make_passes
    pass = ProcPass.new
    pass.define_tile(:type) do |world, last_tile, x, y|
      "tile"
    end   

    pass.define_block(:type) do |world, last_tile, x, y, z|
      "block"
    end
    passes << pass

    make_pass DebugColor
  end
end
```

#### Making your own passes
Either override the methods get_tile_* and get_block_* after inheriting a pass or use  a ProcPass to inline define during make_passes.

```crystal
require "../../data/pass"

class SolidOn < InfinitePass
  property block_type : String = "block"
  property tile_type : String = "tile"

  def get_block_type(last_block : Block, x : Int32, y : Int32, z : Int32) : String?
    block_type
  end

  def get_tile_type(last_tile : Tile, x : Int32, y : Int32, z : Int32) : String?
    tile_type
  end
end


###Rendering
Currently there is only one renderer, which renders the world in an isometric format to a PNG. However, there is full support for adding different kinds of renderers in the form of modules. 

```crystal
require "../data/infinite_world"
require "../data/pass"
require "../render/stumpy_png/png_render"
require "../passes/solid_on"
require "../passes/debug/debug_color"

class ExampleInfiniteWorld < InfiniteWorld
  include PNGRender
  def initialize(x_range, y_range, z_range)
    super x_range, y_range, z_range
    assets.open_content "./content/test_basic/"
  end

  # override this in your World class to layer the passes you want.
  protected def make_passes
    make_pass SolidOn   
    make_pass DebugColor
  end
end
```

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
