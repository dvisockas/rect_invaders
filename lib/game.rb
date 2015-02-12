class Game < Gosu::Window
  attr_accessor :player, :actors, :score, :level, :debug, :pause

  def initialize
    super(1024, 768, false)
    self.caption = 'Rect. Invaders'
    @score = @level = 0

    @player = Actor::Player.new(self, 500, 700, 21, 21, 5)

    @text = Gosu::Font.new(self, Gosu::default_font_name, 20)

    new_level
  end

  def new_game
    self.score = self.level = 0

    new_level
  end

  def new_level
    self.level += 1

    player.state = nil
    self.actors  = [player]

    populate_aliens
  end

  def populate_aliens
    5.times do |row|
      11.times do |col|
        new_alien(row, col, row == 4 && (col % 2).zero?)
      end
    end
  end

  def new_alien(row, col, alarmed)
    @actors.push(Actor::Alien.new(
        self,
        200 + 70 * col,
        50 + 70 * row,
        21,
        21,
        2,
        state: (:alarmed if alarmed)
      )
    )
  end

  def animate_aliens
    if aliens.all?(&:path_clear?)
      aliens.each(&:move)
    else
      aliens.each(&:bounce)
    end
  end

  def aliens
    actors.select { |it| it.is_a? Actor::Alien }
  end

  def tilesheet
    @tilesheet ||= Gosu::Image::load_tiles(self, 'palette.png', 1, 1, false)
  end

  def update
    return if game_over? or pause

    new_level if aliens.empty?

    animate_aliens

    actors.each(&:update)
  end

  def draw
    show_debug if debug
    show_score

    if game_over?
      big_status_text('GAME OVER', 'Press Enter to start new game')
    else
      actors.each(&:draw)
    end

    big_status_text("PAUSE") if pause
  end

  def button_down(id)
    case id
    when Gosu::KbReturn
      new_game
    when Gosu::KbEscape
      close
    when Gosu::KbUp
      player.shoot
    when Gosu::KbD
      self.debug = !debug
    when Gosu::KbSpace
      self.pause = !pause
    end
  end

  def show_debug
    text = 'FPS: %s, ENV_OBJ: %s, GAME_OBJ: %s' % [
      Gosu::fps,
      ObjectSpace.count_objects[:T_OBJECT],
      actors.size
    ]

    @text.draw(text, 20, height - 30, 999, 1, 1, Gosu::Color::WHITE)
  end

  def show_score
    text = "Level: %s\t Score: %s" % [level, score]

    @text.draw(text, 10, 10, 999, 1.5, 1.5, Gosu::Color::WHITE)
  end

  def collision_check(target, bullet)
    if bullet.x_bound(target.x, target.width) &&
       bullet.y_bound(target.y, target.height)

      return if bullet == target

      if target.state == :alarmed
        self.score += (100.0 / target.width * level).to_i

        actors.delete(target)
      else
        target.state = :alarmed
      end

      actors.delete(bullet)
    end
  end

  def big_status_text(smth, subtext = nil)
    horizontal = width / 2 - smth.size * 25
    vertical   = height / 2 - 100
    color      = Gosu::Color::WHITE

    @text.draw(smth, horizontal, vertical, 9, 5, 5, color)
    @text.draw(subtext, horizontal, vertical + 100, 9, 2, 2, color) if subtext
  end

  def game_over?
    aliens_descended? or player_dead?
  end

  def player_dead?
    actors.none? do |actor|
      actor.is_a? Actor::Player
    end
  end

  def aliens_descended?
    aliens.any? do |alien|
      alien.y >= player.y
    end
  end
end
