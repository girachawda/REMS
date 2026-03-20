require "test_helper"

class AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "should get index" do
    get availabilities_path
    assert_response :success
  end

  test "should get new" do
    get new_availability_path
    assert_response :success
  end

  test "TC-0013 - Input Viewing Availability" do
    assert_difference("Availability.count") do
      post availabilities_path, params: {
        availability: {
          property_id: properties(:one).id,
          start_time: 1.day.from_now,
          end_time: 1.day.from_now + 2.hours
        }
      }
    end
    assert_redirected_to availabilities_path
  end
end
