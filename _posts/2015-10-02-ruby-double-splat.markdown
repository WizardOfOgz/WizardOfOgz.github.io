---
layout: post
title:  "Ruby: Diving Deep with Double-Splat (**)"
date:   2015-10-02 17:42:29
categories: ruby
---

The double-splat (**) was added to Ruby back when version 2.0 was released, but it seems to have
gained very little attention since then. Perhaps it was simply overshadowed by the more-heralded
features like lazy enumerators, keyword arguments and Module#prepend, which also arrived in the
same version of Ruby. However, the double-splat is a very powerful little feature which can work
wonders in tidying up your code.

Simply put, the double-splat is to Hashes what the splat (*) is to Arrays. It picks up trailing
Hash arguments when used in a method signature, and it decomposes a Hash when applied to a method
parameter. Another great feature of the double-splat is that you can use it to "merge" Hash
arguments, eliminating the need to call `#merge` explicitly.

Both the splat and double-splat can appear together in the same parameter list. Keyword arguments
allow us to specify keys which should _not_ be captured by the double-splat but rather assigned
to separate parameters.

### Code Without Double-splats

Here is an example of code I recently refactored to take advantage of all the things I have
mentioned.

Originally it looked like this:

{% highlight ruby %}
def form(*args)
  options = args.extract_options!
  parent = options.delete(:parent)

  FormPresenter.new(*args, options.merge(title: "#{ parent.name } - Positions"))
end

form(object, remote: true, submit_method: :get)
{% endhighlight %}

{% highlight ruby %}
def photo(*args)
  options = args.extract_options!
  options.merge! :label => "choose new photo"  unless options.has_key?(:label)
  photo_field(*args, options.merge!(:name => :photo))
end
{% endhighlight %}

A few things to note:

* Local variable assignment is needed.
* The name `args` has no meaning. Its a "mixed bag" so-to-speak, whose value is a combination
  of resources (Array) and options (Hash) which are being passed in. The two must be explicitly
  separated, in this case by using `extract_options!` (from ActiveSupport).
* A call to `merge` adds to the given options.

### Improving the Code Using Double-splats

Here is the listing from above, modified to now use the double-splat.

{% highlight ruby %}
def form(*resources, parent: nil, **options)
  FormPresenter.new(resources, **options, title: "#{ parent.name } - Positions")
end
{% endhighlight %}

{% highlight ruby %}
def photo(*args, **options)
  photo_field(*args, label: "choose new photo", name: :photo, **options)
end
{% endhighlight %}

The code is more succinct and, more importantly, clearer than the previous listing. Here are the
key improvements:

* The variables have been moved into the method's argument list. Using both the splat and
  double-splat args are split automatically into their Array and Hash components. The method
  arguments' names now bear meaning and are easier to understand.
* A keyword argument (`parent`) captures a hash key which I want to handle separately from the
  other options. It is no longer necessary to extract it from the options hash.
* When calling `FormPresenter.new` the trailing Hash parameters (the `:title` key/value in this
  case) are merged with double-splatted `options`, eliminating the need for explicitly calling
  `#merge`.

## A Deeper Look

### Trailing Hash Arguments (and Magic Merge)

Double-splatted arguments may be mixed and matched with floating hash arguments. All such
arguments will be magically merged from left to right. If there are duplicate keys then the last
one (right-most) wins out. You can even have multiple double-splatted arguments.

{% highlight ruby %}
def foo(**options)
  options
end

default_options = { bar: true, baz: false }
user_options    = { baz: true, qux: false }

# Duplicate keys from `user_options` will overwrite those from `default_options`
foo(**default_options, **user_options)     
#=> {:bar=>true, :baz=>true, :qux=>false}

foo(**default_options, qux: true, quux: true, **user_options)
#=> {:bar=>true, :baz=>true, :qux=>false, :quux=>true}
{% endhighlight %}

Notably, when a double-splat is applied to an empty `Hash` it results in zero arguments. This
is consistent with the behavior of applying a splat to an empty `Array`.  

