class CommentMailer < ActionMailer::Base
  default from: "wrdevos@gmail.com"
  
  def new_comment(comment, post)
    @post = post
    mail :to => post.user.email, :subject => "New comment on: #{post.title}!"
  end
end
