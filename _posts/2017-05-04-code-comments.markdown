---
layout: post
title:  'Why You Should Document the "Why" Behind Your Code'
date:   2017-05-04 12:55:14
categories: code documentation best-practices
---

## Why is More Important that What

There are two key aspects to understanding code. The first is identifying _what_ it does. Any good developer should be able to look at code and figure out what it does. If there is no documentation or the code is a mess then it might be a real challenge, but it is still possible. The other aspect is identifying _why_ the code does what it does, and this the most important part! Discerning the reasons about why code was written in a particular manner, however, may be impossible if the developer left no explanation about its context.

Good documentation communicates both the _what_ and _why_ of the code. However, I find that while developers are often good at commenting about what their code is and what it does, they just as often fail to explain why it is that way. Let me illustrate how good comments can really impact the way in which someone understands your code.

## A Real-Life Example

Here is a small example, in Ruby, I pulled from a project my team has been working on. The diligent author of this snippet left some good comments, but for now let's take a look at it without the comments.

```ruby
def key
  (@key || name.upcase).to_sym
end
```

This little method seems pretty innocent. It should be easy to understand what is going on if you are fluent in Ruby, and perhaps even if you are not. The value of either `@key` or `name` (converted to all-uppercase letters) will be converted to a Symbol (to_sym) and returned.

The value `name` is apparently a String. But why is it being converted to a Symbol? There is that magic word—_Why?_

Let's add in one of the comments.

```ruby
def key
  (@key || name.upcase).to_sym  # Should return a symbol for comparison with the argument to const_missing, which is a symbol.
end
```

The comment tells us that the return value will be used in a comparison with another Symbol. We can probably infer from that comment that the comparison will fail if we return a String value. Sure, things could have been coded differently, but now we know why the original developer was converting the String to a Symbol.

There was another informative comment. Here it is in the original code snippet.

```ruby
def key
  # If @key is not set then it should _not_ be memoized with the value of
  # `name` because `key?` should still return a falsey value in that case.
  (@key || name.upcase).to_sym  # Should return a symbol for comparison with the argument to const_missing, which is a symbol.
end
```

This most-recently added comment talks about why a value should not be assigned to `@key`, which would fit a common pattern found in other methods in the surrounding code. This seems like a piece of sage advice. Some developer probably encountered a problem with this in the past. _Note: I checked and there was a test covering this incorrect memoization case. Hurray!_

## Comments Are of Great Worth

This example is a good example of documenting the _why_ of your code. The reasons explained in the comments were not apparent at first glance, and I likely would have only discovered them by making a breaking change. Such small comments have tremendous value—even more so if you consider the time they saved me from having to figure out or experience things for myself.

Each time I review someone else's work my goal is to quickly identify the _what_ and _why_ of the code. If I cannot do so easily then I will request clarification—normally in the form of code comments—before I approve the changes.

## Only You Can Prevent Poor Documentation

I have also learned to step back and look at my own code. Will another person understand it? Will her or she need to know why I have made these changes? I know that taking a short time to write documentation now can save a greater amount of time in the future and that is just as valuable as the code which is documented. When another person asks me a question about my code I recognize it as failure on my part to thoroughly document my work. Often times I will set aside what I am doing to immediately update my comments and documentation. Seriously. It is _that_ important.

If you feel a pang of guilt because you have not documented your code like you should, do not worry! Now is the time to start doing things the right way. Make a habit of asking "what?" and "why?" as you write and review code, and fix undocumented places as you find them. Soon you will have a well-documented code base.
