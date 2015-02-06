require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "POST /users" do
    it "adds a user and sends back her token" do
      expect {
        post users_path, {user: {name: "foo", email: "foo@bar.invalid", password: "bar"}}
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["token"]).to eq(User.last.token)
    end
  end
end
