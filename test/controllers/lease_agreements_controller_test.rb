require "test_helper"

class LeaseAgreementsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lease_agreements_path
    assert_response :success
  end

  test "should get show" do
    get lease_agreements_path(1)
    assert_response :success
  end

  test "should get new" do
    get new_lease_agreement_path
    assert_response :success
  end

  test "should get create" do
    application = rental_applications(:one)
    post lease_agreements_path, params: {
      id: application.id,
      renewal_policy: "Standard"
    }
    assert_response :success
  end

  test "should get update" do
    lease = leases(:one)
    patch lease_agreement_path(lease)
    assert_response :success
  end
end
