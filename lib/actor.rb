module Actor
  class Base
    attr_reader   :width, :height, :window
    attr_accessor :x, :y, :velocity, :speed, :opts

    def initialize(window, x, y, width, height, speed = 3, velocity = 1, **opts)
      @x = x
      @y = y
      @window = window
      @width = width
      @height = height
      @velocity = velocity
      @speed = speed

      @opts = opts || {}
    end
  end
end
