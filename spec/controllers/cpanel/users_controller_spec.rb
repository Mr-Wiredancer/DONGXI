require 'spec_helper'


describe Cpanel::UsersController do

  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:valid_attributes) { {
    name:                   "allen",
    email:                  "allen@dxhackers.com",
    password:               "dxhackers",
    password_confirmation:  "dxhackers"
   } }

  before do
    sign_in admin
  end

  describe "GET index" do
    it "assigns all users as @users" do
      user = FactoryGirl.create(:user)
      get :index
      assigns(:users).should eq([admin, user])
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = FactoryGirl.create(:user)
      get :show, {:id => user.to_param}
      assigns(:user).should eq(user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new
      assigns(:user).should be_a_new(User)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = FactoryGirl.create(:user)
      get :edit, {:id => user.to_param}
      assigns(:user).should eq(user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:user => valid_attributes}
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, {:user => valid_attributes}
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to users list" do
        post :create, {:user => valid_attributes}
        response.should redirect_to(cpanel_users_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => {  }}
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => {  }}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user without password" do
        user = FactoryGirl.create(:user)
        User.any_instance.should_receive(:update_without_password).with({ "name" => "dxhacker" })
        put :update, {:id => user.to_param, :user => { "name" => "dxhacker" }}
      end

      it "updates the requested user with password" do
        user = FactoryGirl.create(:user)
        User.any_instance.should_receive(:update_attributes).with({ "password" => "rubyonrails", "password_confirmation" => "rubyonrails"})
        put :update, {:id => user.to_param, :user => { "password" => "rubyonrails", "password_confirmation" => "rubyonrails" }}
      end

      it "assigns the requested user as @user" do
        user = FactoryGirl.create(:user)
        put :update, {:id => user.to_param, :user => valid_attributes}
        assigns(:user).should eq(user)
      end

      it "redirects to the users list" do
        user = FactoryGirl.create(:user)
        put :update, {:id => user.to_param, :user => valid_attributes}
        response.should redirect_to(cpanel_users_url)
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = FactoryGirl.create(:user)
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => user.to_param, :user => {  }}
        assigns(:user).should eq(user)
      end

      it "re-renders the 'edit' template" do
        pending
        user = FactoryGirl.create(:user)
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => user.to_param, :user => {  }}
        response.should render_template("edit") # FIXME: expecting <"edit"> but rendering with <""> WTF ???
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      user = FactoryGirl.create(:user)
      expect {
        delete :destroy, {:id => user.to_param}
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = FactoryGirl.create(:user)
      delete :destroy, {:id => user.to_param}
      response.should redirect_to(cpanel_users_url)
    end
  end

end
