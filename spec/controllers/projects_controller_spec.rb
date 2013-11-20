require 'spec_helper'

describe ProjectsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
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
end
