module Actor
  class Alien < Base
    attr_accessor :image, :true_img, :cannon_timer

    def initialize(*argv)
      super(*argv)

      @cannon_timer = 0
      @image = window.tilesheet[1]
      @true_img = @image
    end

    def draw
      if image == window.tilesheet[2]
        pos_x = x + [*-2..2].sample
        pos_y = y + [*-2..2].sample
      else
        pos_x = x
        pos_y = y
      end

      image.draw(pos_x, pos_y, 100, width, height)
    end

    def update
      self.cannon_timer -= 1 * window.level

      return unless cannon_timer <= 0

      shoot
      self.cannon_timer += 1_000
    end

    def shoot
      return unless image == window.tilesheet[2]

      window.actors.push Bullet.new(
        window,
        x + width / 2,
        y + height,
        5,
        15,
        5,
        direction: :down,
        enemy: Player,
        tile: 2
      )
    end

    def bounce
      self.y += 3 * (speed + 1)

      self.velocity *= -1
      self.x += speed * velocity
    end

    def move
      self.x += speed * velocity if path_clear?
    end

    def path_clear?
      nx = x + speed * velocity

      nx + width < window.width && x > 1
    end
  end
end
