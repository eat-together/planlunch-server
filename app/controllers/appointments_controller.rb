class AppointmentsController < ApplicationController

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
