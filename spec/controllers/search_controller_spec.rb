require 'spec_helper'

describe SearchController do
  describe "GET index" do
    it "get projects" do
      # create a custom published project
      p = FactoryGirl.create(:project, :valid)
      p.basic_info = FactoryGirl.create(:project_basic_info, name: "dongxi")
      p.status = 2; p.save
      get 'index', { key: "DongXi" }
      expect(assigns(:projects)).to eq([p])
    end
  end
end
