#!/usr/bin/ruby
require 'test/unit'
require_relative './petal.rb'

class TestParserModule < Test::Unit::TestCase
  def test_find_left_most_array_option_nil
    expected = nil
    actual = PetalLang::Parser.find_left_most_option
    assert_equal expected, actual
  end

  def test_find_left_most_array_option_1
    expected = :speed
    actual = PetalLang::Parser.find_left_most_option(speed: 'rand -3 4', n: 'irand 64')
    assert_equal expected, actual
  end

  def test_find_left_most_array_option_2
    expected = :speed
    actual = PetalLang::Parser.find_left_most_option(slow: 2, speed: 'rand -3 4', n: 'irand 64')
    assert_equal expected, actual
  end

  def test_parse_nil
    expected = PetalLang::Cycle.new(120, [])
    actual = PetalLang::Parser.parse(120)
    assert_equal expected, actual
  end

  def test_parse_blank
    expected = PetalLang::Cycle.new(120, [])
    actual = PetalLang::Parser.parse(120, '')
    assert_equal expected, actual
  end

  def test_parse_blank_with_option
    # オプションがあっても、soundが""の場合には、arrayが空にしている
    expected = PetalLang::Cycle.new(120, [])
    actual = PetalLang::Parser.parse(120, '', gain: 0.8)
    assert_equal expected, actual
  end

  def test_parse_nil_with_option
    # オプションがあっても、soundがnilの場合には、arrayが空にしている
    expected = PetalLang::Cycle.new(120, [])
    actual = PetalLang::Parser.parse(120, gain: 0.8)
    assert_equal expected, actual
  end

  def test_parse_bd
    s = PetalLang::Sound.new('bd', 0, 1)
    expected = PetalLang::Cycle.new(120, [s])
    actual = PetalLang::Parser.parse(120, 'bd')
    assert_equal expected, actual
  end

  def test_parse_bd_amp
    s = PetalLang::Sound.new('bd', 0, 1)
    s.amp = '0.5'
    expected = PetalLang::Cycle.new(120, [s])
    actual = PetalLang::Parser.parse(120, 'bd', gain: 0.5)
    assert_equal expected, actual
  end

  def test_parse_bd_amp_x2
    s0 = PetalLang::Sound.new('bd', 0, 1)
    s0.amp = '0.5'
    s1 = PetalLang::Sound.new('bd', 0, 1)
    s1.amp = '1.5'
    s1_1 = PetalLang::Sound.new('bd', 0, 1)
    s1_1.amp = '0.7'
    expected = PetalLang::Cycle.new(120, [s0, [s1, s1_1]])
    actual = PetalLang::Parser.parse(120, 'bd [bd bd]', gain: '0.5 [1.5 0.7]')
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd
    s = PetalLang::Sound.new('bd', 0, 1)
    expected = PetalLang::Cycle.new(120, [s])
    actual = PetalLang::Parser.parse(120, sound: 'bd')
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd_amp
    s = PetalLang::Sound.new('bd', 0, 1)
    s.amp = '0.5'
    expected = PetalLang::Cycle.new(120, [s])
    actual = PetalLang::Parser.parse(120, sound: 'bd', gain: 0.5)
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd_amp_x2
    s0 = PetalLang::Sound.new('bd', 0, 1)
    s0.amp = '0.5'
    s1 = PetalLang::Sound.new('bd', 0, 1)
    s1.amp = '1.5'
    s1_1 = PetalLang::Sound.new('bd', 0, 1)
    s1_1.amp = '0.7'
    expected = PetalLang::Cycle.new(120, [s0, [s1, s1_1]])
    actual = PetalLang::Parser.parse(120, sound: 'bd [bd bd]', gain: '0.5 [1.5 0.7]')
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd_amp_x2_gain_left
    s0 = PetalLang::Sound.new('bd', 0, 1)
    s0.amp = '0.5'
    s1 = PetalLang::Sound.new('bd', 0, 1)
    s1.amp = '1.5'
    s1_1 = PetalLang::Sound.new('bd', 0, 1)
    s1_1.amp = '0.7'
    expected = PetalLang::Cycle.new(120, [s0, [s1, s1_1]])
    actual = PetalLang::Parser.parse(120, gain: '0.5 [1.5 0.7]', sound: 'bd')
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd_n_x2_n_left
    s0 = PetalLang::Sound.new('bd', 0, 1)
    s0.index = 5
    s1 = PetalLang::Sound.new('bd', 0, 1)
    s1.index = 7
    s1_1 = PetalLang::Sound.new('bd', 0, 1)
    s1_1.index = 9
    expected = PetalLang::Cycle.new(120, [s0, [s1, s1_1]])
    actual = PetalLang::Parser.parse(120, n: '5 [7 9]', sound: 'bd')
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd_pan_x2_pan_left
    s0 = PetalLang::Sound.new('bd', 0, 1)
    s0.pan = '0.5'
    s1 = PetalLang::Sound.new('bd', 0, 1)
    s1.pan = '-1.0'
    s1_1 = PetalLang::Sound.new('bd', 0, 1)
    s1_1.pan = '0.7'
    expected = PetalLang::Cycle.new(120, [s0, [s1, s1_1]])
    actual = PetalLang::Parser.parse(120, pan: '0.5 [-1.0 0.7]', sound: 'bd')
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd_speed_x2_speed_left
    s0 = PetalLang::Sound.new('bd', 0, 1)
    s0.rate = '0.5'
    s1 = PetalLang::Sound.new('bd', 0, 1)
    s1.rate = '-1.0'
    s1_1 = PetalLang::Sound.new('bd', 0, 1)
    s1_1.rate = '0.7'
    expected = PetalLang::Cycle.new(120, [s0, [s1, s1_1]])
    actual = PetalLang::Parser.parse(120, speed: '0.5 [-1.0 0.7]', sound: 'bd')
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd_speed_x2_speed_left_pan
    s0 = PetalLang::Sound.new('bd', 0, 1)
    s0.rate = '0.5'
    s0.pan = '0.5'
    s1 = PetalLang::Sound.new('bd', 0, 1)
    s1.rate = '-1.0'
    s1.pan = '0.5'
    s1_1 = PetalLang::Sound.new('bd', 0, 1)
    s1_1.rate = '0.7'
    s1_1.pan = '0.5'
    expected = PetalLang::Cycle.new(120, [s0, [s1, s1_1]])
    actual = PetalLang::Parser.parse(120, speed: '0.5 [-1.0 0.7]', pan: 0.5, sound: 'bd')
    assert_equal expected, actual
  end

  def test_parse_option_sound_bd_speed_x2_speed_left_pan_divide2
    s0 = PetalLang::Sound.new('bd', 0, 2)
    s0.rate = '0.5'
    s0.pan = '0.5'
    s1 = PetalLang::Sound.new('bd', 0, 1)
    s1.rate = '-1.0'
    s1.pan = '0.5'
    s1_1 = PetalLang::Sound.new('bd', 0, 1)
    s1_1.rate = '0.7'
    s1_1.pan = '0.5'
    expected = PetalLang::Cycle.new(120, [s0, [s1, s1_1]])
    actual = PetalLang::Parser.parse(120, speed: '0.5/2 [-1.0 0.7]', pan: 0.5, sound: 'bd')
    assert_equal expected, actual
  end

  #speed: "1(11,16,8)", s: 'hh'
  def test_parse_option_speed_e12_hh
    s = PetalLang::Sound.new('hh', 0, 1)
    s.rate = "1"
    r = PetalLang::Sound::REST
    # TODO [[]]にならないよう、PetalLang::Parser.parseを変更する
    expected = PetalLang::Cycle.new(120, [[s, r, s, s, r, s, r, s]])
    actual = PetalLang::Parser.parse(120, speed: "1(5,8,2)", s: 'hh')
    # expected = PetalLang::Cycle.new(120, [[s]])
    # actual = PetalLang::Parser.parse(120, speed: "1(1,1)", s: 'hh')
    assert_equal expected, actual
  end

  # def test_process_token_float_euc_5_8_2
  #   s = PetalLang::Option.new('1', 1)
  #   r = PetalLang::Option::REST
  #   # expected = [s, r, s, s, r, s, s, r] # E(5,8)=[x . x x . x x .]
  #   # `beat_rotations=1`で次のxまで進む模様
  #   expected = [s, r, s, s, r, s, r, s] # E(5,8,2)=[x . x x . x . x]
  #   actual = PetalLang::Parser::OptionParser.instance.process_token('1(5,8,2)')
  #   assert_equal expected, actual
  # end
  #
  # def test_read_float_euc_5_8_2
  #   s = PetalLang::Option.new('1', 1)
  #   r = PetalLang::Option::REST
  #   # expected = [s, r, s, s, r, s, s, r] # E(5,8)=[x . x x . x x .]
  #   # `beat_rotations=1`で次のxまで進む模様
  #   expected = [s, r, s, s, r, s, r, s] # E(5,8,2)=[x . x x . x . x]
  #   actual = PetalLang::Parser::OptionParser.instance.read('1(5,8,2)')
  #   assert_equal expected, actual
  # end

  def test_parse_rand_number_int
    expected = nil
    actual = PetalLang::Parser.parse_rand(1)
    assert_equal expected, actual
  end

  def test_parse_rand_string_int
    expected = nil
    actual = PetalLang::Parser.parse_rand('1')
    assert_equal expected, actual
  end

  def test_parse_rand_symbol_rand
    expected = PetalLang::Rand.new('0', '1')
    actual = PetalLang::Parser.parse_rand(:rand)
    assert_equal expected, actual
  end

  def test_parse_rand_symbol_irand
    expected = PetalLang::IRand.new('0', '1')
    actual = PetalLang::Parser.parse_rand(:irand)
    assert_equal expected, actual
  end

  def test_parse_rand_string_rand
    expected = PetalLang::Rand.new('0', '1')
    actual = PetalLang::Parser.parse_rand('rand')
    assert_equal expected, actual
  end

  def test_parse_rand_string_irand
    expected = PetalLang::IRand.new('0', '1')
    actual = PetalLang::Parser.parse_rand('irand')
    assert_equal expected, actual
  end

  def test_parse_rand_string_rand_2
    expected = PetalLang::Rand.new('0', '2')
    actual = PetalLang::Parser.parse_rand('rand 2')
    assert_equal expected, actual
  end

  def test_parse_rand_string_rand_2_with_paren
    expected = PetalLang::Rand.new('0', '2')
    actual = PetalLang::Parser.parse_rand('rand(2)')
    assert_equal expected, actual
  end

  def test_parse_rand_string_irand_2
    expected = PetalLang::IRand.new('0', '2')
    actual = PetalLang::Parser.parse_rand('irand 2')
    assert_equal expected, actual
  end

  def test_parse_rand_string_irand_2_with_paren
    expected = PetalLang::IRand.new('0', '2')
    actual = PetalLang::Parser.parse_rand('irand(2)')
    assert_equal expected, actual
  end

  def test_parse_rand_string_rand_1_1
    expected = PetalLang::Rand.new('-1', '1')
    actual = PetalLang::Parser.parse_rand('rand -1 1')
    assert_equal expected, actual
  end

  def test_parse_rand_string_rand_1_1_with_comma
    expected = PetalLang::Rand.new('-1', '1')
    actual = PetalLang::Parser.parse_rand('rand -1,1')
    assert_equal expected, actual
  end

  def test_parse_rand_string_rand_1_1_with_comma_space
    expected = PetalLang::Rand.new('-1', '1')
    actual = PetalLang::Parser.parse_rand('rand -1, 1')
    assert_equal expected, actual
  end

  def test_parse_rand_string_rand_1_1_with_paren_comma
    expected = PetalLang::Rand.new('-1', '1')
    actual = PetalLang::Parser.parse_rand('rand(-1,1)')
    assert_equal expected, actual
  end

  def test_parse_rand_string_rand_1_1_with_paren_comma_space
    expected = PetalLang::Rand.new('-1', '1')
    actual = PetalLang::Parser.parse_rand('rand(-1, 1)')
    assert_equal expected, actual
  end

  def test_parse_rand_string_irand_1_1
    expected = PetalLang::IRand.new('-1', '1')
    actual = PetalLang::Parser.parse_rand('irand -1 1')
    assert_equal expected, actual
  end

  def test_normalize_sound_string_symbol
    expected = '[:loop_garzul]'
    actual = PetalLang::Parser.normalize_sound_string(:loop_garzul)
    assert_equal expected, actual
  end

  def test_normalize_sound_string_int
    expected = '[1]'
    actual = PetalLang::Parser.normalize_sound_string(1)
    assert_equal expected, actual
  end

  def test_normalize_sound_string_float
    expected = '[0.95]'
    actual = PetalLang::Parser.normalize_sound_string(0.95)
    assert_equal expected, actual
  end

  def test_euclidean_rhythm_1_2
    expected = [true, false] # E(1,2)= [x .]
    actual = PetalLang::Parser.euclidean_rhythm(1, 2)
    assert_equal expected, actual
  end

  def test_euclidean_rhythm_1_3
    expected = [true, false, false] # E(1,3)= [x . .]
    actual = PetalLang::Parser.euclidean_rhythm(1, 3)
    assert_equal expected, actual
  end

  # Sonic Piのspreadが期待した値を返していない
  def test_euclidean_rhythm_2_5
    expected = [true, false, true, false, false] # E(2,5)=[x . x . .]
    actual = PetalLang::Parser.euclidean_rhythm(2, 5)
    assert_equal expected, actual
  end

  def test_euclidean_rhythm_3_4
    expected = [true, false, true, true] # E(3,4)=[x . x x]
    actual = PetalLang::Parser.euclidean_rhythm(3, 4)
    assert_equal expected, actual
  end

  def test_euclidean_rhythm_3_8
    expected = [true, false, false, true, false, false, true, false]
    actual = PetalLang::Parser.euclidean_rhythm(3, 8)
    assert_equal expected, actual
  end

  # Sonic Piのspreadが期待した値を返していない
  def test_euclidean_rhythm_5_8
    expected = [true, false, true, true, false, true, true, false] # E(5,8)=[x . x x . x x .]
    # {run: 2, time: 0.0}
    #  └─ (ring true, false, true, false, true, true, false, true)
    actual = PetalLang::Parser.euclidean_rhythm(5, 8)
    assert_equal expected, actual
  end
