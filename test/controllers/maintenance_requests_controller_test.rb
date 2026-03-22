require "test_helper"

class MaintenanceRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tenant = users(:one)
    post login_path, params: { email: @tenant.email, password: "password" }
  end

  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  test "TC-035 - Maintenance request is submitted" do
    template = maintenance_requests(:one)

    assert_difference("MaintenanceRequest.count", +1) do
      post maintenance_requests_path, params: {
        maintenance_request: {
          priority: template.priority,
          is_emergency: template.is_emergency,
          is_routine: template.is_routine,
          unit_id: template.unit.id
        }
      }
    end

    assert_response :success
    assert_includes response.body, "Maintenance Request Submitted"
    assert_includes response.body, "View All Requests"
  end

  test "TC-036 - Maintenance request notifies leasing agent" do
    login_as(users(:admin))

    template = maintenance_requests(:one)
    assert_difference("MaintenanceRequest.count", +1) do
      post maintenance_requests_path, params: {
        maintenance_request: {
          priority: template.priority,
          is_emergency: template.is_emergency,
          is_routine: template.is_routine,
          unit_id: template.unit.id
        }
      }
    end

    created_request = MaintenanceRequest.order(:id).last

    login_as(users(:two))
    get maintenance_requests_path
    assert_response :success

    assert_includes response.body, "#{created_request.id}"
  end

  test "TC-0061 - Show maintenance queue" do
    login_as(users(:admin))
    get maintenance_requests_path
    assert_response :success

    expected = [
      maintenance_requests(:emergency_older).id,
      maintenance_requests(:emergency_newer).id,
      maintenance_requests(:one).id,
      maintenance_requests(:two).id
    ]

    body = response.body
    indices = expected.map { |id| body.index("#{id}") }
    assert indices.all?
    assert_equal indices.sort, indices
  end

  test "TC-037 - Maintenance request is prioritized if emergency" do
    login_as(users(:admin))
    get maintenance_requests_path
    assert_response :success

    body = response.body
    older_id = maintenance_requests(:emergency_older).id
    newer_id = maintenance_requests(:emergency_newer).id

    assert_operator body.index("#{older_id}"), :<, body.index("#{newer_id}")
  end

  test "TC-038 - Maintenance requests are ordered by submission date" do
    login_as(users(:admin))
    get maintenance_requests_path
    assert_response :success

    body = response.body

    e_old = maintenance_requests(:emergency_older).id
    e_new = maintenance_requests(:emergency_newer).id
    r_one = maintenance_requests(:one).id
    r_two = maintenance_requests(:two).id

    assert_operator body.index("#{e_old}"), :<, body.index("#{e_new}")
    assert_operator body.index("#{r_one}"), :<, body.index("#{r_two}")
  end

  test "TC-039 - Maintenance requests can be marked as tenant-caused" do
    request = maintenance_requests(:one)
    account = request.user.account
    starting_balance = account.balance

    assert_difference -> { Invoice.where(account: account, charge_type: "maintenance").count }, +1 do
      patch mark_tenant_caused_maintenance_request_path(request)
    end

    assert_response :redirect
    request.reload
    assert_equal true, request.tenant_caused
    assert_equal starting_balance + request.maintenance_cost, account.reload.balance

    get maintenance_requests_path
    assert_response :success
    assert_includes response.body, "#{request.id}"
    assert_includes response.body, "Yes"
    assert_includes response.body, "$#{format('%.2f', request.maintenance_cost.to_f)}"
  end

  test "TC-0060 - Close maintenance request" do
    request = maintenance_requests(:one)
    patch close_maintenance_request_path(request, "closed")
    assert_response :redirect

    get maintenance_requests_path
    assert_response :success
    assert_includes response.body, "#{request.id}"
    assert_includes response.body, "Closed"
  end
end
