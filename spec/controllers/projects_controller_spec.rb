require 'spec_helper'

describe ProjectsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:project) { FactoryGirl.create(:project, user: user) }
  let(:valid_project) { FactoryGirl.create(:project, :valid) }
  let(:submitted_project) { p = FactoryGirl.create(:project, :valid); p.update_attribute(:status, 1); p }
  let(:published_project) { p = FactoryGirl.create(:project, :valid); p.update_attribute(:status, 2); p }

  before(:each) do
    sign_in user
  end
  def donate_valid_attr
    {
      id:         published_project.id,
      trade_no:   "2013112000001000000072962895",
      amount:     100,
      user_id:    user.id,
    }
  end
  describe "POST donate" do
    context "with valid attributes" do
      it "should redirect to project/:id/show" do
        sign_in user
        post 'donate', donate_valid_attr
        response.should redirect_to(project_url(published_project))
      end
      #it "should add raised_amount for project" do
        #original_amount = project.raised_amount
        #post 'donate', donate_valid_attr
        #project.reload # can we use expect??
        #(project.raised_amount - original_amount).should == 100
      #end
      it "should add one donation" do
        sign_in user
        post 'donate', donate_valid_attr
        published_project.should have(1).donations
      end
    end
  end
  

  describe "PUT update" do
    context "step=story" do
      it "should redirect_to edit page" do
        project
        put 'update', {
          id: project.id,
          step: "story",
          next: "owner",
          project: {
            story_attributes: {
              video_url: "",
              weibo_url: "",
              introduction: "<p>This is a testing project&nbsp;</p>\r\n\r\n<p>Okay this is the project right??</p>\r\n\r\n<ul>\r\n\t<li>First</li>\r\n\t<li>Second</li>\r\n</ul>\r\n",
              risk: "Risk risk risk..."
            }
          }
        }
        response.should redirect_to(edit_project_url(project, { step: "owner" }))
      end
    end
  end

  describe "GET new" do
    pending # TODO: guarantee user could only setup new project before he finished editing the current one.
  end

end
