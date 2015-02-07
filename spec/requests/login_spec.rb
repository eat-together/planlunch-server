require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "GET /login" do
    it "responds with user token if credentials are correct" do
      user = User.create(name: 'foo', password: 'bar')

      get '/login', {name: user.name, password: user.password}

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["token"]).to eq(user.token)
    end

    it "responds with user token if credentials are correct" do
      user = User.create(name: 'foo', password: 'bar')

      get '/login', {name: user.name, password: 'wrong password'}

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
