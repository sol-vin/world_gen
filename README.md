# world_gen

A layered logic world generation library. You layer on passes of logic that change the landscape however you want.

![test_world](http://i.imgur.com/jLC0oMm.png)

## Installation


Add this to your application's `shard.yml`:

```yaml
dependencies:
  world_gen:
    github: redcodefinal/world_gen
```


## Usage

### World and FiniteWorld

There are two types of worlds available to you, `World` and `FiniteWorld`. `World` is a world type where blocks can have no knowledge of it's neighbors (while this isn't entirely true, it's the standard you should hold for yourself when making `World`s as accessing neighbors can cause infinite recursion.). `FiniteWorld`s are built with a backing 3D array of blocks, allowing you to get blocks from the set you are generating.

### Passes

Passes are used to describe how blocks are generated, and contain methods that are overridable or changable. 

#### Adding passes

```crystal
require "world_gen"

class ExampleWorld < World
  
  def initialize(x_range, y_range, z_range)
    super x_range, y_range, z_range
    assets.open_content "./content/basic/"
  end
  
  protected def make_passes
    pass = Pass.new
    passes << pass

    pass.define_block(:type) {|_, _, _, _| "block"}
    pass.define_block(:color) do |_, x, y, z|
      r = (UInt8::MAX * (x.to_f/x_range.size)).to_u8
      g = (UInt8::MAX * (y.to_f/y_range.size)).to_u8
      b = (UInt8::MAX * (z.to_f/z_range.size)).to_u8
      a = UInt8::MAX

      r_s = r.to_s(16)
      g_s = g.to_s(16)
      b_s = b.to_s(16)
      a_s = a.to_s(16)

      if r_s.size == 1
        r_s = r_s.insert(0, "0") 
      end

      if g_s.size == 1
        g_s = g_s.insert(0, "0") 
      end

      if b_s.size == 1
        b_s = b_s.insert(0, "0") 
      end

      if a_s.size == 1
        a_s = a_s.insert(0, "0") 
      end
      "#{r_s}#{g_s}#{b_s}#{a_s}"
    end
  end
end
```

### Rendering

Currently there is only one renderer, which renders the world in an isometric format to a PNG. However, there is full support for adding different kinds of renderers in the form of modules. 

```crystal
require "./example_world"
require "world_gen/render/stumpy_png/png_render"

class PNGExampleWorld < ExampleWorld
  include PNGRender
end
```

Then

```crystal
PNGExampleWorld.new((0..10), (0..10), (0..10)).draw_world("world.png")
```

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
