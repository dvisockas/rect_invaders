class Swarm
  SWARMS = Dir.glob('swarms/*').each_with_object({}) do |it, hash|
    name = it.match(/swarms\/(.*)$/)[1].to_sym

    hash[name] = File.readlines(it)
  end

  SIZE = 25
  QUEUE = { 1 => :invader, 2 => :ruby, 3 => :plate }

  attr_reader :window

  def initialize(window)
    @window = window
  end

  def load_file
    QUEUE.default = SWARMS.keys.sample # rolling random if unset level order

    SWARMS[QUEUE[window.level]]
  end

  def file
    @file ||= load_file
  end

  def size
    @size ||= [(window.width / (file.max.size + file.max.size / 1.5 + 10)), SIZE].min
  end

  def spawn
    file.each_with_index do |line, row|
      line.chomp.each_char.each_with_index do |c, col|
        next if c.eql?(' ')

        new_alien(row, col)
      end
    end
  end

  def new_alien(row, col)
    window.actors.push(
      Actor::Alien.new(
        window,
        10 + (size + size / 1.5) * col,
        50 + (size + size / 1.5) * row,
        size, size, 2,
        state: (:alarmed if row == file.size - 1)
      )
    )
  end
end
