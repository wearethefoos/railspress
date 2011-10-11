module PostsHelper
  def link_to_post(post, text=nil)
    t = post.created_at
    if text.nil?
      text = post.title
    end
    link_to(text, "/read/#{t.year}/#{t.month}/#{post.slug}").html_safe
  end
end
