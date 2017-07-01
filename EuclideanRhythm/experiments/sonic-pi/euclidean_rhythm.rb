#!/usr/bin/ruby
# +++
# euclidean_rhythm.rb
#
#  Based on Ruby code publised at
#   https://github.com/samaaron/sonic-pi/
#   https://github.com/samaaron/sonic-pi/blob/v2.10.0/app/server/sonicpi/lib/sonicpi/lang/core.rb#L441-L468
# ---
module EuclideanRhythm
  extend self
  def euclidean_rhythm(pulses, steps)
    steps = steps.to_i
    pulses = pulses.to_i

    return [true] * steps if pulses >= steps

    # https://github.com/samaaron/sonic-pi/blob/v2.10.0/app/server/sonicpi/lib/sonicpi/lang/core.rb#L441-L468
    num_accents = pulses
    size = steps

    res = []
    size.times do |i|
      # makes a boolean based on the index
      # true is an accent, false is a rest
      res << ((i * num_accents % size) < num_accents)
    end

    res
  end
end
