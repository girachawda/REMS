require "test_helper"

class LeaseAgreementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
    post login_path, params: { email: @user.email, password: "password" }
  end

  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  test "TC-018 - Create a Lease Agreement" do
    login_as(users(:admin))

    application = rental_applications(:approved_duration_3)
    assert_difference("Lease.count", +1) do
      patch approve_lease_application_path(application)
    end

    assert_response :redirect
    follow_redirect!
    assert_response :success

    created_lease = Lease.order(:id).last
    assert_equal application.duration, created_lease.duration
    assert_equal application.start_date, created_lease.start_date
    assert_equal application.end_date, created_lease.end_date
  end

  test "TC-0057 - Activate Lease" do
    lease = leases(:inactive)
    patch lease_agreement_path(lease)
    assert_response :success

    lease.reload
    assert_equal true, lease.active
  end

  test "TC-019 - Send a Lease Agreement (Leasing Agent)" do
    login_as(users(:admin))

    lease = leases(:one)
    patch lease_agreement_path(lease)
    assert_response :success

    lease.reload
    assert_equal true, lease.active
  end

  test "TC-020 - Sign a Lease Agreement (Tenant)" do
    login_as(users(:one))

    lease = leases(:two)
    patch lease_agreement_path(lease)
    assert_response :success

    lease.reload
    assert_equal true, lease.active
  end

  test "TC-022 - Sign a Lease Agreement (Leasing Agent)" do
    login_as(users(:two))

    lease = leases(:two)
    patch lease_agreement_path(lease)
    assert_response :success

    lease.reload
    assert_equal true, lease.active
  end

  test "TC-023 - Lease Duration is Tracked Accurately" do
    rental_application = rental_applications(:approved_duration_3)

    assert_difference("Lease.count", +1) do
      patch approve_lease_application_path(rental_application)
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success

    created_lease = Lease.order(:id).last
    assert_equal rental_application.duration, created_lease.duration
  end

  test "TC-024 - Renewals are Handled Automatically" do
    lease = leases(:expired_automatic_lease)
    original_end_date = lease.end_date

    get lease_agreement_path(lease)
    assert_response :success

    lease.reload
    assert_equal original_end_date >> 12, lease.end_date
    assert_equal true, lease.active
  end
end
