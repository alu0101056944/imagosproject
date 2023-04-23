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

## Context switches on DSLBoneAge

A variable keeps track of current context and there are specific method calls that change that context. When a context is entered, it gets or sets the required information. Rest of the methods just call one method or another depending on the context.

All contexts have a begin and end, but DSLAtlas has a special case where <code>atlas :create (...)</code> is called, in which case the context stays the same as long as no other context change method is called.

This has consecuencies for radiography method call, which would stay as DSL Atlas's call as long as no create or other context change method; radiography is context change method unless in dsl atlas context.

Nil context can take place, which is the global context.
