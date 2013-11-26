require 'spec_helper'

describe ProjectStory do
  subject(:story) { FactoryGirl.create(:project_story) }

  describe "#has_valid_weibo?" do
    context "with default value" do
      it "is valid" do
        story.has_valid_weibo?.should be_true
      end
    end
    context "with invalid value" do
      it "is not valid" do
        story.weibo_url = ""
        story.has_valid_weibo?.should be_false
      end
    end
  end
end
