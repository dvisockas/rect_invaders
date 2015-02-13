module Actor
  class Alien < Base
    attr_accessor :cannon_timer, :velocity

    CANNON_DELAY = 300

    def initialize(*argv)
      super(*argv)
      self.image ||= window.tilesheet[1]

      @velocity = 1
      @cannon_timer = CANNON_DELAY
    end

    def draw
      if alarmed?
        pos_x = x + rand(-2..2)
        pos_y = y + rand(-2..2)
      else
        pos_x = x
        pos_y = y
      end

      image.draw(pos_x, pos_y, 100, width, height)
    end

    def update
      self.cannon_timer -= rand(0..window.level)

      return unless cannon_timer <= 0

      shoot

      self.cannon_timer += CANNON_DELAY
    end

    def shoot
      return unless alarmed?

      window.actors.push Bullet.new(
        window,
        x + width / 2,
        y + height,
        5,
        15,
        5,
        direction: :down,
        enemy: Player,
        image: image
      )

      Sample.play(:laser_tiny)
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

    def alarmed?
      state == :alarmed
    end
  end
end
