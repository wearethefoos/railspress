class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :body, :type => String
  field :user_id, :type => BSON::ObjectId
  field :parent_id, :type => BSON::ObjectId
  field :path, :type => String
  field :votes, :type => Integer, :default => 0
  field :voters, :type => Array, :default => []
  
  embedded_in :post
  embedded_in :comment
  embeds_many :comments
  belongs_to  :user
  
  validates :body, :presence => true

  after_create :notify
  
  # Upvote this comment.
  def upvote(user)
    unless self.votes.any? {|id| id.to_s == user.id.to_s}
      self.voters << user.id 
      self.votes += 1
      self.save
    end
  end

  def notify
    CommentMailer::new_comment(self, post).deliver
  end
end
