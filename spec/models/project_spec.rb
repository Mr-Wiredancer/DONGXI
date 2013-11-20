require 'spec_helper'

describe Project do
  let(:user) { FactoryGirl.create(:user) }
  subject(:project) { FactoryGirl.create(:project) }

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
  end
  context "#add_donation" do
    it "add raised_amount for project" do
      expect {
        project.add_donation(donation_attr)
      }.to change { project.raised_amount }.by(100)
    end
    it "add an donation for project" do
      project.add_donation(donation_attr)
      project.should have(1).donations
    end
  end
end
