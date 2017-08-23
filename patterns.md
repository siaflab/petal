# Petal: the guide

For the language specification of Petal is subset of that of TidalCycles, the following guide is based on [Tidal: the guide](https://tidalcycles.org/patterns.html) and rewritten for Petal.

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

You can also specify Sonic Pi builtin sample as a sample name:
```ruby
d1 :bd_haus
```

#### Sequences From Multiple Samples

Putting things in quotes allows you to define a sequence. For example, the following gives you a pattern of kick drum then snare:

```ruby
d1 "bd sd:3"
```

When you run the code above, you are replacing the previous pattern with another one on-the-fly. Congratulations, you’re live coding.

#### Rests

So far we have produced patterns that keep producing more and more sound. What if you want a rest, or gap of silence, in your pattern? You can use the “tilde” `~`` character to do so:

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

You can also use `bpm` (beat per minute) or `bps` (beat per second) for specifing the cycle's duration.

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

### Silence

#### Silence

At this point you probably want to know how to stop the patterns you started. An empty pattern is defined as silence, so if you want to ‘switch off’ a pattern, you can just set it to that:

```ruby
d1 :silence
```

Or you can stop the loop by just passing empty argument to the function.

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


### Patterns Within Patterns
##### Pattern Groups

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

### Pattern Repetition and Speed
#### Repetition

There are two short-hand symbols you can use inside patterns to speed things up or slow things down: `*` and `/`. You could think of these like multiplication and division.

Use the `*` symbol to make a pattern, or part of a pattern, repeat as many times as you’d like:

```ruby
d1 $ sound "bd*2"
```

    This is the same as doing d1 "bd bd"

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
