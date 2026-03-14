require "test_helper"

class LeaseAgreementControllerTest < ActionDispatch::IntegrationTest
  test "should get submit_appliication" do
    get lease_agreement_submit_appliication_url
    assert_response :success
  end

  test "should get review_applications" do
    get lease_agreement_review_applications_url
    assert_response :success
  end

  test "should get approve" do
    get lease_agreement_approve_url
    assert_response :success
  end

  test "should get reject" do
    get lease_agreement_reject_url
    assert_response :success
  end

  test "should get generate_lease" do
    get lease_agreement_generate_lease_url
    assert_response :success
  end
end
