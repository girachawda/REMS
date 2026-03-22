require "test_helper"

class LeaseApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  test "TC-0053 - View Application Status" do
    application = rental_applications(:one)
    get lease_applications_path(application.id)
    assert_response :success
  end

  test "TC-017 - Digital Rental Applications Submits" do
    assert_difference("RentalApplication.count") do
      post lease_applications_path, params: {
        rental_application: {
          unit_id: rental_applications(:one).unit_id,
          start_date: rental_applications(:one).start_date,
          end_date: rental_applications(:one).end_date,
          duration: rental_applications(:one).duration
        }
      }
    end

    created = RentalApplication.order(:id).last
    assert_equal @user.id, created.user_id
    assert_equal rental_applications(:one).unit_id, created.unit_id
    assert_equal "pending", created.status
    assert_response :redirect
  end

  test "TC-0054 - Review Application" do
    login_as(users(:admin))
    application = rental_applications(:one)
    get lease_applications_path(application.id)
    assert_response :success
  end

  test "TC-0055 - Approve Application" do
    login_as(users(:admin))
    application = rental_applications(:one)
    assert_difference("Lease.count", +1) do
      patch approve_lease_application_path(application)
    end
    assert_response :redirect

    application.reload
    assert_equal "approved", application.status

    created_lease = Lease.order(:id).last
    assert_equal application.user_id, created_lease.user_id
    assert_equal application.unit_id, created_lease.unit_id
    assert_equal application.start_date, created_lease.start_date
    assert_equal application.end_date, created_lease.end_date
    assert_equal application.duration, created_lease.duration
  end

  test "TC-0056 - Reject Application" do
    login_as(users(:admin))
    application = rental_applications(:one)
    patch reject_lease_application_path(application), params: {
      rental_application: {
        rejection_reason: "Womp womp"
      }
    }
    assert_response :redirect

    application.reload
    assert_equal "rejected", application.status
    assert_equal "Womp womp", application.rejection_reason
  end
end
