# coding: utf-8
require 'spec_helper'

describe Donation do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  subject(:donation) { Donation.new(valid_attr) }
  let(:another_donation) { Donation.new(valid_attr) }

  def valid_attr
    {
      user_id: user.id,
      project_id: project.id,
      trade_no: "2013112000001000000072962895",
      amount: 1,
    }
  end
  context "Validates" do
    it "is valid with valid attributes" do
      donation.should be_valid
    end
    describe "#trade_no" do
      it "length should be 28" do
        # cut one letter!
        donation.trade_no = donation.trade_no.chop
        donation.should have(1).error_on(:trade_no)
      end
      it "should be uniq" do
        donation.save!
        expect {
          another_donation.save!
        }.to raise_error(ActiveRecord::RecordInvalid, "验证失败: Trade no 已经被使用")
      end
    end
    describe "#user" do
      it "is required" do
        donation.user = nil
        donation.should have(1).error_on(:user)
      end
    end
    describe "#project" do
      it "is required" do
        donation.project = nil
        donation.should have(1).error_on(:project)
      end
    end
  end
end
