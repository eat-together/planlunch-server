require 'rails_helper'

RSpec.describe "Appointments", :type => :request do

  describe "GET /appointments" do
    it "returns all appointments from today grouped by place and time as json" do
      user1 = User.create(name: 'aaa', email: 'foo', password: 'foo')
      user2 = User.create(name: 'bbb', email: 'foo', password: 'foo')
      user3 = User.create(name: 'ccc', email: 'foo', password: 'foo')
      user4 = User.create(name: 'ddd', email: 'foo', password: 'foo')
      Appointment.create(user: user1, place_id: 1, time: "12:00", date: Time.zone.now)
      Appointment.create(user: user2, place_id: 1, time: "12:00", date: Time.zone.now)
      Appointment.create(user: user3, place_id: 1, time: "12:15", date: Time.zone.now)
      Appointment.create(user: user4, place_id: 2, time: "12:15", date: Time.zone.now)

      get appointments_path

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json[0]["place_id"]).to eq(1)
      expect(json[1]["place_id"]).to eq(2)
      expect(json[0]["time_slots"]).to eq([{"time" => "12:00", "users" => ['aaa', 'bbb']}, {"time" => "12:15", "users" => ['ccc']}])
      expect(json[1]["time_slots"]).to eq([{"time" => "12:15", "users" => ['ddd']}])
    end
  end

  describe "POST /appointments" do
    it "adds an appointment for user with token" do
      user = User.create(name: 'foo', email: 'foo', password: 'foo')
      expect {
        post appointments_path, {place_id: 1, time: "12:00"}, {Authorization: "Token token=\"#{user.token}\""}
      }.to change(Appointment, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(Appointment.last.user_id).to eq(user.id)
    end

    it "changes the time and place of an appointment if one for same user exists on the same day" do
      onePm = "13:00"
      user = User.create(name: 'foo', email: 'foo', password: 'foo')
      Appointment.create(user_id: user.id, place_id: 1, time: "12:00", date: Time.zone.now)

      post appointments_path, {place_id: 2, time: onePm}, {Authorization: "Token token=\"#{user.token}\""}

      expect(response).to have_http_status(:ok)
      expect(Appointment.count).to eq(1)
      expect(Appointment.first.time).to eq(onePm)
      expect(Appointment.first.place_id).to eq(2)
    end

    it "responds with 401 if user token is not valid" do
      post appointments_path, {place_id: 1, time: "12:00"}, {Authorization: "Token token=\"invalid token\""}

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /appointments" do
    it "removes the todays appointment for user with token" do
      user = User.create(name: 'foo', email: 'foo', password: 'foo')
      Appointment.create(user_id: user.id, place_id: 1, time: "12:00", date: Time.zone.now)

      delete appointment_path(1), nil, {Authorization: "Token token=\"#{user.token}\""}

      expect(response).to have_http_status(:ok)
      expect(Appointment.count).to eq(0)
    end

    it "responds with 200 if no appointment for user is present" do
      user = User.create(name: 'foo', email: 'foo', password: 'foo')
      delete appointment_path(1), nil, {Authorization: "Token token=\"#{user.token}\""}
      expect(response).to have_http_status(:ok)
    end

    it "responds with 401 if user token is not valid" do
      delete appointment_path(1), nil, {Authorization: "Token token=\"invalid token\""}

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
