require "test_helper"

class LeaseAgreementControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lease_agreements_path
    assert_response :success
  end

  test "should get new" do
    get new_lease_agreement_path
    assert_response :success
  end

  test "should get create" do
    post lease_agreements_path
    assert_response :success
  end

  test "should get approve" do
    lease = leases(:one)
    patch approve_lease_agreement_path(lease)
    assert_response :success
  end

  test "should get reject" do
    lease = leases(:one)
    patch reject_lease_agreement_path(lease)
    assert_response :success
  end

  test "should get generate_lease" do
    lease = leases(:one)
    post generate_lease_agreement_path(lease)
    assert_response :success
  end
end
