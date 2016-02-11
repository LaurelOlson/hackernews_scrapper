class Post

  @@comment_list = []

  attr_reader :title, :url, :points, :item_id, :comment_list

  def initialize(title, url, points, item_id)
    @title = title
    @url = url
    @points = points
    @item_id = item_id
  end

  # returns all comments associated with a particular post
  def comments
    @@comment_list
  end

  # takes a Comment object as its input and adds it to the comment list
  def add_comment(comment)
    @@comment_list << comment
  end

end