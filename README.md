# Petal
<img src="logo/p1.cfdg.png" alt="Petal logo" title="Petal" width="240" height="240" align="right" />

## About

_**Petal**_ is a small language on [Sonic Pi](http://sonic-pi.net/) with similar syntax to [TidalCycles](https://tidalcycles.org).

The primal motivation of this project is creating a language suitable for our _telecoding_ live performance of [space-moere](http://space-moere.org/) at [SIAF2017](http://siaf.jp/en/).

## Requirements

Sonic Pi v2.10 or later (v2.10, v2.11.1, v3.0.1)

## Installation

Download zip file from [Release Page](https://github.com/siaflab/petal/releases/) and extract it.

## Usage

Open an empty Sonic Pi buffer, type in the following code and hit `Run`.

```ruby
load "~/petal/petal.rb"   # the path you extract the file

d1 'bd'
```

## Tutorial

[Petal: the guilde](https://github.com/siaflab/petal/blob/master/patterns.md)

## Demo

https://twitter.com/kn1kn1/status/881498461635461121

## Examples

Here are some example code from our live performance of [space-moere](http://space-moere.org/).

space-moere #0 - Balloon

```ruby
load "~/petal/petal.rb"
d1"outdoor:2/2",rate:"rand -1 -0.125"
```

space-moere #1 - Landing

```ruby
load "~/petal/petal.rb"
cps 0.55
d1":bd_haus*4"
d2"sid(11,16,2)",n:'irand 1 11'
```

space-moere #2 - Clouds

```ruby
load "~/petal/petal.rb"
cps 0.55
d1":bd_klub(12,32) :bd_klub(12,32)",rate:"1.5 1",slow:8
d2"ul(11,16,3)",n:'irand 9'
```

space-moere #3 - Outer

```ruby
load "~/petal/petal.rb"
cps 0.55
d1"d(7,8,1)",n:'irand 3'
```
