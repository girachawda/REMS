require "test_helper"

class MaintenanceRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "should get index" do
    get maintenance_requests_path
    assert_response :success
  end

  test "should get new" do
    get new_maintenance_request_path
    assert_response :success
  end

  test "should get create" do
    maintenance_request = maintenance_requests(:one)
    post maintenance_requests_path, params: {
      maintenance_request: {
        priority: maintenance_request.priority,
        is_emergency: maintenance_request.is_emergency,
        maintenance_cost: maintenance_request.maintenance_cost,
        tenant_caused: maintenance_request.tenant_caused,
        unit_id: maintenance_request.unit.id
      }
    }
    assert_response :success
  end

  test "should get mark_tenant_caused" do
    request = maintenance_requests(:one)
    patch mark_tenant_caused_maintenance_request_path(request)
    assert_response :success
  end

  test "should get close" do
    request = maintenance_requests(:one)
    patch close_maintenance_request_path(request, "closed")
    assert_response :success
  end
end