end

class TestSoundParser < Test::Unit::TestCase
  def test_read
    s = PetalLang::Sound.new('bd', 0, 1)
    expected = [s]
    actual = PetalLang::Parser::SoundParser.instance.read('[bd]')
    assert_equal expected, actual
  end

  def test_process_token_bd
    s = PetalLang::Sound.new('bd', 0, 1)
    expected = s
    actual = PetalLang::Parser::SoundParser.instance.process_token('bd')
    assert_equal expected, actual
  end

  def test_process_token_bd_mul4
    s = PetalLang::Sound.new('bd', 0, 1)
    expected = [s, s, s, s]
    actual = PetalLang::Parser::SoundParser.instance.process_token('bd*4')
    assert_equal expected, actual
  end

  def test_process_token_bd_div4
    s = PetalLang::Sound.new('bd', 0, 4)
    expected = s
    actual = PetalLang::Parser::SoundParser.instance.process_token('bd/4')
    assert_equal expected, actual
  end

  def test_process_token_symbol
    s = PetalLang::Sound.new(:loop_garzul, 0, 1)
    expected = s
    actual = PetalLang::Parser::SoundParser.instance.process_token(`[` + ':loop_garzul' + ']')
    assert_equal expected, actual
  end

  def test_process_token_symbol_raw
    s = PetalLang::Sound.new(:loop_garzul, 0, 1)
    expected = s
    actual = PetalLang::Parser::SoundParser.instance.process_token(`[` + ':' + :loop_garzul.to_s + ']')
    assert_equal expected, actual
  end

  def test_process_token_bd_euc_5_8
    s = PetalLang::Sound.new('bd', 0, 1)
    r = PetalLang::Sound::REST
    expected = [s, r, s, s, r, s, s, r] # E(5,8)=[x . x x . x x .]
    actual = PetalLang::Parser::SoundParser.instance.process_token('bd(5,8)')
    assert_equal expected, actual
  end

  def test_process_token_bd_euc_5_8_index_3
    s = PetalLang::Sound.new('bd', 3, 1)
    r = PetalLang::Sound::REST
    expected = [s, r, s, s, r, s, s, r] # E(5,8)=[x . x x . x x .]
    actual = PetalLang::Parser::SoundParser.instance.process_token('bd:3(5,8)')
    assert_equal expected, actual
  end

  def test_process_token_bd_euc_5_8_1
    s = PetalLang::Sound.new('bd', 0, 1)
    r = PetalLang::Sound::REST
    # expected = [s, r, s, s, r, s, s, r] # E(5,8)=[x . x x . x x .]
    # `beat_rotations=1`で次のxまで進む模様
    expected = [s, s, r, s, s, r, s, r] # E(5,8,1)=[x x . x x . x .]
    actual = PetalLang::Parser::SoundParser.instance.process_token('bd(5,8,1)')
    assert_equal expected, actual
  end

  def test_process_token_bd_euc_5_8_2
    s = PetalLang::Sound.new('bd', 0, 1)
    r = PetalLang::Sound::REST
    # expected = [s, r, s, s, r, s, s, r] # E(5,8)=[x . x x . x x .]
    # `beat_rotations=1`で次のxまで進む模様
    expected = [s, r, s, s, r, s, r, s] # E(5,8,2)=[x . x x . x . x]
    actual = PetalLang::Parser::SoundParser.instance.process_token('bd(5,8,2)')
    assert_equal expected, actual
  end
