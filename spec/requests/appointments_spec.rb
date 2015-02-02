require 'rails_helper'

RSpec.describe "Appointments", :type => :request do
  describe "POST /appointments" do
    it "adds an appointment" do
      expect {
        post appointments_path, {appointment: {user_id: 1, place_id: 1, date: Time.zone.now}}
      }.to change(Appointment, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "changes the time and place of an appointment if one for same user exists on the same day" do
      twelveAm = DateTime.new(2015, 4, 2, 12, 15, 0)
      onePm = twelveAm + 1.hour
      Appointment.create(user_id: 1, place_id: 1, date: twelveAm)

      post appointments_path, {appointment: {user_id: 1, place_id: 2, date: onePm}}

      expect(response).to have_http_status(:ok)
      expect(Appointment.count).to eq(1)
      expect(Appointment.first.date).to eq(onePm)
      expect(Appointment.first.place_id).to eq(2)
    end
  end
end
