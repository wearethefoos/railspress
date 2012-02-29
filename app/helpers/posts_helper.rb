module PostsHelper
  def link_to_post(post, text=nil)
    url = url_to_post(post)
    if text.nil?
      text = post.title
    end
    link_to(text, url).html_safe
  end

  def url_to_post(post, full=false)
    t = post.created_at
    url = "/read/#{t.year}/#{t.month}/#{post.slug}"
    url = 'http://' + request.host + url if full
    url
  end
end
