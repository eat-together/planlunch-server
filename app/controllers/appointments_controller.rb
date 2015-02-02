class AppointmentsController < ApplicationController

  def create
    date = Time.zone.parse(appointment_params[:date])
    today = date.beginning_of_day..date.end_of_day

    appointment = Appointment.where(user_id: appointment_params[:user_id], date: today).first
    if appointment.present?
      appointment.update(place_id: appointment_params[:place_id], date: date)
      render json: appointment, status: :ok, location: appointment
    else 
      @appointment = Appointment.create(appointment_params)
      render json: @appointment, status: :created, location: @appointment
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:user_id, :place_id, :date)
  end
end
