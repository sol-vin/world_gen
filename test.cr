require "./src/world_gen/worlds/*"


e_w = ExampleInfiniteWorld.new((0..10), (0..10), (0..10))
e_w.draw_world "world.png"
