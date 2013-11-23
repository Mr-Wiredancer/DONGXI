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
    it "should be in_edit" do
      project.should be_in_edit
    end
  end

  describe "#add_donation!" do
    it "add an donation for project" do
      project.add_donation!(donation_attr)
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
    describe "search info" do
      pending
    end
  end
end