{% highlight ruby %}
def foo(x)
  puts x
end

foo("This fails", {})    # Too many arguments
# => ArgumentError: wrong number of arguments (2 for 1)

foo("This works", **{})  # The double-splatted empty Hash results in 0 arguments
# => This works
{% endhighlight %}

### Uses Outside of Method Arguments

You can also use double-splats in Hash constructors. It works just like the previous examples.

{% highlight ruby %}
foo = { bar: 123 }
#=> {:bar=>123}

{ baz: 456, **foo }
#=> {:baz=>456, :bar=>123}
{% endhighlight %}

## Block Parameters

Just like with methods, block parameters can use double splats.

{% highlight ruby %}
posts = [
  { date: "2015-08-23", author: "Fred Jones", title: "You won't believe what these cats found in their owners closet", last_updated: "2015-09-16", ... },
  { date: "2015-08-15", title: "Who am I really?", ... },
  { date: "2015-08-12", author: "Jon Smith", title: "Expressions of love in Powhatan", ... }
]

<% posts.each do |post| %>
  <li>"<%= post[:title] %>" by <%= post[:author] || "Anonymous" %> on <%= post[:date] %></li>
<% end %>
{% endhighlight %}

{% highlight ruby %}
<% posts.each do |title:, author: "Anonymous", date:, **meta| -%>
  <li>"<%= title %>" by <%= author %> on <%= date %></li>
<% end %>
# => <li>"You won't believe what these cats found in their owners closet" by Fred Jones on 2015-08-16</li>
# => <li>"Who am I really?" by Anonymous on 2015-08-15</li>
# => <li>"Expressions of love in Powhatan" by Jon Smith on 2015-08-12</li>
{% endhighlight %}

## Caveats

### Double-splat Always Creates New Hash Objects

A double-splatted parameter will _always_ construct a new Hash object as shown here by
returning the object id for the options Hash.

{% highlight ruby %}
def foo(**options)
  options.object_id
end

options = { bar: true, baz: false }

options.object_id
#=> 70230580838460

foo(options)
#=> 70230592362680  # Different Hash
{% endhighlight %}

Double-splatting an argument will likewise result in the construction of a new Hash.

{% highlight ruby %}
def bar(options = {})
  options.object_id
end

bar(options)
#=> 70230580838460  # Same Hash

bar(**options)
#=> 70230575474660  # Different Hash
{% endhighlight %}

### Only Symbol Keys Are Supported

Trying to double splat a Hash which contains string keys will not work.

{% highlight ruby %}
options = { "string keys" => "are bad" }
foo(**options)  #=> TypeError: wrong argument type String (expected Symbol)
{% endhighlight %}

### Double-splat vs. Optional Parameter

I frequently encounter methods with a optional parameter to capture trailing Hash values (and
provide a default value) which looks like this:

{% highlight ruby %}
def foo(arg, options = {})
{% endhighlight %}

In many cases this works great! However, when you add more optional parameters into the
signature there is a significant difference between this approach and using a double-splatted
parameter. Optional parameters will be satisfied from left to right, which means that if no
arguments are given then the trailing Hash values will not be captured by the last parameter.

{% highlight ruby %}
def foo(bar = nil, options = {})
  puts "bar     = #{ bar.inspect }"
  puts "options = #{ options }"
end

foo(a: 1, b: 2)
#=> bar     = {:a=>1, :b=>2}
#=> options = {}
{% endhighlight %}

A double-splat will instead take precedence over optional parameters and capture any trailing
Hash arguments.

{% highlight ruby %}
def foo(bar = nil, **options)
  puts "bar     = #{ bar.inspect }"
  puts "options = #{ options }"
end

foo(a: 1, b: 2)
#=> bar     = nil
#=> options = {:a=>1, :b=>2}
{% endhighlight %}

There may be legitimate use cases for both parameter styles in these examples, but I believe that the
double-splat is the best fit in most cases. I was unable to find a real-life example of needing the
trailing optional parameter.
