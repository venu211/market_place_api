require 'spec_helper'

describe Api::V1::UsersController do

#before(:each) { request.headers["Accept"] = "application/vnd.marketplace.v1, #{Mime::JSON}" }
#before(:each) { request.headers["Content-Type"] = Mime::JSON.to_s }
before(:each) do
	@user = FactoryGirl.create(:user)
	request.headers["Authorization"] = @user.auth_token
end

describe "Get #show" do 
	before(:each) do
		get :show, id: @user.id
	end

	it "returns the info about the reporter on a hash" do
		user_response = json_response
		expect(user_response[:user][:email]).to eql @user.email
	end

	it { should respond_with 200 }
end

describe "POST #create" do

	context "When it is successfully created" do
		before(:each) do
			@user_attributes = FactoryGirl.attributes_for(:user)
			post :create, { user: @user_attributes }
		end

		it "renders the json representation for the user record just created" do 
		user_response = json_response
		expect(user_response[:user][:email]).to eql @user_attributes[:email]
		end

		it { should respond_with 201 } 

    end

    context "when it is not created" do
    	before(:each) do
    		@invalid_user_attributes = { password: "123546", password_confirmation: "123456"}
    		post :create, { user: @invalid_user_attributes }
    	end

    	it "renders an error json" do
    		user_response = json_response
    		expect(user_response).to have_key(:errors)
    	end

    	it "renders the json error when the user could not be created" do
    		user_response = json_response
    		expect(user_response[:errors][:email]).to include "can't be blank"
    	end 

    	it { should respond_with 422 }
	end

end

describe "PUT/PATCH	#update" do

	context "when it is successfully updated" do
 		before(:each) do
 			patch :update, { id: @user.id, user: { email: "newmail@example.com"} }
 		end
 
 	it "Renders the json representation for the updated user" do
 		user_response = json_response
 		expect(user_response[:user][:email]).to eql "newmail@example.com"
 	end

 	it { should respond_with 200}
	end

	context "when it is not created" do 
	 	before(:each) do 
	 		patch :update, { id: @user.id, user: { email: "bademail.com"} }
	 	end

	 	it "renders an error json" do
	 		user_response = json_response
	 		expect(user_response).to have_key(:errors)
	 	end

	 	it "renders the json error when the user updated is not created" do
	 		user_response = json_response
	 		expect(user_response[:errors][:email]).to include "is invalid"
	 	end

	 	it { should respond_with 422 }
	end
end

describe "DELETE #destroy" do
	before(:each) do
		delete :destroy, { id: @user.id }
	end

	it { should respond_with 204}
end

end