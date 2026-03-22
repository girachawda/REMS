require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  test "TC-025 - Rent is collected on monthly cycle" do
    login_as(users(:admin))
    unit = units(:one)
    account = accounts(:cycle_monthly)

    expected = unit.rental_rate
    assert_difference("Payment.where(account: account, method: 'automatic').count", +1) do
      get account_path(account)
    end
  end

  test "TC-026 - Rent is collected on quarterly cycle" do
    login_as(users(:admin))
    unit = units(:one)
    account = accounts(:cycle_quarterly)

    expected = unit.rental_rate.to_f * 3
    assert_difference("Payment.where(account: account, method: 'automatic').count", +1) do
      get account_path(account)
    end
  end

  test "TC-027 - Rent is collected on bi-annual cycle" do
    login_as(users(:admin))
    unit = units(:one)
    account = accounts(:cycle_bi_annually)

    expected = unit.rental_rate.to_f * 6
    assert_difference("Payment.where(account: account, method: 'automatic').count", +1) do
      get account_path(account)
    end
  end

  test "TC-028 - Rent is collected on annual cycle" do
    login_as(users(:admin))
    unit = units(:one)
    account = accounts(:cycle_annually)

    expected = unit.rental_rate.to_f * 12
    assert_difference("Payment.where(account: account, method: 'automatic').count", +1) do
      get account_path(account)
    end
  end

  test "TC-029 - Discount rate is applied" do
    login_as(users(:admin))
    unit = units(:one)
    discount = 10.0
    account = accounts(:cycle_monthly)

    account.update!(discount_percent: discount)

    expected = unit.rental_rate.to_f * (1 - (discount / 100.0))
    assert_difference("Payment.where(account: account, method: 'automatic').count", +1) do
      get account_path(account)
    end

    payment = Payment.where(account: account, method: "automatic").order(:id).last
    assert_same expected, payment.amount.to_f
  end

  test "TC-030 - Tenant payments are tracked" do
    login_as(users(:admin))
    account = accounts(:tracking_account)
    tenant = account.user
    invoice = invoices(:tracking_rent_invoice)

    assert_equal "unpaid", invoice.status

    get account_path(account)
    assert_response :success

    assert_equal "paid", invoice.reload.status
  end

  test "TC-031 - Notifications generated when payment overdue" do
    account = accounts(:one)
    overdue_invoice = invoices(:overdue_unpaid_rent_invoice)

    assert_equal "unpaid", overdue_invoice.status

    get account_path(account)
    assert_response :success

    assert_includes response.body, "Outstanding invoices have passed the due date. Please pay as soon as possible."

    assert_equal "overdue", overdue_invoice.reload.status
  end
end
