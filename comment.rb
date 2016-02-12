class Comment

  @@comment_list = []

  attr_reader :user, :body, :age
  
  def initialize(user, body, age)
    @user = user
    @body = body
    @age = age

    @@comment_list << self
  end

  def self.all 
    @@comment_list
  end

end