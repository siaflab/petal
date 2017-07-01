#!/usr/bin/ruby
# +++
# euclidean_rhythm.rb
#
#  Based on Python code publised at
#   https://github.com/brianhouse/bjorklund/
#   https://github.com/brianhouse/bjorklund/blob/c5eb5191073ebf05f21c3c09aa5874b55bd9b503/__init__.py
# ---
module EuclideanRhythm
  extend self
  def euclidean_rhythm(pulses, steps)
    steps = steps.to_i
    pulses = pulses.to_i

    pattern = []
    counts = []
    remainders = []
    divisor = steps - pulses

    remainders.push(pulses)
    level = 0

    loop do
      counts.push(divisor / remainders[level])
      remainders.push(divisor % remainders[level])
      divisor = remainders[level]
      level += 1
      break if remainders[level] <= 1
    end
    counts.push(divisor)

    pattern = build(level, counts, remainders, pattern)
    i = pattern.index(true)
    pattern = pattern.rotate(i)
  end

  def build(level, counts, remainders, pattern)
    if level == -1
      pattern.push(false)
    elsif level == -2
      pattern.push(true)
    else
      for i in 0...counts[level]
        pattern = build(level - 1, counts, remainders, pattern)
        end
      if remainders[level] != 0
        pattern = build(level - 2, counts, remainders, pattern)
      end
    end
    pattern
  end
end
