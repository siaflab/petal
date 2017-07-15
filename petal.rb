#--
# petal.rb
#  specs:
#   function:
#     `d1`〜`d9` ループ
#     `cps`, `bps`, `bpm` テンポ設定 [Tempo]
#     `hush` ループを全て停止
#     `solo :d1, 'bd*4'` d1のみループ(d1の前に":", 後ろに","を付ける。それ以外はそのまま)
#   operator:
#     `:` インデックス指定
#     `*` 繰り返し [Repetition - repeat as many times]
#     `/` 繰り返し [Repetition - occur less often]
#     `(k,n,r)` ユークリッドリズム(k: num_accents, n: size, r: beat_rotations) [Euclidean Sequences]
#   value:
#     `~` 休符 [Rest]
#     `:silence` ループ停止 [Silence] `d1 :silence`
#     `` ループ停止 `d1`
#   option:
#     `n:` インデックス指定 [Sample Selection] `:`の指定を上書きします
#     `gain:`, `amp:` 音量(0〜∞)
#     `pan:` パン(-1.0〜1.0)
#     `speed:`, `rate:` 再生レート(-∞〜∞)
#     `density:` ループ回数を増やす(0〜∞)
#     `slow:` ループ回数を減らす(0〜∞), `slow: 2`は`density: 0.5`と同じです
#     `stretch:` ビートストレッチ(`:b`,`'b'`), ピッチストレッチ(`:p`,`'p'`)のいずれかを指定
#
#  example:
# cps(1)
# d1 'bd(5,8,2)', speed: 'rand -3 4', n: 'irand 64'
# d2 'sn sn/4 ~ sn', speed: '1 -0.5 2 -1.5', pan: 'rand -1 1'
# d3 :loop_garzul, stretch: :p, slow: 32, gain: 0.5
#++
require 'singleton'
require_relative './petal_data.rb'
require_relative './petal_parser.rb'

module PetalLang
  module Petal
    extend self
    @@seconds_per_cycle = 1.0
    @@bpm = 60
    @@solo = nil

    # @@dirt_dir = '~/Library/Application Support/SuperCollider/downloaded-quarks/Dirt-Samples'
    # @@dirt_dir = '~/Dirt-Samples'
    @@dirt_dir = File.dirname(__FILE__) + '/Dirt-Samples'

    def play_array(arry, dur, loop_index, cycle)
      if !arry || arry.count == 0
        sleep dur.to_f
        return
      end
      count = arry.count
      dur_per_element = dur.to_f / count
      arry.each do |element|
        if element.is_a?(Array)
          play_array(element, dur_per_element, loop_index, cycle)
        else
          play_sound(element, dur_per_element, loop_index, cycle)
        end
      end
    end

    def calc_rand(r)
      if r.is_a?(Rand)
        rrand(r.min.to_f, r.max.to_f)
      elsif r.is_a?(IRand)
        rrand_i(r.min.to_i, r.max.to_i)
      end
    end

    def play_sound(sound, dur, loop_index, cycle)
      puts "sound: #{sound}"
      puts "dur: #{dur}"
      puts "cycle.random_gain: #{cycle.random_gain}"
      puts "cycle.random_pan: #{cycle.random_pan}"
      puts "cycle.random_speed: #{cycle.random_speed}"
      if Sound::REST.equal?(sound)
        # 休符
        sleep dur
      elsif sound.divisor > 1 && loop_index.modulo(sound.divisor) != 0
        # '/'で、loop_index % divisorが0以外は、休符
        sleep dur
      else
        index = cycle.random_n ? calc_rand(cycle.random_n) : sound.index
        amp = cycle.random_gain ? calc_rand(cycle.random_gain) : sound.amp
        pan = cycle.random_pan ? calc_rand(cycle.random_pan) : sound.pan
        rate = cycle.random_speed ? calc_rand(cycle.random_speed) : sound.rate
        play_sample(sound.name, index, dur, amp, pan, rate, cycle.stretch)
      end
    end

    def play_sample(name, index, dur_per_sample, amp, pan, rate, stretch)
      if name.is_a?(Symbol)
        case stretch
        when :b, 'b'
          # beat_stretch指定の場合はrate:を無視する
          sample name, amp: amp, pan: pan, beat_stretch: dur_per_sample
        when :p, 'p'
          sample name, amp: amp, pan: pan, rate: rate, pitch_stretch: dur_per_sample
        else
          sample name, amp: amp, pan: pan, rate: rate
        end
      else
        sample_dir = File.expand_path(@@dirt_dir + '/' + name) + '/'
        puts "sample_dir: #{sample_dir}"
        puts "index: #{index}"
        puts "rate: #{rate}"
        case stretch
        when :b, 'b'
          # beat_stretch指定の場合はrate:を無視する
          sample sample_dir, index, amp: amp, pan: pan, beat_stretch: dur_per_sample
        when :p, 'p'
          sample sample_dir, index, amp: amp, pan: pan, rate: rate, pitch_stretch: dur_per_sample
        else
          sample sample_dir, index, amp: amp, pan: pan, rate: rate
        end
      end
      sleep dur_per_sample
    end

    def set_dirt_dir(dir)
      @@dirt_dir = dir
    end

    def set_seconds_per_cycle(sec)
      @@seconds_per_cycle = sec
    end

    def get_seconds_per_cycle
      @@seconds_per_cycle
    end

    def set_bpm(beat_per_min)
      @@bpm = beat_per_min
    end

    def dirt_hush
      @@solo = :d0
      for i in 1..9 do
        s = "d#{i}".intern
        live_loop s do
          stop
        end
      end
    end

    def dirt_solo(loop_name, sound = nil, **option_hash)
      @@solo = loop_name
      for i in 1..9 do
        s = "d#{i}".intern
        next if s == loop_name
        live_loop s do
          stop
        end
      end
      dirt loop_name, sound, option_hash
    end

    def dirt(loop_name, sound = nil, **option_hash)
      puts "sound: #{sound}"
      puts "option_hash: #{option_hash}"
      return if !@@solo.nil? && @@solo != loop_name # 他のループがsoloの場合

      cycle = Parser.parse(@@bpm, sound, **option_hash)

      dur = @@seconds_per_cycle
      live_loop :d0 do
        use_bpm @@bpm
        sleep dur
        @@solo = nil
      end

      live_loop loop_name, sync: :d0 do
        stop if cycle.sound_array.empty?
        loop_index = tick
        puts "loop_index: #{loop_index}"
        use_bpm cycle.bpm
        play_array(cycle.sound_array, dur, loop_index, cycle)
      end
    end
  end
