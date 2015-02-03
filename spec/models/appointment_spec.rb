require 'rails_helper'

RSpec.describe "Appointment", :type => :model do

  describe "time can only have values from 11:45 to 13:00 in steps of 15 minutes" do

    it "positive" do
      ["11:45", "12:00", "12:15", "12:30", "12:45", "13:00"].each do |time|
        expect(Appointment.new(time: time)).to be_valid
      end
    end

    it "negative" do
      ["11:30", "12:11", "12:44", "13:15"].each do |time|
        expect(Appointment.new(time: time)).to be_invalid
      end
    end

  end

end
