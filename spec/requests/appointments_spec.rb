require 'rails_helper'

RSpec.describe "Appointments", :type => :request do

  describe "GET /appointments" do
    it "returns all appointments from today grouped by place and time as json" do
      user1 = User.create(name: 'aaa')
      user2 = User.create(name: 'bbb')
      user3 = User.create(name: 'ccc')
      user4 = User.create(name: 'ddd')
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
      user = User.create(name: "foo")
      expect {
        post appointments_path, {appointment: {user_token: user.token, place_id: 1, time: "12:00"}}
      }.to change(Appointment, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(Appointment.last.user_id).to eq(user.id)
    end

    it "changes the time and place of an appointment if one for same user exists on the same day" do
      onePm = "13:00"
      user = User.create
      Appointment.create(user_id: user.id, place_id: 1, time: "12:00", date: Time.zone.now)

      post appointments_path, {appointment: {user_token: user.token, place_id: 2, time: onePm}}

      expect(response).to have_http_status(:ok)
      expect(Appointment.count).to eq(1)
      expect(Appointment.first.time).to eq(onePm)
      expect(Appointment.first.place_id).to eq(2)
    end
  end
end
