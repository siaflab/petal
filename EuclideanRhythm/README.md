# EuclideanRhythm [![CircleCI](https://circleci.com/gh/kn1kn1/EuclideanRhythm.svg?style=svg)](https://circleci.com/gh/kn1kn1/EuclideanRhythm)

[Euclidean rhythm](https://en.wikipedia.org/wiki/Euclidean_rhythm) in Ruby

Based on the JavaScript code publised at

 - https://github.com/dbkaplun/euclidean-rhythm
 - https://github.com/dbkaplun/euclidean-rhythm/blob/d73eba635092acd4fee57f47d869d857613f0848/euclidean-rhythm.js

but also add the WORKAROUND of cases `steps - pulses == 1` for example,
 - E(2,3)=[x . x]
 - E(3,4)=[x . x x]
 - E(5,6)=[x . x x x x]

## Usage

You can find usage in ./euclidean_rhythm_test.rb

```ruby
require_relative './euclidean_rhythm.rb'

pattern = EuclideanRhythm.euclidean_rhythm(5, 16)
```

From irb

```shell
$ irb
2.3.0 :001 > require_relative './euclidean_rhythm.rb'
 => true
2.3.0 :002 > EuclideanRhythm.euclidean_rhythm(5, 16)
 => [true, false, false, true, false, false, true, false, false, true, false, false, true, false, false, false]
2.3.0 :003 >
```
