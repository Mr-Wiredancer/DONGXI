require 'spec_helper'


describe Cpanel::DonationsController do

  let(:valid_attributes) { {  } }

  let(:valid_session) { {} }

  #describe "GET index" do
    #it "assigns all donations as @donations" do
      #donation = Donation.create! valid_attributes
      #get :index, {}, valid_session
      #assigns(:donations).should eq([donation])
    #end
  #end

  #describe "GET show" do
    #it "assigns the requested donation as @donation" do
      #donation = Donation.create! valid_attributes
      #get :show, {:id => donation.to_param}, valid_session
      #assigns(:donation).should eq(donation)
    #end
  #end

  #describe "GET new" do
    #it "assigns a new donation as @donation" do
      #get :new, {}, valid_session
      #assigns(:donation).should be_a_new(Donation)
    #end
  #end

  #describe "GET edit" do
    #it "assigns the requested donation as @donation" do
      #donation = Donation.create! valid_attributes
      #get :edit, {:id => donation.to_param}, valid_session
      #assigns(:donation).should eq(donation)
    #end
  #end

  #describe "POST create" do
    #describe "with valid params" do
      #it "creates a new Donation" do
        #expect {
          #post :create, {:donation => valid_attributes}, valid_session
        #}.to change(Donation, :count).by(1)
      #end

      #it "assigns a newly created donation as @donation" do
        #post :create, {:donation => valid_attributes}, valid_session
        #assigns(:donation).should be_a(Donation)
        #assigns(:donation).should be_persisted
      #end

      #it "redirects to the created donation" do
        #post :create, {:donation => valid_attributes}, valid_session
        #response.should redirect_to(Donation.last)
      #end
    #end

    #describe "with invalid params" do
      #it "assigns a newly created but unsaved donation as @donation" do
        ## Trigger the behavior that occurs when invalid params are submitted
        #Donation.any_instance.stub(:save).and_return(false)
        #post :create, {:donation => {  }}, valid_session
        #assigns(:donation).should be_a_new(Donation)
      #end

      #it "re-renders the 'new' template" do
        ## Trigger the behavior that occurs when invalid params are submitted
        #Donation.any_instance.stub(:save).and_return(false)
        #post :create, {:donation => {  }}, valid_session
        #response.should render_template("new")
      #end
    #end
  #end

  #describe "PUT update" do
    #describe "with valid params" do
      #it "updates the requested donation" do
        #donation = Donation.create! valid_attributes
        ## Assuming there are no other donations in the database, this
        ## specifies that the Donation created on the previous line
        ## receives the :update_attributes message with whatever params are
        ## submitted in the request.
        #Donation.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        #put :update, {:id => donation.to_param, :donation => { "these" => "params" }}, valid_session
      #end

      #it "assigns the requested donation as @donation" do
        #donation = Donation.create! valid_attributes
        #put :update, {:id => donation.to_param, :donation => valid_attributes}, valid_session
        #assigns(:donation).should eq(donation)
      #end

      #it "redirects to the donation" do
        #donation = Donation.create! valid_attributes
        #put :update, {:id => donation.to_param, :donation => valid_attributes}, valid_session
        #response.should redirect_to(donation)
      #end
    #end

    #describe "with invalid params" do
      #it "assigns the donation as @donation" do
        #donation = Donation.create! valid_attributes
        ## Trigger the behavior that occurs when invalid params are submitted
        #Donation.any_instance.stub(:save).and_return(false)
        #put :update, {:id => donation.to_param, :donation => {  }}, valid_session
        #assigns(:donation).should eq(donation)
      #end

      #it "re-renders the 'edit' template" do
        #donation = Donation.create! valid_attributes
        ## Trigger the behavior that occurs when invalid params are submitted
        #Donation.any_instance.stub(:save).and_return(false)
        #put :update, {:id => donation.to_param, :donation => {  }}, valid_session
        #response.should render_template("edit")
      #end
    #end
  #end

  #describe "DELETE destroy" do
    #it "destroys the requested donation" do
      #donation = Donation.create! valid_attributes
      #expect {
        #delete :destroy, {:id => donation.to_param}, valid_session
      #}.to change(Donation, :count).by(-1)
    #end

    #it "redirects to the donations list" do
      #donation = Donation.create! valid_attributes
      #delete :destroy, {:id => donation.to_param}, valid_session
      #response.should redirect_to(donations_url)
    #end
  #end

end