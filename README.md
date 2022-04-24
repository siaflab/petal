# Petal [![CircleCI](https://circleci.com/gh/siaflab/petal.svg?style=svg)](https://circleci.com/gh/siaflab/petal)
<img src="logo/p1.cfdg.png" alt="Petal logo" title="Petal" width="240" height="240" align="right" />

## About

_**Petal**_ is a small language on [Sonic Pi](http://sonic-pi.net/) with similar syntax to [TidalCycles](https://tidalcycles.org).

The primal motivation of this project is creating a language suitable for our _telecoding_ live performance of [space-moere](https://space-moere.org/) at [SIAF2017](https://siaf.jp/2017/).

## Requirements

Sonic Pi v2.10 or later (v2.10, v2.11.1, v3.0.1, v3.1.0, v3.3.1)

## Installation

Download zip file from [Release Page](https://github.com/siaflab/petal/releases/) and extract it.

## Usage

Open an empty Sonic Pi buffer, type in the following code and hit `Run`.

```ruby
require "~/petal/petal.rb"   # the path you extract the file
d1 'bd'
```

## Tutorial

[Petal: the guide](https://github.com/siaflab/petal/blob/master/patterns.md)

## Examples

#### My demo
https://twitter.com/kn1kn1/status/881498461635461121

```ruby
require "~/petal/petal.rb"
cps 0.55

d1 ":bd_klub(11,16)", amp: 3
d2 ":bd_haus(6,16)", amp: 4
d3 "hh(13,16)", n: 0, amp: 4, rate: 'rand -1 1', pan: 'rand -1 1'
d4 "if(5,16)", n: 'irand 64', amp: 3
d5 "if(11,16,2)", n: 'irand 64',
  rate: 'rand -1 1', pan: 'rand -0.2 0.2', amp: 3
```

#### Code by Sanju ([@papa_oom_mowmow](https://twitter.com/papa_oom_mowmow/), [@jsanjuan83](https://github.com/jsanjuan83))
https://twitter.com/papa_oom_mowmow/status/903943411052552193

```ruby
require "~/petal/petal.rb"
cps 2.5/6

use_bpm get_bpm * 2
live_loop :paul do
  d1 "hh*2 808:2(3,4) ~ ~"
  with_fx :echo, phase: [2.5, 1.0, 0.5].ring.tick / 6, mix: 1 do
    with_fx :krush, cutoff: 90 do
      d2 "[bd d d ~] cp:3"
    end
  end
  sleep 16
end

live_loop :ringo do
  sleep 4
end

live_loop :john, sync: :ringo do
  use_random_seed 1000
  32.times do
    with_fx :lpf, cutoff: 60 do
      with_fx :slicer, amp_min: 0.4, wave: 2 do
        synth :saw, note: (chord :d3, :augmented, num_octaves: 3).choose, release: 4.5 unless one_in 3
        sleep 0.25
      end
    end
  end
end

live_loop :chris, sync: :ringo do
  sleep [0, 4].choose
  with_fx :echo, decay: [8,12].choose, phase: [0.25,0.5].choose do
    sample :drum_splash_hard, rate: -1, amp: 0.3, lpf: 110
  end
  sleep 8
end
```

#### My livecoding performance at Algorave Tokyo 2018 August
https://twitter.com/h3xl3r/status/1031194838874509312

```ruby
# Algorave Tokyo 2018-08-19
#  Kenichi Kanai @kn1kn1
require "~/petal/petal.rb"; cps 1; d9; use_bpm get_bpm

live_loop :l5, sync: :d0 do
  with_fx :pitch_shift, pitch: 12, window_size: [0.001, 0.005, 0.01].choose do
    with_fx :distortion do
      d1 "tech(11,16)", slow: 2, rate: 1, amp: 1, n: "irand 64"
      d2 "sf(7,16,1)", slow: 2, rate: 1, amp: 0.5, n: "irand 64", pan: "rand -0.5 0.5"
      d4 "peri(3,16,1)", slow: 2, rate: 1, amp: 0.5, n: "irand 64", pan: "rand -0.5 0.5"
      d5 "perc(3,16,2)", slow: 2, rate: 1, amp: 0.5, n: "irand 64", pan: "rand -0.5 0.5"
      d6 "ifdrums(9,16,2)", slow: 2, rate: 1, amp: 0.75, n: "irand 64", pan: "rand -0.5 0.5"
      d7 "jazz(3,16,1)", slow: 2, rate: 1, amp: 0.5, n: "irand 64", pan: "rand -0.5 0.5"
      d8 "ul(3,16,3)", slow: 2, rate: 1, amp: 0.5, n: "irand 64", pan: "rand -0.5 0.5"
      d3 :bd_haus, slow: 4
    end
    sleep 7
  end
end
```

See https://github.com/kn1kn1/algorave.tokyo_2018-aug-19 for more code.

#### Some code from our live performance of [space-moere](https://space-moere.org/).

space-moere #0 - Balloon

```ruby
require "~/petal/petal.rb"
d1"outdoor:2/2",rate:"rand -1 -0.125"
```

space-moere #1 - Landing

```ruby
require "~/petal/petal.rb"
cps 0.55
d1":bd_haus*4"
d2"sid(11,16,2)",n:'irand 1 11'
```

space-moere #2 - Clouds

```ruby
require "~/petal/petal.rb"
cps 0.55
d1":bd_klub(12,32) :bd_klub(12,32)",rate:"1.5 1",slow:8
d2"ul(11,16,3)",n:'irand 9'
```

space-moere #3 - Outer

```ruby
require "~/petal/petal.rb"
cps 0.55
d1"d(7,8,1)",n:'irand 3'
```
