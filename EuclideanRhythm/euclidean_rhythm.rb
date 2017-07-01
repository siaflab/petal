#!/usr/bin/ruby
# +++
# euclidean_rhythm.rb
#
#  Based on JavaScript code publised at
#   https://github.com/dbkaplun/euclidean-rhythm
#   https://github.com/dbkaplun/euclidean-rhythm/blob/d73eba635092acd4fee57f47d869d857613f0848/euclidean-rhythm.js
#
#  but also add the WORKAROUND for cases `steps - pulses == 1`
#   - E(2,3)=[x . x]
#   - E(3,4)=[x . x x]
#   - E(5,6)=[x . x x x x]
# ---
module EuclideanRhythm
    extend self
    def euclidean_rhythm(pulses, steps)
        steps = steps.to_i
        pulses = pulses.to_i

        return [true] * steps if pulses >= steps

        if steps - pulses == 1
            # WORKAROUND for the following cases
            #  E(2,3)=[x . x]
            #  E(3,4)=[x . x x]
            #  E(5,6)=[x . x x x x]
            pat = [true] * steps
            pat[1] = false
            return pat
        end

        groups = []
        for i in 0...steps
            val = i < pulses ? true : false
            groups.push([val])
        end

        while (l = groups.count - 1) != 0
            ub = 0
            first = groups[0]
            ub += 1 while first == groups[ub]
            break if ub >= l

            lb = l
            last = groups[l]
            lb -= 1 while last == groups[lb]
            break if lb <= 0

            count = [ub, l - lb].min
            groups = groups[0..(count - 1)]
                     .each_with_index.map { |e, i| e.concat(groups[l - i]) }
                     .concat(groups[count..(-count - 1)])
        end
        groups.flatten
    end
end
