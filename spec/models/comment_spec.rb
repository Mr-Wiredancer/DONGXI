require 'spec_helper'

describe Comment do
  let(:project) { FactoryGirl.create(:project) }
  let(:user) { FactoryGirl.create(:user) }
  describe "after_save" do
    it "update project's comment count" do
      c = Comment.create({
        project_id: project.id,
        user_id: user.id,
        body: "Testing"
      })
      project.reload
      project.comments_count.should == 1
    end
  end
end
