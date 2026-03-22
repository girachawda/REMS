require "test_helper"

class PaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "TC-0059 - Show tenant receipts" do
    Payment.create!(
      account: @user.account,
      amount: 123.45,
      method: "card",
      paid_at: Time.current
    )

    get payments_path
    assert_response :success
    assert_includes response.body, "$123.45"
    assert_includes response.body, "Card"
  end
end
