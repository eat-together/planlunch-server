class AppointmentsController < ApplicationController

  def index
    today = Time.zone.now.strftime("%Y-%m-%d")

    # TODO does its job but looks horrible, refactor!
    todays_appointments = Appointment.where(date: today)
    grouped_by_place = todays_appointments.group_by{|a| a.place_id}
    grouped_by_place.each_pair do |place_id, appointments|
      grouped_by_place[place_id] = appointments.group_by{|app| app.time}
      grouped_by_place[place_id].each_pair do |time, apps|
        grouped_by_place[place_id][time] = apps.map{|app| app.user_id}
      end
    end
    result = []
    grouped_by_place.each_pair do |k,v|
      result << {
        place_id: k,
        time_slots: v
      }
    end

    render json: result, status: :ok
  end

  def create
    today = Time.zone.now.strftime("%Y-%m-%d")
    appointment = Appointment.where(user_id: appointment_params[:user_id], date: today).first
    if appointment.present?
      appointment.update(place_id: appointment_params[:place_id], time: appointment_params[:time])
      render json: appointment, status: :ok, location: appointment
    else 
      @appointment = Appointment.create(appointment_params.merge(date: today))
      render json: @appointment, status: :created, location: @appointment
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:user_id, :place_id, :time)
  end
end
