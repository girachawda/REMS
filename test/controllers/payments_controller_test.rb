require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end
  
  test "should get index" do
    get payments_path
    assert_response :success
  end

  test "should get new" do
    get new_payment_path
    assert_response :success
  end
end
