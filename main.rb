require_relative 'post'
require_relative 'comment'
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

post = Post.new(title, url, points, item_id)

# Parse Hacker News HTML (post.html)

# This returns all comments (including user, age, and body)
comments = page.css(".comment-tree").css. map { |comment| comment.text }

# this returns an array of comments as strings
comment_bodies = page.css("span.comment").map { |comment| comment.text }.map { |comment| comment.match(/[A-Z].*[A-Za-z]\W{1}/).to_s }

# this returns an array of ages as strings ex ["632", "543"]
comment_ages = page.css(".comment-tree").css(".comhead").map { |header| header.text }.map { |header| header.match(/\S+\s\S+/).to_s }.map { |header| header.split(' ')[1] }

# this returns an array of comment usernames as strings
comment_users = page.css(".comment-tree").css(".comhead").map { |header| header.text }.map { |header| header.match(/\S+\s\S+/).to_s }.map { |header| header.split(' ')[0] }

# Create a new Comment object for each comment in the HTML and add to the Post object.

num_comments = comments.length

comments = []
num_comments.times do
  comments << {}
end

comments.each do |comment|

  i = 0
  comment_users.each do |user|
    comments[i][:user] = user
    i += 1
  end

  i = 0
  comment_ages.each do |age|
    comments[i][:age] = age
    i += 1
  end

  i = 0
  comment_bodies.each do |body|
    comments[i][:body] = body
    i += 1
  end

end

comments.each do |comment|
  user = comment[:user]
  body = comment[:body]
  age = comment[:age]
  post.add_comment(Comment.new(user, body, age))
end

puts "Post title: #{post.title}"
puts "Post url: #{post.url}"
puts "Number of comments: #{post.comments.length}"
puts "Top comment: 
\tuser: #{post.comments[0].user}
\tcomment: #{post.comments[0].body}"