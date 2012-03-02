require 'spec_helper'

describe Article do
  describe "merging articles" do
    context "merging article is a regular article" do
      it "should have the content and authors of both articles" do
	Factory(:blog)
	base = Factory(:article, { :title => 'Suboptimal Article', :body => 'i mean, i think', :author => 'peter' })
	invader = Factory(:article, { :title => 'Super Article', :body => 'power level over 9000!', :author => 'doboy' })
	base.merge(invader)
	base.title.should == "Suboptimal Article"
	base.body.should include "i mean, i think"
 	base.body.should include "power level over 9000!"
	base.author.should include "peter"
	base.author.should include "doboy"
      end
      it "should have the comments of both articles" do
	Factory(:blog)
	dummy_article = Factory(:article, { :body => 'this is the body', :author => 'peter' })
	dummy_merge_article = Factory(:article, { :body => 'this is another body', :author => 'doboy' })
	first_comment = Comment.new({ :author => 'peter', :article => dummy_article, :body => 'cool article' })
	second_comment = Comment.new({ :author => 'doboy', :article => dummy_merge_article, :body => 'laaaaaame' })
	first_comment.save
	second_comment.save
	dummy_article.merge(dummy_merge_article)
	dummy_article.comments.should include first_comment
	dummy_article.comments.should include second_comment
      end
      it "should create an entry in the merged_authors table" do
	dummy_article = Article.new({ :title => 'this is the title', :body => 'and this is the body', :author => 'peter' })
	dummy_merge_article = Article.new({ :title => 'my title', :body => 'look at my body', :author => 'doboy' })
	dummy_article.save
	dummy_merge_article.save
	dummy_article.merge(dummy_merge_article)
	MergedAuthor.where( "article_id" => dummy_article.id ).should_not be_empty
      end
      it "should delete the old article" do
	dummy_article = Article.new({ :title => 'this is the title', :body => 'and this is the body', :author => 'peter' })
	dummy_merge_article = Article.new({ :title => 'my title', :body => 'look at my body', :author => 'doboy' })
	dummy_article.save
	dummy_merge_article.save
	dummy_article.merge(dummy_merge_article)
	Article.where( "id" => dummy_merge_article.id ).should be_empty
      end
    end
    context "merging article is a merged article" do
      it "should have the content and authors of both articles" do
	Factory(:blog)
	base = Factory(:article, { :title => 'Suboptimal Article', :body => 'i mean, i think', :author => 'peter' })
	invader = Factory(:article, { :title => 'Super Article', :body => 'power level over 9000!', :author => 'doboy' })
	invader_invader = Factory(:article, { :title => 'All up in the invasion', :body => 'pew pew', :author => 'doby' })
	invader.merge(invader_invader)
	base.merge(invader)
	base.body.should include "i mean, i think"
	base.body.should include "power level over 9000!"
	base.body.should include "pew pew"
	base.author.should include "peter"
	base.author.should include "doboy"
	base.author.should include "doby"
      end
    end
  end
end