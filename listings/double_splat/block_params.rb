require "erb"

posts = [
  { date: "2015-08-16", author: "Dave Jones", title: "Under the Sea", options: {} },
  { date: "2015-08-15", title: "Message from Beyond", options: {} },
  { date: "2015-08-12", author: "Jon Smith", title: "Expression of Love in Powhatan", options: {} }
]

raw_erb = <<ERB
<% posts.each do |title:, author: "Anonymous", date:, **options| %>
  <li>"<%= title %>" by <%= author %> on <%= date %></li>
<% end %>
ERB

puts ERB.new(raw_erb).result(binding)
