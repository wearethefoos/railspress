module PostsHelper
  def link_to_post(post, text=nil)
    if text.nil?
      text = post.title
    end
    link_to(text, url_to_post(post)).html_safe
  end
  
  def url_to_post(post, full=false)
    t = post.created_at
    url = "/read/#{t.year}/#{t.month}/#{post.slug}"
    if full
      url = 'http://foxycoder.com' + url
    end
    url
  end
end
