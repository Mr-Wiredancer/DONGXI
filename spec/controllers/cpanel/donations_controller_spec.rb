require 'spec_helper'

describe Cpanel::DonationsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:project) { FactoryGirl.create(:project) }
  let(:valid_attributes) { {
      project_id: project.id,
      trade_no:   "2013112000001000000072962895",
      amount:     100,
      user_id:    user.id,
    }
  }
  before do
    sign_in FactoryGirl.create(:user, :admin)
  end

  describe "GET index" do
    it "assigns all donations as @donations" do
      donation = FactoryGirl.create(:donation)
      get :index
      assigns(:donations).should eq([donation])
    end
  end

  describe "GET show" do
    it "assigns the requested donation as @donation" do
      donation = FactoryGirl.create(:donation)
      get :show, {:id => donation.to_param}
      assigns(:donation).should eq(donation)
    end
  end

  describe "GET new" do
    it "assigns a new donation as @donation" do
      get :new
      assigns(:donation).should be_a_new(Donation)
    end
  end

  describe "GET edit" do
    it "assigns the requested donation as @donation" do
      donation = FactoryGirl.create(:donation)
      get :edit, {:id => donation.to_param}
      assigns(:donation).should eq(donation)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Donation" do
        expect {
          post :create, {:donation => valid_attributes}
        }.to change(Donation, :count).by(1)
      end

      it "assigns a newly created donation as @donation" do
        post :create, {:donation => valid_attributes}
        assigns(:donation).should be_a(Donation)
        assigns(:donation).should be_persisted
      end

      it "redirects to donations list" do
        post :create, {:donation => valid_attributes}
        response.should redirect_to(cpanel_donations_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved donation as @donation" do
        Donation.any_instance.stub(:save).and_return(false)
        post :create, {:donation => {  }}
        assigns(:donation).should be_a_new(Donation)
      end

      it "re-renders the 'new' template" do
        Donation.any_instance.stub(:save).and_return(false)
        post :create, {:donation => {  }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested donation" do
        donation = FactoryGirl.create(:donation)
        Donation.any_instance.should_receive(:update_attributes!).with({ "amount" => "1000" })
        put :update, {:id => donation.to_param, :donation => { "amount" => 1000 }}
      end

      it "assigns the requested donation as @donation" do
        donation = FactoryGirl.create(:donation)
        put :update, {:id => donation.to_param, :donation => valid_attributes}
        assigns(:donation).should eq(donation)
      end

      it "redirects to the donations list" do
        donation = FactoryGirl.create(:donation)
        put :update, {:id => donation.to_param, :donation => valid_attributes}
        response.should redirect_to(cpanel_donations_url)
      end
    end

    describe "with invalid params" do
      it "assigns the donation as @donation" do
        donation = FactoryGirl.create(:donation)
        Donation.any_instance.stub(:save).and_return(false)
        put :update, {:id => donation.to_param, :donation => {  }}
        assigns(:donation).should eq(donation)
      end

      it "re-renders the 'edit' template" do
        pending
        donation = FactoryGirl.create(:donation)
        Donation.any_instance.stub(:save).and_return(false)
        put :update, {:id => donation.to_param, :donation => {  }}
        response.should render_template("edit") # FIXME: expecting <"edit"> but rendering with <""> WTF ???
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested donation" do
      donation = FactoryGirl.create(:donation)
      expect {
        delete :destroy, {:id => donation.to_param}
      }.to change(Donation, :count).by(-1)
    end

    it "redirects to the donations list" do
      donation = FactoryGirl.create(:donation)
      delete :destroy, {:id => donation.to_param}
      response.should redirect_to(cpanel_donations_url)
    end
  end

end
