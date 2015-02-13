module Actor
  class Base
    attr_accessor :x, :y, :speed, :opts, :state, :image,
                  :width, :height, :window

    def initialize(window, x, y, width, height, speed = 3, **opts)
      @x = x
      @y = y
      @window = window
      @width = width
      @height = height
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

    def explode
      zone_size = 5

      self.x -= zone_size
      self.y -= zone_size
      self.width += zone_size*2
      self.height += zone_size*2
    end

    def implode
      window.actors.delete(self)

      Sample.play(:explode_big)
    end

    def hit
      self.state = :alarmed

      Sample.play(:explode_small)
    end
  end
end
