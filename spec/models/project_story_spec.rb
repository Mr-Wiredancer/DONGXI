require 'spec_helper'

describe ProjectStory do
  subject(:story) { FactoryGirl.create(:project_story) }

  describe "after_save" do
    it "can save weibo info" do
      pending # this spec would fail if it runs after project_spec
      project = FactoryGirl.create(:project)
      project.build_story({
        introduction: "Introduction",
        weibo_url:    "http://weibo.com/3876426391/AiFnt8zMh",
        video_url:    "<iframe height=596 width=620 src='http://player.youku.com/embed/XMzk1NjM4MzMy' frameborder=0 allowfullscreen></iframe>",
        risk:         "risk"
      })
      project.save

      w = project.weibo_status
      w.status_mid.should == "AiFnt8zMh"
    end
  end
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
