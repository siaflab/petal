require 'singleton'
require_relative './EuclideanRhythm/euclidean_rhythm.rb'
require_relative './petal_data.rb'
require_relative './petal_util.rb'

module PetalLang
  module Parser
    extend self
    include PetalLang::Util

    def normalize_sound_string(sound)
      sound_string = if sound.is_a?(Symbol)
                       '[' + ':' + sound.to_s + ']'
                     else
                       '[' + sound.to_s + ']'
                     end
    end

    def normalize_option_string(option)
      # 当面はsoundと同じ実装
      normalize_sound_string(option)
    end

    def find_element(index_array, target_array)
      element = nil
      index_array.each do |i|
        while target_array.is_a?(Array) && target_array.count == 1
          # 配列の入れ子(例: "[[[1, 3]]]")の場合の対応
          element = target_array[0]
          target_array = element
        end
        next unless target_array.is_a?(Array)
        idx = i.modulo(target_array.count)
        element = target_array[idx]
        target_array = element
      end
      return element[0] if element.is_a?(Array)
      element
    end

    def dfs_merge_with_n_array(sound_array, n_array)
      dfs_each_with_index_map(sound_array) do |sound, index_array|
        n_element = find_element(index_array, n_array)
        sound.index = n_element.value.to_i unless Option::REST.equal?(n_element)
        sound
      end
    end

    def dfs_merge_with_gain_array(sound_array, gain_array)
      dfs_each_with_index_map(sound_array) do |sound, index_array|
        gain = find_element(index_array, gain_array)
        sound.amp = gain.value unless Option::REST.equal?(gain)
        sound
      end
    end

    def dfs_merge_with_pan_array(sound_array, pan_array)
      dfs_each_with_index_map(sound_array) do |sound, index_array|
        pan = find_element(index_array, pan_array)
        sound.pan = pan.value unless Option::REST.equal?(pan)
        sound
      end
    end

    def dfs_merge_with_speed_array(sound_array, speed_array)
      dfs_each_with_index_map(sound_array) do |sound, index_array|
        speed = find_element(index_array, speed_array)
        sound.rate = sound.rate.to_f * speed.value.to_f unless Option::REST.equal?(speed)
        sound
      end
    end

    def dfs_merge_n_array_with_sound_array(n_array, sound_array)
      dfs_each_with_index_map(n_array) do |n_element, index_array|
        if Option::REST.equal?(n_element)
          sound = Sound::REST
        else
          s = find_element(index_array, sound_array)
          sound = Sound.new(s.name, s.index, n_element.divisor)
          sound.index = n_element.value.to_i
        end
        sound
      end
    end

    def dfs_merge_gain_array_with_sound_array(gain_array, sound_array)
      dfs_each_with_index_map(gain_array) do |gain, index_array|
        if Option::REST.equal?(gain)
          sound = Sound::REST
        else
          s = find_element(index_array, sound_array)
          sound = Sound.new(s.name, s.index, gain.divisor)
          sound.amp = gain.value
        end
        sound
      end
    end

    def dfs_merge_pan_array_with_sound_array(pan_array, sound_array)
      dfs_each_with_index_map(pan_array) do |pan, index_array|
        if Option::REST.equal?(pan)
          sound = Sound::REST
        else
          s = find_element(index_array, sound_array)
          sound = Sound.new(s.name, s.index, pan.divisor)
          sound.pan = pan.value
        end
        sound
      end
    end

    def dfs_merge_speed_array_with_sound_array(speed_array, sound_array)
      dfs_each_with_index_map(speed_array) do |speed, index_array|
        if Option::REST.equal?(speed)
          sound = Sound::REST
        else
          s = find_element(index_array, sound_array)
          sound = Sound.new(s.name, s.index, speed.divisor)
          sound.rate = sound.rate.to_f * speed.value.to_f
        end
        sound
      end
    end

    def merge_with_sound_array(option_hash, key)
      option = option_hash[key]
      random_n = Parser.parse_rand(option)
      if random_n.nil?
        option_string = Parser.normalize_option_string(option)
        option_array = Parser::OptionParser.instance.read(option_string)
        dbg "option_array: #{option_array}"
        yield(option_array)
        # 後ろの処理でparseさせないよう、ここで当該オプションを削除
        option_hash.delete(key)
      end
    end

    def dfs_each_with_index_map(arry, index_array = [], &block)
      arry.each_with_index.map do |e, i|
        is_array = e.is_a?(Array)
        push_index = !(is_array && arry.count == 1)
        # 配列の入れ子の場合の対応
        #  "[[[1, 3]]]"の場合に、index_arrayを[0, 0, 0, 0]や[0, 0, 0, 1]とせず、
        #  [0]や[1]になるようにする。
        index_array.push(i) if push_index
        dbg "index_array: #{index_array}"
        e = if is_array
              dfs_each_with_index_map(e, index_array, &block)
            else
              yield(e, index_array)
            end
        index_array.pop if push_index
        e
      end
    end

    def euclidean_rhythm(num_accents, size, beat_rotations = nil)
      res = EuclideanRhythm.euclidean_rhythm(num_accents, size)
      if beat_rotations && beat_rotations.is_a?(Numeric)
        res.rotate!(beat_rotations)
      end
      res
    end

    def parse_rand(s)
      min = '0'
      max = '1'
      return Rand.new(min, max) if s == :rand
      return IRand.new(min, max) if s == :irand
      return nil unless s.is_a?(String)
      m = /((rand)|(irand))\s?\(?\s?(\-?\d+\.?\d*)?\s?,?\s?(\-?\d+\.?\d*)?\)?/.match(s)
      return nil unless m
      is_rand = m[2] && m[2] != ''
      is_irand = m[3] && m[3] != ''
      val1 = m[4] if m[4] && m[4] != ''
      val2 = m[5] if m[5] && m[5] != ''
      if val1 && val2
        min = val1
        max = val2
      elsif val1
        max = val1
      end
      return Rand.new(min, max) if is_rand
      return IRand.new(min, max) if is_irand
    end

    def find_left_most_option(**option_hash)
      option_hash.each do |k, v|
        dbg "option_hash[#{k}]: #{v}"
        case k
        when :s, :sound, :n, :gain, :amp, :pan, :speed, :rate
          return k
        end
      end
      nil
    end

    def parse(bpm, sound = nil, **option_hash)
      # stop
      return Cycle.new(bpm, []) if sound == :silence || (sound.nil? || sound.empty?) && (option_hash.nil? || option_hash.empty?)

      if sound && !sound.empty?
        # 引数soundありの場合。
        sound_string = Parser.normalize_sound_string(sound)
        sound_array = Parser::SoundParser.instance.read(sound_string)

        # 引数soundありでoptionなしの場合、optionをparseせずここでreturn
        return Cycle.new(bpm, sound_array) if option_hash.nil? || option_hash.empty?
      else
        # 引数soundなしの場合。

        # opthon_hashに、`s:`か`sound:`があるかチェックする。
        sound = option_hash[:s] || option_hash[:sound]
        return Cycle.new(bpm, []) if sound.nil?

        sound_string = Parser.normalize_sound_string(sound)
        sound_array = Parser::SoundParser.instance.read(sound_string)
        dbg "sound_array: #{sound_array}"

        left_most = find_left_most_option(**option_hash)
        case left_most
        # when :s, :sound
        when :n
          Parser.merge_with_sound_array(option_hash, left_most) do |n_array|
            sound_array = Parser.dfs_merge_n_array_with_sound_array(n_array, sound_array)
          end
        when :gain, :amp
          Parser.merge_with_sound_array(option_hash, left_most) do |gain_array|
            sound_array = Parser.dfs_merge_gain_array_with_sound_array(gain_array, sound_array)
          end
        when :pan
          Parser.merge_with_sound_array(option_hash, left_most) do |pan_array|
            sound_array = Parser.dfs_merge_pan_array_with_sound_array(pan_array, sound_array)
          end
        when :speed, :rate
          dbg "sound_array: #{sound_array}"
          Parser.merge_with_sound_array(option_hash, left_most) do |speed_array|
            sound_array = Parser.dfs_merge_speed_array_with_sound_array(speed_array, sound_array)
          end
        end
      end

      # :n
      n_option = option_hash[:n]
      unless n_option.nil?
        random_n = Parser.parse_rand(n_option)
        if random_n.nil?
          n_string = Parser.normalize_option_string(n_option)
          n_array = Parser::OptionParser.instance.read(n_string)
          dbg n_array
          sound_array = Parser.dfs_merge_with_n_array sound_array, n_array
        end
      end

      # :gain, :amp
      gain = option_hash[:gain] || option_hash[:amp]
      unless gain.nil?
        random_gain = Parser.parse_rand(gain)
        if random_gain.nil?
          gain_string = Parser.normalize_option_string(gain)
          gain_array = Parser::OptionParser.instance.read(gain_string)
          dbg gain_array
          sound_array = Parser.dfs_merge_with_gain_array sound_array, gain_array
        end
      end

      # :pan
      pan = option_hash[:pan]
      unless pan.nil?
        random_pan = Parser.parse_rand(pan)
        if random_pan.nil?
          pan_string = Parser.normalize_option_string(pan)
          pan_array = Parser::OptionParser.instance.read(pan_string)
          dbg pan_array
          sound_array = Parser.dfs_merge_with_pan_array sound_array, pan_array
        end
      end

      # :speed, :rate
      speed = option_hash[:speed] || option_hash[:rate]
      unless speed.nil?
        random_speed = Parser.parse_rand(speed)
        if random_speed.nil?
          speed_string = Parser.normalize_option_string(speed)
          speed_array = Parser::OptionParser.instance.read(speed_string)
          dbg speed_array
          sound_array = Parser.dfs_merge_with_speed_array sound_array, speed_array
        end
      end

      density = option_hash[:fast] || option_hash[:density]
      bpm *= density.to_f unless density.nil?
      slow = option_hash[:slow]
      bpm /= slow.to_f unless slow.nil?
      dbg "bpm: #{bpm}"

      stretch = option_hash[:stretch]
      Cycle.new(bpm, sound_array, stretch, random_n, random_gain, random_pan, random_speed)
    end

    class AbstractParser
      include Singleton

      def read(s)
        read_from tokenize(s)
      end

      def tokenize(s)
        s.gsub(/[\[\]]/, ' \0 ').split # []
      end

      def read_from(tokens)
        raise SytaxError, 'unexpected EOF while reading' if tokens.empty?
        case token = tokens.shift
        when '['
          l = [] # 配列の初期化
          l.push read_from(tokens) until tokens[0] == ']'
          tokens.shift
          l
        when ']'
          raise SyntaxError, 'unexpected ]'
        else
          process_token(token)
          # token
        end
      end
    end

    class SoundParser < AbstractParser
      def process_token(token)
        index = 0
        divisor = 1
        m = /(:?)([0-9a-zA-Z_~]+):?(\d*)(((\*|\/)?(\d+))|(\(\s?(\d+),\s?(\d+),?\s?(\d*)\s?\)))?/.match(token)
        raise SyntaxError, "token: #{token}" unless m
        builtin_sample = m[1] && m[1] != ''
        name = m[2]
        name = name.intern if builtin_sample
        index = m[3].to_i if m[3] && m[3] != ''

        operator = m[6] if m[6] && m[6] != ''
        number = m[7].to_i if m[7] && m[7] != ''

        num_accents = m[9].to_i if m[9] && m[9] != ''
        size = m[10].to_i if m[10] && m[10] != ''
        beat_rotations = m[11].to_i if m[11] && m[11] != ''

        dbg "index: #{index}"
        dbg "operator: #{operator}"
        dbg "number: #{number}"
        dbg "num_accents: #{num_accents}"
        dbg "size: #{size}"
        dbg "beat_rotations: #{beat_rotations}"

        if num_accents && num_accents != 0 && size && size != 0
          pattern = Parser.euclidean_rhythm(num_accents, size, beat_rotations)
          pattern = pattern.map { |e| e ? Sound.new(name, index, divisor) : Sound::REST }
          return pattern
        elsif operator == '*' && number && number != 0
          arry = [] # 配列の初期化
          number.times do
            s = if name == '~'
                  Sound::REST
                else
                  Sound.new(name, index, divisor)
                end
            arry.push s
          end
          return arry
        elsif operator == '/' && number && number != 0
          divisor = number
        end

        node = if name == '~'
                 Sound::REST
               else
                 Sound.new(name, index, divisor)
               end
        node
      end
    end

    class OptionParser < AbstractParser
      def process_token(token)
        index = 0
        divisor = 1
        m = /((\-?\d+\.?\d*)|~)(((\*|\/)?(\d+))|(\(\s?(\d+),\s?(\d+),?\s?(\d*)\s?\)))?/.match(token)
        # m = /((\-?\d+\.?\d*)|~)(((\*|\/)?(\d+))|(\(\s?(\d+),\s?(\d+),?\s?(\d*)\s?\)))?/.match('0.5(5,8,2)')
        raise SyntaxError, "token: #{token}" unless m
        num_or_tilde = m[1]
        val = m[2]

        operator = m[5] if m[5] && m[5] != ''
        number = m[6].to_i if m[6] && m[6] != ''

        num_accents = m[8].to_i if m[8] && m[8] != ''
        size = m[9].to_i if m[9] && m[9] != ''
        beat_rotations = m[10].to_i if m[10] && m[10] != ''

        dbg "operator: #{operator}"
        dbg "number: #{number}"

        if num_accents && num_accents != 0 && size && size != 0
          pattern = Parser.euclidean_rhythm(num_accents, size, beat_rotations)
          pattern = pattern.map { |e| e ? Option.new(val, divisor) : Option::REST }
          return pattern
        elsif operator == '*' && number && number != 0
          arry = [] # 配列の初期化
          number.times do
            arry.push Option.new(val, divisor)
          end
          return arry
        elsif operator == '/' && number && number != 0
          divisor = number
        end

        node = num_or_tilde == '~' ? Option::REST : Option.new(val, divisor)
        node
      end
    end
  end
end
