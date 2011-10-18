module PostsHelper
  def link_to_post(post, text=nil)
    if text.nil?
      text = post.title
    end
    link_to(text, url_to_post(post)).html_safe
  end
  
  def url_to_post(post)
    t = post.created_at
    "/read/#{t.year}/#{t.month}/#{post.slug}"
  end
end
