require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "should get index" do
    get appointments_path
    assert_response :success
  end

  test "should get new" do
    get new_appointment_path
    assert_response :success
  end

  test "TC-0012 - Booking Appointment - Available Slot" do
    assert_difference("Appointment.count") do
      post appointments_path, params: {
        appointment: {
          unit_id: units(:one).id,
          availability_id: availabilities(:one).id,
          scheduled_at: 1.day.from_now
        }
      }
    end
    assert_redirected_to appointments_path
  end

  test "TC-0016 - Booking Appointment - Double Booked Slot" do
    assert_difference("Appointment.count") do
      post appointments_path, params: {
        appointment: {
          unit_id: units(:one).id,
          availability_id: availabilities(:one).id,
          scheduled_at: 1.day.from_now
        }
      }
    end
    assert_redirected_to appointments_path

    assert_same("Appointment.count") do
      post appointments_path, params: {
        appointment: {
          unit_id: units(:one).id,
          availability_id: availabilities(:one).id,
          scheduled_at: 1.day.from_now
        }
      }
    end
    assert_redirected_to appointments_path
  end
end
