require 'spec_helper'

describe CommentsController do
	let(:project) { FactoryGirl.create(:project) }
	let(:user) { FactoryGirl.create(:user) }
	describe "POST create" do
		it "should add a comment to project" do
			sign_in user
			post 'create', {
				comment: {
					body: "Testing"
				},
				project_id: project.id
			}
			expect(assigns(:project)).to have(1).comments
		end
		it "should update project's comments_count" do
			sign_in user
			post 'create', {
				comment: {
					body: "Testing"
				},
				project_id: project.id
			}
			project.reload
			project.comments_count.should == 1
		end
	end
end
