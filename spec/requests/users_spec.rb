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

    it "responds with a 422 if user with that name already exists" do
      User.create(name: 'foo', email: 'foo', password: 'foo')
      post users_path, {user: {name: "foo", email: "foo@bar.invalid", password: "bar"}}
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "responds with a 422 if name is empty" do
      post users_path, {user: {name: "", email: "foo@bar.invalid", password: "bar"}}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
