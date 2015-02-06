class Appointment < ActiveRecord::Base
  validate :permitted_values_for_time

  belongs_to :user

  private

  def permitted_values_for_time
    if !time.in? ["11:45", "12:00", "12:15", "12:30", "12:45", "13:00"]
      errors.add(:time, "invalid time")
    end
  end
end
