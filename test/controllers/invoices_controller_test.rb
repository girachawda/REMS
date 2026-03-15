require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get invoices_path
    assert_response :success
  end

  test "should get show" do
    get invoices_path(1)
    assert_response :success
  end

  test "should get create" do
    post invoices_path
    assert_response :success
  end

  test "should get record_payment" do
    invoice = invoices(:one)
    patch record_payment_invoice_path(invoice)
    assert_response :success
  end

  test "should get mark_overdue" do
    invoice = invoices(:one)
    patch mark_overdue_invoice_path(invoice)
    assert_response :success
  end
end
