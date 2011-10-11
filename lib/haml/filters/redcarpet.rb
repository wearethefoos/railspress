require 'redcarpet'
require 'albino'

module Haml::Filters::Redcarpet
  include Haml::Filters::Base
  
  def render(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    syntax_highlighter(Redcarpet.new(text, *options).to_html)
  end # method render
  
  def syntax_highlighter(html)
    doc = Nokogiri::HTML(html)
    doc.search("//pre[@lang]").each do |pre|
      pre.replace Albino.colorize(pre.text.rstrip, pre[:lang])
    end
    doc.to_s
  end
end # module Haml::Filters::Redcarpet