class Sample
  SAMPLES = Dir.glob('audio/*.wav').each_with_object({}) do |sample, list|
    key = sample.match('audio/(.*).wav')[1].intern

    list[key] = Gosu::Sample.new(sample)
  end

  def self.play(key)
    SAMPLES[key].play
  end
end