end

include PetalLang::Petal
def cps(cycle_per_sec)
  seconds_per_cycle = get_seconds_per_cycle
  beat_per_min = 60.0 * cycle_per_sec * seconds_per_cycle
  set_bpm beat_per_min
end

def bps(beat_per_sec)
  # cps(1) == bps(120/60) == bpm(120)
  #  https://tidalcycles.org/patterns.html#tempo
  seconds_per_cycle = get_seconds_per_cycle
  beat_per_min = beat_per_sec * 60.0 / (2.0 * seconds_per_cycle)
  set_bpm beat_per_min
end

def bpm(beat_per_min)
  seconds_per_cycle = get_seconds_per_cycle
  beat_per_min /= (2.0 * seconds_per_cycle)
  set_bpm beat_per_min
end

def d1(sound = nil, **option_hash)
  dirt :d1, sound, option_hash
end

def d2(sound = nil, **option_hash)
  dirt :d2, sound, option_hash
end

def d3(sound = nil, **option_hash)
  dirt :d3, sound, option_hash
end

def d4(sound = nil, **option_hash)
  dirt :d4, sound, option_hash
end

def d5(sound = nil, **option_hash)
  dirt :d5, sound, option_hash
end

def d6(sound = nil, **option_hash)
  dirt :d6, sound, option_hash
end

def d7(sound = nil, **option_hash)
  dirt :d7, sound, option_hash
end

def d8(sound = nil, **option_hash)
  dirt :d8, sound, option_hash
end

def d9(sound = nil, **option_hash)
  dirt :d9, sound, option_hash
end

def hush
  dirt_hush
end

def solo(loop_name, sound = nil, **option_hash)
  dirt_solo loop_name, sound, option_hash
end

def dirt_names()
  path = File.expand_path(@@dirt_dir)
  entries = Dir.entries(path)
  entries -= ['.']
  entries -= ['..']
  entries -= ['Dirt-Samples.quark']
  # entries.map { |e| path + e }
end

def dirt_sample(name, index = 0)
  path = File.expand_path(@@dirt_dir + '/' + name) + '/'
  entries = Dir.entries(path)
  entries -= ['.']
  entries -= ['..']
  i = index % entries.count
  path + entries[i]
end

def dirt_samples(name)
  path = File.expand_path(@@dirt_dir + '/' + name) + '/'
  entries = Dir.entries(path)
  entries -= ['.']
  entries -= ['..']
  entries.map { |e| path + e }
end

def euclidean_rhythm(num_accents, size, beat_rotations = nil)
  PetalLang::Parser.euclidean_rhythm(num_accents, size, beat_rotations)
end
