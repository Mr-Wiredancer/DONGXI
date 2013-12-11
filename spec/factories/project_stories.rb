FactoryGirl.define do
  factory :project_story do
    introduction  "Introduction"
    weibo_url     "http://weibo.com/3876426391/AiFnt8zMh"
    video_url     "<iframe height=596 width=620 src='http://player.youku.com/embed/XMzk1NjM4MzMy' frameborder=0 allowfullscreen></iframe>"
    risk          "risk"

    after(:build) { |story| story.class.skip_callback(:save, :after, :save_weibo_id) }
  end
end
