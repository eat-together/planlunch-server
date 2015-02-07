class AppointmentsController < ApplicationController

  def index
    today = Time.zone.now.strftime("%Y-%m-%d")

    # TODO does its job but looks horrible, refactor!
    todays_appointments = Appointment.where(date: today)
    grouped_by_place = todays_appointments.group_by{|a| a.place_id}
    grouped_by_place.each_pair do |place_id, appointments|
      grouped_by_place[place_id] = appointments.group_by{|app| app.time}
      grouped_by_place[place_id].each_pair do |time, apps|
        grouped_by_place[place_id][time] = apps.map{|app| app.user.name}
      end
    end
    result = []
    grouped_by_place.each_pair do |k,v|
      result << {
        place_id: k,
        time_slots: v.map{|a,b| {time: a, users: b}}
      }
    end

    render json: result, status: :ok
  end

  def create
    user = User.where(token: appointment_params[:user_token]).first
    if user.present?
      today = Time.zone.now.strftime("%Y-%m-%d")
      appointment = Appointment.where(user_id: user.id, date: today).first
      if appointment.present?
        appointment.update(place_id: appointment_params[:place_id], time: appointment_params[:time])
        render json: appointment, status: :ok, location: appointment
      else
        @appointment = Appointment.create(user_id: user.id, place_id: appointment_params[:place_id], time: appointment_params[:time], date: today)
        render json: @appointment, status: :created, location: @appointment
      end
    else
      render json: {}, status: :unauthorized
    end
  end

  def destroy
    user = User.where(token: params[:id]).first
    if user.present?
      today = Time.zone.now.strftime("%Y-%m-%d")
      appointment = Appointment.where(user_id: user.id, date: today).first
      appointment.destroy if appointment.present?
    else
      render json: {}, status: :unauthorized
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:user_token, :place_id, :time)
  end
end
