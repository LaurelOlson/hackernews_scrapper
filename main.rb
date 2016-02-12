require_relative 'post'
require_relative 'comment'
require_relative 'exceptions/selector_error'
require 'nokogiri'
require 'pry'
require 'open-uri'
require 'colorize'

# Instantiate a Post object

page = Nokogiri::HTML(open(ARGV[0]))
title = page.css("title")[0].text
url = page.css("a").find { |link| link.text.include? "#{title[0..3]}" }["href"]
points = page.css(".score")[0].text.split(' ')[0]
item_id = page.css("a").find { |link| link["href"] =~ /=\d{4,}/ }["href"].match(/\d{4,}/).to_s

post = Post.new(page, title, url, points, item_id)

# binding.pry
post.create_comments

puts "Post title: #{post.title}"
puts "Post url: #{post.url}"
puts "Post points: #{post.points}"
puts "Number of comments: #{post.comments.length.to_s.colorize(:green)}"
puts "Top comment: 
\tuser: #{post.comments[0].user}
\tcomment: #{post.comments[0].body}" unless post.comments.empty?