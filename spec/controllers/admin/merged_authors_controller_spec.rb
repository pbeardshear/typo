require 'spec_helper'

describe Admin::ContentController do
  describe "clicking the merge button to merge articles" do
    before do
      Factory(:blog)
      @user = Factory(:user, :profile => Factory(:profile_admin, :label => Profile::ADMIN))
      request.session = { :user => @user.id }
    end
    it "should merge the two articles" do
      base = Article.new( :title => 'this is the base', :body => 'all your base are belong to us', :author => 'peter' )
      invader = Article.new( :title => 'this is the title', :body => 'this is the body', :author => 'doboy' )
      base.save
      invader.save
      Article.stub(:merge)
      base.should_receive(:merge).with(invader)
      post :merge, { :id => base.id, :merge_id => invader.id }
    end
    it "should render the content page template" do
      base = Article.new( :title => 'this is the base', :body => 'all your base are belong to us', :author => 'peter' )
      invader = Article.new( :title => 'this is the title', :body => 'this is the body', :author => 'doboy' )
      base.save
      invader.save
      Article.stub(:merge)
      post :merge, { :id => base.id, :merge_id => invader.id }
      response.should render_template('index')
    end
    it "should render the edit page on failure" do
      Article.stub(:merge)
      post :merge, { :id => 442, :merge_id => 87 }
      response.should render_template('edit')
    end
  end
end