class Sample
  class << self
    def samples
      @@samples ||= Dir.glob('audio/*.wav').each_with_object({}) do |sample, list|
        key = sample.match('audio/(.*).wav')[1].intern

        list[key] = Gosu::Sample.new(sample)
      end
    end

    def play(key)
      samples[key].play
    end
  end
end
