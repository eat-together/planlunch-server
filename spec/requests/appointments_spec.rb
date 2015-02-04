require 'rails_helper'

RSpec.describe "Appointments", :type => :request do

  describe "GET /appointments" do
    it "returns all appointments from today grouped by place and time as json" do
      Appointment.create(user_id: 1, place_id: 1, time: "12:00", date: Time.zone.now)
      Appointment.create(user_id: 2, place_id: 1, time: "12:00", date: Time.zone.now)
      Appointment.create(user_id: 3, place_id: 1, time: "12:15", date: Time.zone.now)
      Appointment.create(user_id: 4, place_id: 2, time: "12:15", date: Time.zone.now)

      get appointments_path

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json[0]["place_id"]).to eq(1)
      expect(json[1]["place_id"]).to eq(2)
      expect(json[0]["time_slots"]["12:00"]).to eq([1, 2])
      expect(json[0]["time_slots"]["12:15"]).to eq([3])
      expect(json[1]["time_slots"]["12:15"]).to eq([4])
    end
  end

  describe "POST /appointments" do
    it "adds an appointment" do
      expect {
        post appointments_path, {appointment: {user_id: 1, place_id: 1, time: "12:00"}}
      }.to change(Appointment, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "changes the time and place of an appointment if one for same user exists on the same day" do
      onePm = "13:00"
      Appointment.create(user_id: 1, place_id: 1, time: "12:00", date: Time.zone.now)

      post appointments_path, {appointment: {user_id: 1, place_id: 2, time: onePm}}

      expect(response).to have_http_status(:ok)
      expect(Appointment.count).to eq(1)
      expect(Appointment.first.time).to eq(onePm)
      expect(Appointment.first.place_id).to eq(2)
    end
  end
end
