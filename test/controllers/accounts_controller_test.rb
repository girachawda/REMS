require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "should get index" do
    get accounts_path
    assert_redirected_to account_path(accounts(:one))
  end

  test "should get show" do
    get accounts_path(accounts(:one))
    assert_response :redirect
  end

  test "should get update" do
    account = accounts(:one)
    patch account_path(account)
    assert_response :success
  end
end
