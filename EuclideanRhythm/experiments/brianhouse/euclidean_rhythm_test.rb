require 'test/unit'
require_relative './euclidean_rhythm.rb'

class TestBjorklund < Test::Unit::TestCase
    # The following test cases are based on 26 rhythm patterns described in
    #  `4. Euclidean Rhythms in Traditional World Music`
    # of
    #  `The Euclidean algorithm generates traditional musical rhythms by
    #  G. T. Toussaint, Proceedings of BRIDGES: Mathematical Connections in Art,
    #  Music, and Science, Banff, Alberta, Canada, July 31 to August 3, 2005,
    #  pp. 47–56.`
    #   http://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf

    # E(1,2)= [x .]
    def test_1_2
        expected = [true, false]
        actual = EuclideanRhythm.euclidean_rhythm(1, 2)
        assert_equal expected, actual
    end

    # E(1,3)= [x . .]
    def test_1_3
        expected = [true, false, false]
        actual = EuclideanRhythm.euclidean_rhythm(1, 3)
        assert_equal expected, actual
    end

    # E(1,4)= [x . . .]
    def test_1_4
        expected = [true, false, false, false]
        actual = EuclideanRhythm.euclidean_rhythm(1, 4)
        assert_equal expected, actual
    end

    # E(4,12) = [x . . x . . x . . x . .]
    def test_4_12
        expected = [true, false, false, true, false, false, true, false, false, true, false, false]
        actual = EuclideanRhythm.euclidean_rhythm(4, 12)
        assert_equal expected, actual
    end

    # https://github.com/brianhouse/bjorklund/
    # でも
    # http://dbkaplun.github.io/euclidean-rhythm/
    # でも[x x .]が返ってしまう
    # E(2,3)=[x . x]
    def test_2_3
        expected = [true, false, true]
        actual = EuclideanRhythm.euclidean_rhythm(2, 3)
        assert_equal expected, actual
    end

     # E(2,5)=[x . x . .]
    def test_2_5
        expected = [true, false, true, false, false]
        actual = EuclideanRhythm.euclidean_rhythm(2, 5)
        assert_equal expected, actual
    end

    # https://github.com/brianhouse/bjorklund/
    # でも
    # http://dbkaplun.github.io/euclidean-rhythm/
    # でも[x x x .]が返ってしまう
    def test_3_4
        expected = [true, false, true, true] # E(3,4)=[x . x x]
        actual = EuclideanRhythm.euclidean_rhythm(3, 4)
        assert_equal expected, actual
    end

    # E(3,5)=[x . x . x]
    def test_3_5
        expected = [true, false, true, false, true]
        actual = EuclideanRhythm.euclidean_rhythm(3, 5)
        assert_equal expected, actual
    end

    # E(3,7)=[x . x . x . .]
    def test_3_7
        expected = [true, false, true, false, true, false, false]
        actual = EuclideanRhythm.euclidean_rhythm(3, 7)
        assert_equal expected, actual
    end

    # E(3,8)=[x . . x . . x .]
    def test_3_8
        expected = [true, false, false, true, false, false, true, false]
        actual = EuclideanRhythm.euclidean_rhythm(3, 8)
        assert_equal expected, actual
    end

    # E(4,7)=[x . x . x . x]
    def test_4_7
        expected = [true, false, true, false, true, false, true]
        actual = EuclideanRhythm.euclidean_rhythm(4, 7)
        assert_equal expected, actual
    end

    #E(4,9) = [x . x . x . x . .]
    def test_4_9
        expected = [true, false, true, false, true, false, true, false, false]
        actual = EuclideanRhythm.euclidean_rhythm(4, 9)
        assert_equal expected, actual
    end

    # E(4,11) = [x . . x . . x . . x .]
    def test_4_11
        expected = [true, false, false, true, false, false, true, false, false, true, false]
        actual = EuclideanRhythm.euclidean_rhythm(4, 11)
        assert_equal expected, actual
    end

    # https://github.com/brianhouse/bjorklund/
    # でも
    # http://dbkaplun.github.io/euclidean-rhythm/
    # でも[x x x x x .]が返ってしまう
    # E(5,6)=[x . x x x x]
    def test_5_6
        expected = [true, false, true, true, true, true]
        actual = EuclideanRhythm.euclidean_rhythm(5, 6)
        assert_equal expected, actual
    end

    # E(5,7)=[x . x x . x x]
    def test_5_7
        expected = [true, false, true, true, false, true, true]
        actual = EuclideanRhythm.euclidean_rhythm(5, 7)
        assert_equal expected, actual
    end

    # E(5,8)=[x . x x . x x .]
    def test_5_8
        expected = [true, false, true, true, false, true, true, false]
        actual = EuclideanRhythm.euclidean_rhythm(5, 8)
        assert_equal expected, actual
    end

    # E(5,9)=[x . x . x . x . x]
    def test_5_9
        expected = [true, false, true, false, true, false, true, false, true]
        actual = EuclideanRhythm.euclidean_rhythm(5, 9)
        assert_equal expected, actual
    end

    # E(5,11)=[x . x . x . x . x . .]
    def test_5_11
        expected = [true, false, true, false, true, false, true, false, true, false, false]
        actual = EuclideanRhythm.euclidean_rhythm(5, 11)
        assert_equal expected, actual
    end

    # E(5,12) = [x . . x . x . . x . x .]
    def test_5_12
        expected = [true, false, false, true, false, true, false, false, true, false, true, false]
        actual = EuclideanRhythm.euclidean_rhythm(5, 12)
        assert_equal expected, actual
    end

    # E(5,16) = [x . . x . . x . . x . . x . . . .]
    def test_5_16
        expected = [true, false, false, true, false, false, true, false, false, true, false, false, true, false, false, false]
        actual = EuclideanRhythm.euclidean_rhythm(5, 16)
        assert_equal expected, actual
    end

    # E (7,8) = [x . x x x x x x]
    def test_7_8
        expected = [true, false, true, true, true, true, true, true]
        actual = EuclideanRhythm.euclidean_rhythm(7, 8)
        assert_equal expected, actual
    end

    # E(7,12) = [x . x x . x . x x . x .]
    def test_7_12
        expected = [true, false, true, true, false, true, false, true, true, false, true, false]
        actual = EuclideanRhythm.euclidean_rhythm(7, 12)
        assert_equal expected, actual
    end

    # E(7,16) = [x . . x . x . x
    #            . . x . x . x .]
    def test_7_16
        expected = [true, false, false, true, false, true, false, true,
                    false, false, true, false, true, false, true, false]
        actual = EuclideanRhythm.euclidean_rhythm(7, 16)
        assert_equal expected, actual
    end

    # E(9,16) = [x . x x . x . x
    #            . x x . x . x .]
    def test_9_16
       expected = [true, false, true, true, false, true, false, true,
                   false, true, true, false, true, false, true, false]
       actual = EuclideanRhythm.euclidean_rhythm(9, 16)
       assert_equal expected, actual
    end

    # E(11,24) = [x . . x . x . x
    #             . x . x . . x .
    #             x . x . x . x .]
    def test_11_24
       expected = [true, false, false, true, false, true, false, true,
                   false, true, false, true, false, false, true, false,
                   true, false, true, false, true, false, true, false]
       actual = EuclideanRhythm.euclidean_rhythm(11, 24)
       assert_equal expected, actual
    end

    # E(13,24) = [x . x x . x . x
    #             . x . x . x x .
    #             x . x . x . x .]
    def test_13_24
       expected = [true, false, true, true, false, true, false, true,
                   false, true, false, true, false, true, true, false,
                   true, false, true, false, true, false, true, false]
       actual = EuclideanRhythm.euclidean_rhythm(13, 24)
       assert_equal expected, actual
    end
end
