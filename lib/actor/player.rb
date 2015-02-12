module Actor
  class Player < Base
    attr_reader :true_img
    attr_accessor :image

    def initialize(*arg)
      super(*arg)

      @image  = window.tilesheet[0]
      @true_img = @image
    end

    def draw
      @image.draw(x, y, 100, width, height)
    end

    def update
      move_right if window.button_down?(Gosu::KbRight)
      move_left  if window.button_down?(Gosu::KbLeft)
    end

    def shoot
      window.actors.push Bullet.new(
        window,
        x + width / 2,
        y - height,
        5,
        15,
        5,
        direction: :up,
        enemy: Alien,
        tile: 0
      )
    end

    def move_right
      self.x = [x + width + speed, window.width].min - width
    end

    def move_left
      self.x = [x - speed, 1].max
    end
  end
end
