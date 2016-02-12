class Post

  @@comment_list = []

  attr_reader :page, :title, :url, :points, :item_id, :comment_list

  def initialize(page, title, url, points, item_id)
    @page = page
    @title = title.colorize(:bold).bold
    @url = url.colorize(:underline).underline
    @points = points.colorize(:magenta)
    @item_id = item_id
  end

  # returns all comments associated with a particular post
  def comments
    @@comment_list
  end

  ## These methods parse the page and extract the comments.

  # takes a Comment object as its input and adds it to the comment list.
  # Each comment is a hash containing the commenter's name, and the age age body of the comment.
  def add_comment(comment)
    @@comment_list << comment
  end

  # Returns an array of comment users
  def get_comment_user
    page.css(".comment-tree").css(".comhead").map do |header| 
      header.text.match(/\S+\s\S+/).to_s.split(' ')[0]
    end
  end

  # Returns an array of comment bodies
  def get_comment_body
    page.css("span.comment").map do |comment| 
      comment.text.match(/[A-Z].*[A-Za-z]\W{1}/).to_s
      end
  end

  # Returns an array of comment ages
  def get_comment_age
    page.css(".comment-tree").css(".comhead").map do |header| 
      header.text.match(/\S+\s\S+/).to_s.split(' ')[1]
    end
  end

  # Creates a new Comment instance for each comment on the page.
  def create_comments
    if get_comment_age.empty? || get_comment_body.empty? || get_comment_user.empty?
      raise CommentsSelectorError.new
    end

    num_comments = get_comment_body.length

    # Creates an array containing empty hashes for each comment
    comments = []
    num_comments.times do
      comments << {}
    end

    # For each comment, adds comment user, age, and body to array
    comments.each do |comment|

      get_comment_user.each do |user|
        comment[:user] = user.colorize(:blue)
      end

      get_comment_age.each do |age|
        comment[:age] = age.colorize(:green)
      end

      get_comment_body.each do |body|
        comment[:body] = body.colorize(:light_black)
      end

    end

    # For each comment hash in the comments array, create a new Comment instance
    comments.each do |comment|
      add_comment(Comment.new(comment[:user], comment[:body], comment[:age]))
    end

  end

end