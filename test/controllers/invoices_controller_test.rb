require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end
  
  test "should get index" do
    get invoices_path
    assert_response :success
  end

  test "should get show" do
    get invoices_path(1)
    assert_response :success
  end

  test "should get create" do
    lease = leases(:one)
    post invoices_path, params: {
      total_charge: 100,
      due_date: Date.today,
      lease_id: lease.id,
      charge_type: "rent"
    }
    assert_response :redirect
  end

  test "should get record_payment" do
    invoice = invoices(:one)
    patch record_payment_invoice_path(invoice)
    assert_response :redirect
  end

  test "should get mark_overdue" do
    invoice = invoices(:one)
    patch mark_overdue_invoice_path(invoice)
    assert_response :redirect
  end
end
