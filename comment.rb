class Comment
  # post_date is an array of integers [day, month, year]

  attr_reader :user, :body, :age
  
  def initialize(user, body, age)
    @user = user
    @body = body
    @age = age
  end

  # def age
  #   post_date = Date.civil(@post_date[2], @post_date[1], @post_date[0])
  #   age = (Date.today - post_date).to_i
  # end

end