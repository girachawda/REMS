require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "TC-0062 - Log-in to tenant account" do
    user = users(:one)
    post login_path, params: { email: user.email, password: "password" }

    assert_redirected_to root_path

    follow_redirect!
    assert_response :success
    assert_includes response.body, "Logged in successfully"
  end

  test "TC-0063 - Log-in to admin account" do
    admin = users(:two)
    post login_path, params: { email: admin.email, password: "password" }

    assert_redirected_to root_path

    follow_redirect!
    assert_response :success
    assert_includes response.body, "Logged in successfully"
  end

  test "TC-0064 - Tenant cannot access admin features" do
    tenant = users(:one)
    post login_path, params: { email: tenant.email, password: "password" }

    get root_path
    assert_response :success

    refute_includes response.body, "Accounts"
  end

  test "TC-0065 - Admin cannot access tenant features" do
    admin = users(:two)
    post login_path, params: { email: admin.email, password: "password" }

    get root_path
    assert_response :success

    refute_includes response.body, "Payment"
    refute_includes response.body, "Invoices"
  end

  test "TC-0066 - User logout" do
    tenant = users(:one)
    post login_path, params: { email: tenant.email, password: "password" }

    delete logout_path
    assert_redirected_to login_path

    get accounts_path
    assert_redirected_to login_path
  end
end
