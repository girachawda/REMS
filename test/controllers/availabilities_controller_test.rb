require "test_helper"

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "TC-0051 - View Appointment Availability" do
    agent_availability = availabilities(:one)

    get property_unit_path(properties(:one), units(:one))
    assert_response :success
    assert_includes response.body, "Agent User"
    assert_includes response.body, "Schedule a Viewing"
    assert_not_includes response.body, "No agent availability at this time."
  end

  test "TC-0013 - Input Viewing Availability" do
    start_time = Time.new(2026, 3, 15, 10, 0, 0)
    end_time = Time.new(2026, 3, 15, 12, 0, 0)
    assert_difference("Availability.count") do
      post availabilities_path, params: {
        availability: {
          property_id: properties(:one).id,
          start_time: start_time,
          end_time: end_time
        }
      }
    end
    assert_redirected_to availabilities_path

    created = Availability.order(:id).last
    assert_equal start_time.to_i, created.start_time.to_i
    assert_equal end_time.to_i, created.end_time.to_i
  end
end
