class ChangeTypeOfTimeToString < ActiveRecord::Migration
  def change
    change_column :appointments, :time, :string
  end
end
