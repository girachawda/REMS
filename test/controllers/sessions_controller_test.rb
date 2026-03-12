require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should create session with valid credentials" do
    user = users(:one)
    post login_path, params: { email: user.email, password: "password" }
    assert_redirected_to root_path
  end

  test "should destroy session" do
    delete logout_path
    assert_redirected_to login_path
  end
end
