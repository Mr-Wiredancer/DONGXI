require 'spec_helper'
require 'cancan/matchers'

describe Ability do

	subject(:ability) { Ability.new(user) }
	
	context "Admin manage all" do
		let(:user) { FactoryGirl.create(:user, :admin) }
		it { should be_able_to(:manage, Project) }
		it { should be_able_to(:manage, User) }
		it { should be_able_to(:manage, Donation) }
		it { should be_able_to(:manage, Comment) }
		it { should be_able_to(:manage, Category) }
		it { should be_able_to(:manage, Region) }
		it { should be_able_to(:manage, WeiboStatus) }
	end

	context "Registered users" do
		let(:user) { FactoryGirl.create(:user) }
		let(:project) { FactoryGirl.create(:project, user: user) }
		let(:unpublish_project) { p = FactoryGirl.create(:project, :valid) }
		let(:publish_project) { p = FactoryGirl.create(:project, :valid); p.update_attributes(status: 2); p }
		let(:comment) { FactoryGirl.create(:comment, project: project) }
		context "Project" do
			it { should be_able_to(:create, Project) }
			it { should be_able_to(:donate, publish_project) }
			it { should be_able_to(:add_volunteer, publish_project) }
			it { should be_able_to(:remove_volunteer, publish_project) }
			it { should_not be_able_to(:donate, unpublish_project) }
			it { should_not be_able_to(:add_volunteer, unpublish_project) }
			it { should_not be_able_to(:remove_volunteer, unpublish_project) }
			it { should be_able_to(:manage_own, project) }
		end
	end

	context "Anonymous user" do
		let(:user) { nil }
		context "Project" do
			it { should_not be_able_to(:create, Project) }
			it { should be_able_to(:read, Project) }
		end
	end
end