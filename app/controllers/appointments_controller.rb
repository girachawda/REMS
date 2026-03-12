class AppointmentsController < ApplicationController
  before_action :require_login

  def index
    @appointments = current_user.appointments.includes(:unit, :availability).order(scheduled_at: :desc)
  end

  def new
    @appointment = Appointment.new
    @unit = Unit.find(params[:unit_id]) if params[:unit_id]
    @availabilities = if @unit
                        Availability.where(property: @unit.property)
                                    .where("start_time >= ?", Time.now)
                                    .order(:start_time)
    else
                        []
    end
  end

  def create
    @appointment = current_user.appointments.build(appointment_params)
    @appointment.status = :pending

    if @appointment.save
      redirect_to appointments_path, notice: "Appointment scheduled successfully"
    else
      @unit = @appointment.unit∏
      @availabilities = Availability.where(property: @unit&.property)
                                   .where("start_time >= ?", Time.now)
                                   .order(:start_time)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:unit_id, :availability_id, :scheduled_at)
  end
end
