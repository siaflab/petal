# Petal: the guide

For the language specification of Petal is a subset of that of TidalCycles, the following guide is based on [Tidal: the guide](https://tidalcycles.org/patterns.html) and rewritten for Petal.

## Table of Contents

* [Creating Rhythmic Sequences](#creating-rhythmic-sequences)
  * [Sequences](#sequences)
    * [Play a Single Sample](#play-a-single-sample)
    * [Sequences From Multiple Samples](#sequences-from-multiple-samples)
    * [Rests](#rests)
    * [Playing More Than One Sequence](#playing-more-than-one-sequence)
    * [What is a Cycle?](#what-is-a-cycle)
    * [Silence](#silence)
    * [Pattern Groups](#pattern-groups)
    * [Pattern Repetition and Speed](#pattern-repetition-and-speed)
* [Using Options](#using-options)
  * [Options](#options)
    * [Options are patterns too](#options-are-patterns-too)
    * [Option pattern order (Left\-most option pattern)](#option-pattern-order-left-most-option-pattern)
  * [Option Specifications](#option-specifications)
    * [gain/amp](#gainamp)
    * [speed/rate](#speedrate)
    * [slow, fast/density](#slow-fastdensity)
    * [stretch](#stretch)
  * [Randomness](#randomness)
    * [Random Decimal Patterns](#random-decimal-patterns)
    * [Random Integer Patterns](#random-integer-patterns)
* [Euclidean Sequences](#euclidean-sequences)
  * [Bjorklund](#bjorklund)
* [Effects](#effects)
  * [Using Sonic Pi's built\-in with\_fx block](#using-sonic-pis-built-in-with_fx-block)
  * [Effects and the performance](#effects-and-the-performance)
* [Sync](#sync)
  * [Sync with another liveloop running outside of Petal](#sync-with-another-liveloop-running-outside-of-petal)
  * [Sync with another computer running Petal](#sync-with-another-computer-running-petal)

## Creating Rhythmic Sequences
### Sequences
#### Play a Single Sample
Petal starts with nine live_loops (or 'connections' in Tidal words), named from `d1` to `d9`. Here’s a minimal example, that plays a kick drum every cycle:
```ruby
d1 "bd"
```

Samples live inside the `Dirt-Samples` folder which came with Petal, and each sub-folder under that corresponds to a sample name (like `bd`).

We can pick a different sample in the `bd` folder by adding a colon (`:`) then a number. For example, this picks the fourth kick drum (it counts from zero, so `:3` gives you the fourth sound in the folder):

```ruby
d1 "bd:3"
```

If you specify a number greater than the number of samples in a folder, then Petal just “wraps” around back to the first sample again (it starts counting at zero, e.g. in a folder with five samples, `bd:5` would play `bd:0`).

It’s also possible to specify the sample number separately:

```ruby
d1 "bd", n: "3"
```

You can also specify Sonic Pi built-in sample as a sample name:
```ruby
d1 :bd_haus
```

#### Sequences From Multiple Samples

Putting things in quotes allows you to define a sequence. For example, the following gives you a pattern of kick drum then snare:

```ruby
d1 "bd sd:3"
```

#### Rests

So far we have produced patterns that keep producing more and more sound. What if you want a rest, or gap of silence, in your pattern? You can use the “tilde” `~` character to do so:

```ruby
d1 "bd bd ~ bd"
```

Think of the ~ as an ‘empty’ step in a sequence, that just produces silence.

#### Playing More Than One Sequence

The easiest way to play multiple sequences at the same time is to use two or more live_loops:
```ruby
d1 "bd sd:1"
d2 "hh hh hh hh"
d3 "arpy"
```

#### What is a Cycle?

A cycle is the main “loop” of time in Petal. The cycle repeats forever in the background, even when you’ve stopped samples from playing. The cycle’s duration always stays the same unless you modify it with `cps`, we’ll cover this later. By default, there is one cycle per second.

The following code slows all sequences.

```ruby
cps 0.5
```

You can also use `bpm` (beat per minute) or `bps` (beat per second) for specifying the cycle's duration.

```ruby
bpm 120
```

```ruby
bps 2
```

The relationship of these functions can be described as follows:

```
cps(1) == bpm(120) == bps(120/60)
```

#### Silence

At this point you probably want to know how to stop the patterns you started. An empty pattern is defined as silence, so if you want to ‘switch off’ a pattern, you can just set it to that:

```ruby
d1 :silence
```

Or you can stop the loop by just passing an empty argument to the function.

```ruby
d1
```

If you want to set all the connections (from `d1` to `d9`) to be silent at once, there’s a single-word shortcut for that:

```
hush
```

You can also isolate a single connection and silence all others with the `solo` function:

```ruby
solo :d1, "bd sn"
```

Please note that you need to specify the connection name as a ruby symbol (from `:d1` to `:d9`).

#### Pattern Groups

You can use Tidal’s square brackets syntax in Petal to create a pattern grouping:

```ruby
d1 "[bd sd sd] cp"
```

Square brackets allow several events to be played inside of a single step. You can think of the above pattern as having two steps, with the first step broken down into a subpattern, which has three steps. Practically, this means you can create denser sub-divisions of cycles:

```ruby
d1 "bd [sd sd]"
d1 "bd [sd sd sd]"
d1 "bd [sd sd sd sd]"
d1 "[bd bd] [sd sd sd sd]"
d1 "[bd bd bd] [sd sd]"
d1 "[bd bd bd bd] [sd]"
```

You can even nest groups inside groups to create increasingly dense and complex patterns:

```ruby
d1 "[bd bd] [bd [sd [sd sd] sd] sd]"
```

#### Pattern Repetition and Speed

There are two short-hand symbols you can use inside patterns to speed things up or slow things down: `*` and `/`. You could think of these like multiplication and division.

Use the `*` symbol to make a pattern, or part of a pattern, repeat as many times as you’d like:

```ruby
d1 "bd*2"
```

This is the same as doing `d1 "bd bd"`.

The code above uses `*2` to make a sample play twice.

You can use the `/` symbol to make a part of a pattern slow down, or occur less often:

```ruby
d1 "bd/2"
```

The code above uses /2 to make a sample play half as often, or once every 2nd cycle.

Using different numbers works as you’d expect:

```ruby
d1 "bd*3" # plays the bd sample three times each cycle
```

```ruby
d1 "bd/3" # plays the bd samples only once each third cycle
```

## Using Options

### Options

You use an option by adding the ruby hash option after your sound pattern:

```ruby
d1 "bd*4", amp: 1.2
```

The above code changes volume by adding `amp: 1.2`.

#### Options are patterns too

You may notice that the values of effects are specified in double quotes. This means that you can pattern the option values too:

```ruby
d1 "bd*4", amp: "1 0.8 0.5 0.7"
```

The above `amp` option changes how loud the sample is, good for patterns of emphasis as above. Option patterns follow all the same grouping rules as sound patterns:

```ruby
d1 "bd*4 sn*4", amp: "0.6 [1 0.8 0.5 0.7]"
```

#### Option pattern order (Left-most option pattern)

You can specify the option before the sound pattern:

```ruby
d1 amp: "1 0.8 0.5 0.7", sound: "bd"
```

The order that you put things matters; the structure of the pattern is given by the pattern on the left-most option. In this case, only one `bd` sound is given, but you hear four, because the structure comes from the `amp` pattern on the left-most.

### Option Specifications

Petal has several options that you can apply to sounds. Here is a quick list of the options you can use in Petal:

* `gain`/`amp` (changes volume, values from 0 to 1)
* `pan` (pans sound left and right, values from -1 to 1)
* `speed`/`rate` (changes playback speed of a sample)
* `slow`,`fast`/`density` (changes playback speed of a pattern)
* `stretch` (fits a sample to the cycle duration)

#### gain/amp

You can change the volume of a sample by using the `gain` or `amp` option.

```ruby
d1 "bd*4", amp: 1.2
```

You can specify a number as a volume of `gain`/`amp` option.

#### speed/rate

You can change the playback speed of a 'sample' by using the `speed` or `rate` option. You can use `speed`/`rate` to change pitches, to create a weird effect, or to match the length of a sample to a specific period of the cycle time (but see the `stretch` option for an easy way of doing the latter).

You can set a sample’s speed by using the `speed`/`rate` option with a number.

* `speed: "1"` plays a sample at its original speed
* `speed: "0.5"` plays a sample at half of its original speed
* `speed: "2"` plays a sample at double its original speed

```ruby
d1 "arpy", speed: "1"
```

```ruby
d1 "arpy", speed: "0.5"
```

```ruby
d1 "arpy", speed: "2"
```

Just like other options, you can specify a pattern for speed:

```ruby
d1 speed: "1 0.5 2 1.5", sound: "arpy"
```

You can also reverse a sample by specifying negative values:

```ruby
d1 speed: "-1 -0.5 -2 -1.5", sound: "arpy"
```

#### slow, fast/density

You can also slow down or speed up the playback of a 'pattern', this makes it a quarter of the speed:

```ruby
d1 "bd*2 [bd [sn sn*2 sn] sn]", slow: 4
```

And this four times the speed:

```ruby
d1 "bd*2 [bd [sn sn*2 sn] sn]", fast: 4
```

Note that `slow: 0.25` would do exactly the same as `fast: 4`.

#### stretch

You can fit a sample to the cycle duration by using `stretch` option:

```ruby
d1 :loop_breakbeat, slow: 2, stretch: :b
```

* `stretch: :b`  This does not keep the pitch constant and is essentially the same as modifying the rate directly.
* `stretch: :p`  This attempts to keep the pitch constant.

### Randomness

Petal can produce random patterns of integers and decimals.

#### Random Decimal Patterns

You can use the `rand` function to create a random value between 0 and 1. This is useful for effects:

```ruby
d1 "arpy*4", amp: "rand"
```

The maximum value that rand give you can be specified, for example the below gives random numbers between 0 and 2:

```ruby
d1 "arpy*4", amp: "rand 2"
```

The values that rand give you can be also scaled, for example the below gives random numbers between -1 and 1:

```ruby
d1 "arpy*4", pan: "rand -1 1"
```

#### Random Integer Patterns

Use the irand function to create a random integer up to a given maximum. The most common usage of `irand` is to produce a random pattern of sample indices:

```ruby
d1 "arpy*8", n: "irand 30"
```
The code above randomly chooses from 30 samples in the “arpy” folder.

The values that rand give you can be ranged, for example the below gives random integer between 8 and 12:

```ruby
d1 "arpy(9,16,1)", n: 'irand 8 12'
```

## Euclidean Sequences
### Bjorklund

If you give two numbers in parenthesis after an element in a pattern, then Petal will distribute the first number of sounds equally across the second number of steps:

```ruby
d1 "bd(5,8)"
```
You can use the parenthesis notation within a single element of a pattern:

```ruby
d1 "bd(3,8) sn*2"
```

```ruby
d1 "bd(3,8) sn(5,8)"
```

You can also add a third parameter, which ‘rotates’ the pattern so it starts on a different step:

```ruby
d1 "bd(5,8,2)"
```

These types of sequences use “Bjorklund’s algorithm”, which wasn’t made for music but for an application in nuclear physics, which is exciting. More exciting still is that it is very similar in structure to the one of the first known algorithms written in Euclid’s book of elements in 300 BC. You can read more about this in the paper ["The Euclidean Algorithm Generates Traditional Musical Rhythms"](http://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf) by Toussaint. Some examples from this paper are included below, including rotation in some cases.

* (2,5) : A thirteenth century Persian rhythm called Khafif-e-ramal.
* (3,4) : The archetypal pattern of the Cumbia from Colombia, as well as a Calypso rhythm from Trinidad.
* (3,5,2) : Another thirteenth century Persian rhythm by the name of Khafif-e-ramal, as well as a Rumanian folk-dance rhythm.
* (3,7) : A Ruchenitza rhythm used in a Bulgarian folk-dance.
* (3,8) : The Cuban tresillo pattern.
* (4,7) : Another Ruchenitza Bulgarian folk-dance rhythm.
* (4,9) : The Aksak rhythm of Turkey.
* (4,11) : The metric pattern used by Frank Zappa in his piece titled Outside Now.
* (5,6) : Yields the York-Samai pattern, a popular Arab rhythm.
* (5,7) : The Nawakhat pattern, another popular Arab rhythm.
* (5,8) : The Cuban cinquillo pattern.
* (5,9) : A popular Arab rhythm called Agsag-Samai.
* (5,11) : The metric pattern used by Moussorgsky in Pictures at an Exhibition.
* (5,12) : The Venda clapping pattern of a South African children’s song.
* (5,16) : The Bossa-Nova rhythm necklace of Brazil.
* (7,8) : A typical rhythm played on the Bendir (frame drum).
* (7,12) : A common West African bell pattern.
* (7,16,14) : A Samba rhythm necklace from Brazil.
* (9,16) : A rhythm necklace used in the Central African Republic.
* (11,24,14) : A rhythm necklace of the Aka Pygmies of Central Africa.
* (13,24,5) : Another rhythm necklace of the Aka Pygmies of the upper Sangha.

## Effects
### Using Sonic Pi's built-in `with_fx` block

You can use Sonic Pi's built-in `with_fx` block from Petal v1.1.0.

```ruby
with_fx :reverb, room: 1 do
  d1 "arpy(3,8)"
end
```

You can also configure or remove the effects.

```ruby
with_fx :reverb, room: 1, mix: 0.6 do
  d1 "arpy(3,8)"
end
```

```ruby
d1 "arpy(3,8)"
```

### Effects and the performance

Every time you `Run` the Petal code, Petal creates a new live_loop to apply the effects to a fresh live_loop environment. This will take some cost for the performance. If you won't use effects and you want to make the code more efficient, this feature can be off with `use_fx_with_petal` function.

```ruby
use_fx_with_petal false
d1 "arpy(3,8)"
```

## Sync
### Sync with another liveloop running outside of Petal

You can sync with another liveloop by syncing the `:d0` liveloop and also sync bpm by using method `get_bpm`.

```ruby
bpm 200

d1 'bd'

live_loop :l0, sync: :d0 do # sync with :d0 (Petal's master loop name)
  use_bpm get_bpm # retrieve bpm value by get_bpm method defined in petal.rb
  play 45
  sleep 1
end
```

### Sync with another computer running Petal

There's no special mechanism to automatically sync with another computer running Petal, but you can manually sync them by shifting the beat on one computer with `set_sched_ahead_time!` function.

```ruby
set_sched_ahead_time! 0.84  # Configure this argument to sync the beat.
d1 :bd_haus
```
