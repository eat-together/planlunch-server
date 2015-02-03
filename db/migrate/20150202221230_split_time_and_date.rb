class SplitTimeAndDate < ActiveRecord::Migration
  def change
    add_column :appointments, :time, :time
    change_column :appointments, :date, :date
  end
end
