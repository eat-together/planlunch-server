require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "GET /login" do
    it "responds with user token if credentials are correct" do
      user = User.create(name: 'foo', email: 'foo', password: 'foo')

      get '/login', nil, {Authorization: user.name + ':' + user.password}

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["token"]).to eq(user.token)
    end

    it "responds with 401 if credentials are incorrect" do
      user = User.create(name: 'foo', password: 'bar')

      get '/login', nil, {Authorization: user.name + ':' + 'wrong password'}

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
