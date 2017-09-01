module PetalLang
  module LoopHolder
    extend self
    @@loop_sub_numbers = {}
  end

  class Cycle
    attr_reader :bpm
    attr_reader :sound_array
    attr_reader :stretch
    attr_reader :random_n
    attr_reader :random_gain
    attr_reader :random_pan
    attr_reader :random_speed

    def initialize(bpm, sound_array, stretch = nil, random_n = nil, random_gain = nil, random_pan = nil, random_speed = nil)
      @bpm = bpm
      @sound_array = sound_array
      @stretch = stretch
      @random_n = random_n
      @random_gain = random_gain
      @random_pan = random_pan
      @random_speed = random_speed
    end

    def ==(other)
      return false if other.nil?
      return false unless other.is_a?(Cycle)
      @bpm == other.bpm && @sound_array == other.sound_array &&
        @stretch == other.stretch && @random_n == other.random_n &&
        @random_gain == other.random_gain && @random_pan == other.random_pan &&
        @random_speed == other.random_speed
    end
  end

  class Sound
    attr_accessor :name
    attr_accessor :index
    attr_accessor :divisor
    attr_accessor :amp
    attr_accessor :pan
    attr_accessor :rate

    def initialize(sample_name, index, divisor)
      @name = sample_name
      @index = index
      @divisor = divisor
      @amp = 1.0
      @pan = 0
      @rate = 1.0
    end

    def ==(other)
      return false if other.nil?
      return false unless other.is_a?(Sound)
      @name == other.name && @index == other.index &&
        @divisor.to_f == other.divisor.to_f && @amp.to_f == other.amp.to_f &&
        @pan.to_f == other.pan.to_f && @rate.to_f == other.rate.to_f
    end

    REST = Sound.new('~', 0, 1)
  end

  class Option
    attr_reader :value
    attr_reader :divisor

    def initialize(value, divisor)
      @value = value
      @divisor = divisor
    end

    def ==(other)
      return false if other.nil?
      return false unless other.is_a?(Option)
      @value == other.value && @divisor.to_f == other.divisor.to_f
    end

    REST = Option.new('~', 1)
  end

  class Rand
    attr_reader :min
    attr_reader :max
    def initialize(min, max)
      @min = min
      @max = max
    end

    def ==(other)
      return false if other.nil?
      return false unless other.is_a?(Rand)
      @min == other.min && @max == other.max
    end
  end

  class IRand
    attr_reader :min
    attr_reader :max
    def initialize(min, max)
      @min = min
      @max = max
    end

    def ==(other)
      return false if other.nil?
      return false unless other.is_a?(IRand)
      @min == other.min && @max == other.max
    end
  end
end