end

class TestOptionParser < Test::Unit::TestCase
  def test_process_token_tilde
    expected = PetalLang::Option::REST
    actual = PetalLang::Parser::OptionParser.instance.process_token('~')
    assert_equal expected, actual
  end

  def test_process_token_int
    expected = PetalLang::Option.new('1', 1)
    actual = PetalLang::Parser::OptionParser.instance.process_token('1')
    assert_equal expected, actual
  end

  def test_process_token_int_negative
    expected = PetalLang::Option.new('-1', 1)
    actual = PetalLang::Parser::OptionParser.instance.process_token('-1')
    assert_equal expected, actual
  end

  def test_process_token_float
    expected = PetalLang::Option.new('0.5', 1)
    actual = PetalLang::Parser::OptionParser.instance.process_token('0.5')
    assert_equal expected, actual
  end

  def test_process_token_float_negative
    expected = PetalLang::Option.new('-0.5', 1)
    actual = PetalLang::Parser::OptionParser.instance.process_token('-0.5')
    assert_equal expected, actual
  end

  def test_process_token_float_euc_5_8_2
    s = PetalLang::Option.new('0.5', 1)
    r = PetalLang::Option::REST
    # expected = [s, r, s, s, r, s, s, r] # E(5,8)=[x . x x . x x .]
    # `beat_rotations=1`で次のxまで進む模様
    expected = [s, r, s, s, r, s, r, s] # E(5,8,2)=[x . x x . x . x]
    actual = PetalLang::Parser::OptionParser.instance.process_token('0.5(5,8,2)')
    assert_equal expected, actual
  end
end
