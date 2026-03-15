require "test_helper"

class MaintenanceRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get maintenance_requests_path
    assert_response :success
  end

  test "should get new" do
    get new_maintenance_request_path
    assert_response :success
  end

  test "should get create" do
    post maintenance_requests_path
    assert_response :success
  end

  test "should get mark_tenant_caused" do
    request = maintenance_requests(:one)
    patch mark_tenant_caused_maintenance_request_path(request)
    assert_response :success
  end

  test "should get close" do
    request = maintenance_requests(:one)
    patch close_maintenance_request_path(request)
    assert_response :success
  end
end
