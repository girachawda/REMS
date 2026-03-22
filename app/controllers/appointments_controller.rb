# Book and manage unit viewing appointments
class AppointmentsController < ApplicationController
  before_action :require_login

  # Agents see appointments on their schedule, tenants see their booked appointments
  def index
    if current_user.leasing_agent?
      @appointments = Appointment
                        .includes(unit: :property, availability: :user)
                        .joins(:availability)
                        .where(availabilities: { user: current_user.id })
    else
      @appointments = current_user.appointments.includes(:unit, :availability).order(scheduled_at: :desc)
    end
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

  # Tenant books an appointment to view a unit
  def create
    @appointment = current_user.appointments.build(appointment_params)
    @appointment.status = :pending

    if @appointment.save
      redirect_to appointments_path, notice: "Appointment scheduled successfully"
    else
      @unit = @appointment.unit
      @availabilities = Availability.where(property: @unit&.property)
                                   .where("start_time >= ?", Time.now)
                                   .order(:start_time)
      render :new, status: :unprocessable_entity
    end
  end

  # Update appointment status (confirm, cancel, complete)
  def update
    @appointment = Appointment.find(params[:id])

    unless owns_appointment?(@appointment)
      redirect_to appointments_path, alert: "Not authorized"
      return
    end

    if @appointment.update(status: params[:status])
      redirect_to appointments_path, notice: "Appointment updated"
    else
      redirect_to appointments_path, alert: "Update failed"
    end
  end

  # Check if user is allowed to modify this appointment
  def owns_appointment?(appointment)
    if current_user.leasing_agent?
      appointment.availability.user.id == current_user.id
    else
      appointment.user_id == current_user.id
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:unit_id, :availability_id, :scheduled_at)
  end
end
