module Actor
  class Bullet < Base
    attr_accessor :direction, :enemy

    GRAVITY = { up: 1, down: -1 }

    def initialize(*argv)
      super(*argv)
      self.image ||= window.tilesheet[2]

      @direction = opts[:direction]
      @enemy     = opts[:enemy]
    end

    def draw
      image.draw(x - 2, y, 100, width, height)
    end

    def update
      self.y -= speed * GRAVITY[direction]
      self.x += rand(-1..1)

      window.actors.delete(self) if y < 0 or y > window.height
      window.actors.each do |target|
        next if target.equal?(self)

        window.collision_check(target, self)
      end
    end

    def y_bound(t_y, t_height)
      [y, y + height].any? { |yy| yy.between?(t_y, t_y + t_height) }
    end

    def x_bound(t_x, t_width)
      [x, x + width].any? { |xx| xx.between?(t_x, t_x + t_width) }
    end
  end
end
