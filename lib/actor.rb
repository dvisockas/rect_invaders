module Actor
  class Base
    attr_reader   :width, :height, :window
    attr_accessor :x, :y, :velocity, :speed, :opts, :state, :image

    def initialize(window, x, y, width, height, speed = 3, velocity = 1, **opts)
      @x = x
      @y = y
      @window = window
      @width = width
      @height = height
      @velocity = velocity
      @speed = speed
      @image = opts[:image]
      @state = opts[:state]

      @opts = opts || {}
    end

    def image
      case state
      when :alarmed
        window.tilesheet[2]
      else
        @image
      end
    end
  end
end
