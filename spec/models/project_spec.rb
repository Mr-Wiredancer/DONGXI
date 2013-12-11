require 'spec_helper'

describe Project do
  let(:user) { FactoryGirl.create(:user) }
  subject(:project) { FactoryGirl.create(:project) }
  let(:valid_project) { FactoryGirl.create(:project, :valid) }
  let(:submitted_project) { p = FactoryGirl.create(:project, :valid); p.update_attribute(:status, 1); p }
  let(:published_project) { p = FactoryGirl.create(:project, :valid); p.update_attribute(:status, 2); p }

  def donation_attr
    {
      trade_no:   "2013112000001000000072962895",
      amount:     100,
      user_id:    user.id,
    }
  end

  context "when first created" do
    it "has no money" do
      project.raised_amount.should == 0
    end
    it "has no volunteer" do
      project.volunteer_amount.should == 0
    end
    it "should be in_edit" do
      project.should be_in_edit
    end
    it "is unrecommended" do
      project.recommended.should be_false
    end
  end

  describe "#add_donation" do
    it "add an donation for project" do
      project.add_donation(donation_attr)
      project.should have(1).donations
    end
  end

  describe "#submit!" do
    context "without basic_info, owner or story" do
      it "could not submit" do
        expect {
          project.submit!
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "with valid attributes" do
      it "change status to in_audit" do
        valid_project.submit!
        valid_project.reload
        valid_project.should be_in_audit
      end
    end
  end

  describe "#publish!" do
    it "should publish project" do
      submitted_project.publish!
      submitted_project.reload
      submitted_project.should be_in_publish
    end
    it "do nothing to in_edit project" do
      valid_project.unpublish!
      valid_project.reload
      valid_project.should be_in_edit
    end
  end

  describe "#unpublish!" do
    it "should change project back to edit" do
      submitted_project.unpublish!
      submitted_project.reload
      submitted_project.should be_in_edit
    end
    it "do nothing to published project" do
      published_project.unpublish!
      published_project.reload
      published_project.should be_in_publish
    end
  end

  describe "#search" do
    context "unpublished projects" do
      it "can not be searched" do
        p = FactoryGirl.create(:project, :valid)
        p.basic_info = FactoryGirl.create(:project_basic_info, name: "dongxi")
        p.save

        Project.search(key: 'dongxi').should_not include(p)
      end

      it "can be searched after published" do
        p = FactoryGirl.create(:project, :valid)
        p.basic_info = FactoryGirl.create(:project_basic_info, name: "dongxi")
        p.status = 2; p.save

        Project.search(key: 'dongxi').should include(p)
      end
    end
    context "attributes: " do
      it ".basic_info" do
        p1 = FactoryGirl.create(:project, :valid)
        p1.basic_info = FactoryGirl.create(:project_basic_info, name: "DONgXi")
        p1.status = 2; p1.save;

        p2 = FactoryGirl.create(:project, :valid)
        p2.basic_info = FactoryGirl.create(:project_basic_info, slogan: "xiNan")
        p2.status = 2; p2.save;

        Project.search(key: "ong").should include(p1)
        Project.search(key: "donGxI").should include(p1)
        Project.search(key: "nan").should include(p2)
        Project.search(key: "XiNAN").should include(p2)
        Project.search(key: "xI").should include(p1,p2)

      end
      it ".introduction" do
        p = FactoryGirl.create(:project, :valid)
        p.story = FactoryGirl.create(:project_story, introduction: "We are hackers!")
        p.status = 2; p.save;

        Project.search(key: 'we').should include(p)
        Project.search(key: 'Hack').should include(p)
        Project.search(key: '!').should include(p)
      end

      it ".owner" do
        p = FactoryGirl.create(:project, :valid)
        p.owner = FactoryGirl.create(:project_owner, name: "dxHackers")
        p.status = 2; p.save;

        Project.search(key: "DX").should include(p)
        Project.search(key: 'haCk').should include(p)
        Project.search(key: 'ERS').should include(p)
      end
    end
  end

  describe "#add_volunteer" do
    it "add one volunteer" do
      project.add_volunteer(user.id)

      project.volunteers.should include(user)
      project.volunteer_amount.should == 1
    end
    it "can only add same volunteer once" do
      project.add_volunteer(user.id)
      project.add_volunteer(user.id)

      project.volunteer_amount.should == 1
    end
  end
  describe "#remove_volunteer" do
    context "remove wrong id" do
      it "do nothing" do
        project.add_volunteer(user.id)
        project.remove_volunteer(user.id + 1) # wrong id

        project.volunteer_amount.should == 1
      end
    end
    context "remove correct id" do
      it "decrease volunteer_amount" do
        # add one first...
        project.volunteers << user
        project.volunteer_amount = 1
        project.save

        project.remove_volunteer(user.id)

        project.volunteer_amount.should == 0
      end
    end
  end
end
