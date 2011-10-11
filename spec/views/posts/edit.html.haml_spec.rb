require 'spec_helper'

describe "posts/edit.html.haml" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :title => "",
      :slug => "",
      :intro => "",
      :body => "",
      :tags => "",
      :reads => ""
    ))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path(@post), :method => "post" do
      assert_select "input#post_title", :name => "post[title]"
      assert_select "input#post_slug", :name => "post[slug]"
      assert_select "input#post_intro", :name => "post[intro]"
      assert_select "input#post_body", :name => "post[body]"
      assert_select "input#post_tags", :name => "post[tags]"
      assert_select "input#post_reads", :name => "post[reads]"
    end
  end
end
