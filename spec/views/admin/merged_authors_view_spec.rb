require 'spec_helper'

describe "admin/content/new.html.erb" do
  before do
    admin = stub_model(User, :settings => {:editor => 'simple'}, :admin? => true,
	      :text_filter_name => "", :profile_label => "admin")
    blog = mock_model(Blog, :base_url => "http://myblog.net/")
    article = stub_model(Article).as_new_record
    text_filter = stub_model(TextFilter)

    article.stub(:text_filter) { text_filter }
    view.stub(:current_user) { admin }
    view.stub(:this_blog) { blog }
    
    # FIXME: Nasty. Controller should pass in @categories and @textfilters.
    Category.stub(:all) { [] }
    TextFilter.stub(:all) { [text_filter] }

    assign :article, article
  end
  
  it "should render the merge button" do
    assign(:images, [])
    assign(:macros, [])
    assign(:resources, [])
    assign(:article, mock(:article, :id => 2))
    render
    rendered.should contain("merge")
  end
  it "should display an error message if merging failed" do
    #post :merge, { :id => -1, :merge_id => 254243 }
    #flash[:error].should == "Error, merge failed."
  end
end