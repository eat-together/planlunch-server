class AppointmentsController < ApplicationController

  before_action :authenticate_request, only: [:create, :destroy]

  def index
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
    appointment = Appointment.where(user_id: @user.id, date: today).first
    if appointment.present?
      appointment.update(place_id: params[:place_id], time: params[:time])
      render json: appointment
    else
      appointment = Appointment.create(user_id: @user.id, place_id: params[:place_id], time: params[:time], date: today)
      render json: appointment, status: :created
    end
  end

  def destroy
    appointment = Appointment.where(user_id: @user.id, date: today).first
    appointment.destroy if appointment.present?
  end

  private

  def today
    Time.zone.now.strftime("%Y-%m-%d")
  end

  def authenticate_request
    token = ActionController::HttpAuthentication::Token.token_and_options(request)
    if token && token[0]
      user = User.where(token: token[0]).first
      if user.present?
        @user = user
      else
        render json: {}, status: :unauthorized
      end
    else
      render json: {}, status: :unauthorized
    end
  end

end
