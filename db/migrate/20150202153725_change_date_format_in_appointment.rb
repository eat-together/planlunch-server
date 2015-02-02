class ChangeDateFormatInAppointment < ActiveRecord::Migration
  def change
    change_column :appointments, :date, :datetime
  end
end
