require "test_helper"

class LeaseApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "should get index" do
    get lease_applications_path
    assert_response :success
  end

  test "should get show" do
    get lease_applications_path(1)
    assert_response :success
  end

  test "should get new" do
    get new_lease_application_path
    assert_response :success
  end

  test "should get create" do
    post lease_applications_path, params: {
      rental_application: {
        unit_id: rental_applications(:one).unit_id,
        start_date: rental_applications(:one).start_date,
        end_date: rental_applications(:one).end_date,
        duration: rental_applications(:one).duration
      }
    }
    assert_response :success
  end

  test "should get approve" do
    application = rental_applications(:one)
    patch approve_lease_application_path(application)
    assert_response :success
  end

  test "should get reject" do
    application = rental_applications(:one)
    patch reject_lease_application_path(application), params: {
      rejection_reason: "Womp womp"
    }
    assert_response :success
  end
end
