require "test_helper"

class MaintenanceRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get submit_rquest" do
    get maintenance_requests_submit_rquest_url
    assert_response :success
  end

  test "should get list_queue" do
    get maintenance_requests_list_queue_url
    assert_response :success
  end

  test "should get prioritize_queue" do
    get maintenance_requests_prioritize_queue_url
    assert_response :success
  end

  test "should get mark_tenant_caused" do
    get maintenance_requests_mark_tenant_caused_url
    assert_response :success
  end

  test "should get close_request" do
    get maintenance_requests_close_request_url
    assert_response :success
  end
end
