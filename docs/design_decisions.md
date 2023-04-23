# Design decisions

Support for understanding the program.

# Behavior of show when not calling all the necessary comparisons for a valid bone age

If show is called and the target radiography has not been compared with all the atlas radiographies, then an error takes place. This is to make sure that.

## On comparison between radiographies that have different bones or between bones that have different measurements

If either case happens and error takes place, otherwise the comparisons might get confusing.

## Changing comparison level during bone level comparison

One can especify bone level comparisons and then at any time call a <code>compare :radiography</code> or a <code>compare :all</code>, What to do in those cases? Well, I decided to reset the bone level comparison and do the other types of comparison instead:

```ruby
# radiography with radius, ulna, cavicle and other bones
(...)
comparisons
compare :radius
compare :ulna
compare :radiography # forced whole radiography comparison, completely substitutes current bone level comparison
show
```

## Decide needs to be called to conclude bone level comparison
