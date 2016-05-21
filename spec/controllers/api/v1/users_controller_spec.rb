require 'spec_helper'

describe Api::V1::UsersController do

before(:each) { request.headers["Accept"] = "application/vnd.marketplace.v1" }

describe "Get #show" do 
	before(:each) do
		@user = FactoryGirl.create(:user)
		get :show, id: @user.id, format: :json
	end

	it "returns the info about the reporter on a hash" do
		user_response = JSON.parse(response.body, symbolize_names: true)
		expect(user_response[:email]).to eql @user.email
	end

	it { should respond_with 200 }
end

describe "POST #create" do

	context "When it is successfully created" do
		before(:each) do
			@user_attributes = FactoryGirl.attributes_for(:user)
			post :create, { user: @user_attributes }, format: :json
		end

		it "renders the json representation for the user record just created" do 
		user_response = JSON.parse(response.body, symbolize_names: true)
		expect(user_response[:email]).to eql @user_attributes[:email]
		end

		it { should respond_with 201 } 

    end

    context "when it is not created" do
    	before(:each) do
    		@invalid_user_attributes = { password: "123546", password_confirmation: "123456"}
    		post :create, { user: @invalid_user_attributes }, format: :json
    	end

    	it "renders an error json" do
    		user_response = JSON.parse(response.body, symbolize_names: true)
    		expect(user_response).to have_key(:errors)
    	end

    	it "renders the json error when the user could not be created" do
    		user_response = JSON.parse(response.body, symbolize_names: true)
    		expect(user_response[:errors][:email]).to include "can't be blank"
    	end 

    	it { should respond_with 422 }
	end

end

end