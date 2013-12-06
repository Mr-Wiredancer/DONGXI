require 'spec_helper'

describe Cpanel::ProjectsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:project) { FactoryGirl.create(:project, user: user) }

  before(:each) do
    sign_in admin
  end

  describe "GET publish" do
    it "works" do
      project.update_attributes!(status: 1) # WARNING: don't use submit!
      get 'publish', { id: project.id }
      project.reload
      project.should be_in_publish
    end
  end
  describe "GET unpublish" do
    it "works" do
      project.update_attributes!(status: 1)
      get 'unpublish', { id: project.id }
      project.reload
      project.should be_in_edit
    end
  end
end