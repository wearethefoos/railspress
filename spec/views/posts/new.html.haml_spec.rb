require 'spec_helper'

describe "posts/new.html.haml" do
  before(:each) do
    assign(:post, stub_model(Post,
      :title => "",
      :slug => "",
      :intro => "",
      :body => "",
      :tags => "",
      :reads => ""
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path, :method => "post" do
      assert_select "input#post_title", :name => "post[title]"
      assert_select "input#post_slug", :name => "post[slug]"
      assert_select "input#post_intro", :name => "post[intro]"
      assert_select "input#post_body", :name => "post[body]"
      assert_select "input#post_tags", :name => "post[tags]"
      assert_select "input#post_reads", :name => "post[reads]"
    end
  end
end
