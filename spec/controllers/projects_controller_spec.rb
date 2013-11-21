require 'spec_helper'

describe ProjectsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:project) { FactoryGirl.create(:project) }
  #let(:in_audit_project) { FactoryGirl.create(:project, :audit) }
  before(:each) do
    sign_in user
  end
  def donate_valid_attr
    {
      id:         project.id,
      trade_no:   "2013112000001000000072962895",
      amount:     100,
      user_id:    user.id,
    }
  end
  describe "POST donate" do
    context "with valid attributes" do
      it "should redirect to project/:id/show" do
        post 'donate', donate_valid_attr
        response.should redirect_to(project_url(project))
      end
      it "should add raised_amount for project" do
        original_amount = project.raised_amount
        post 'donate', donate_valid_attr
        project.reload # can we use expect??
        (project.raised_amount - original_amount).should == 100
      end
      it "should add one donation" do
        post 'donate', donate_valid_attr
        project.should have(1).donations
      end
    end
  end
  describe "GET publish" do
    context "when user is admin" do
      it "can update project status" do
        sign_out user; sign_in admin
        project.update_attributes!(status: 1) # WARNING: don't use submit!
        get 'publish', { id: project.id }
        project.reload
        project.should be_in_publish
      end
    end
    context "when user is not admin" do
      it "cannot update project status" do
        project.update_attributes!(status: 1)
        get 'publish', { id: project.id }
        response.should redirect_to(root_url)
      end
    end
  end
end
