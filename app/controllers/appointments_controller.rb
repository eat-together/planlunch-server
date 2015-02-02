class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :update, :destroy]

  # GET /appointments
  # GET /appointments.json
  def index
    @appointments = Appointment.all

    render json: @appointments
  end

  # GET /appointments/1
  # GET /appointments/1.json
  def show
    render json: @appointment
  end

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

  # PATCH/PUT /appointments/1
  # PATCH/PUT /appointments/1.json
  def update
    @appointment = Appointment.find(params[:id])

    if @appointment.update(appointment_params)
      head :no_content
    else
      render json: @appointment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/1
  # DELETE /appointments/1.json
  def destroy
    @appointment.destroy

    head :no_content
  end

  private

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def appointment_params
      params.require(:appointment).permit(:user_id, :place_id, :date)
    end
end
