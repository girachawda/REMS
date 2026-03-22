require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "TC-0012 - Booking Appointment - Available Slot" do
    get properties_path

    availability = availabilities(:one)
    unit = units(:one)
    scheduled_at = availability.start_time + 1.hour

    assert_difference("Appointment.count", 1) do
      post appointments_path, params: {
        appointment: {
          unit_id: unit.id,
          availability_id: availability.id,
          scheduled_at: scheduled_at
        }
      }
    end

    assert_redirected_to appointments_path
  end

  test "TC-016 - Booking Appointment - Double Booked Slot" do
    scheduled_at = 1.day.from_now
    assert_difference("Appointment.count") do
      post appointments_path, params: {
        appointment: {
          unit_id: units(:one).id,
          availability_id: availabilities(:one).id,
          scheduled_at: scheduled_at
        }
      }
    end
    assert_redirected_to appointments_path

    assert_no_difference("Appointment.count") do
      post appointments_path, params: {
        appointment: {
          unit_id: units(:one).id,
          availability_id: availabilities(:one).id,
          scheduled_at: scheduled_at
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "TC-0052 - Cancel Appointment" do
    appointment = appointments(:one)
    assert_equal "pending", appointment.status

    patch appointment_path(appointment), params: { status: "cancelled" }
    assert_redirected_to appointments_path

    appointment.reload
    assert_equal "cancelled", appointment.status
  end
end
