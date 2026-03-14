require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  test "should get list_tenant_invoices" do
    get invoices_list_tenant_invoices_url
    assert_response :success
  end

  test "should get generate_invoice" do
    get invoices_generate_invoice_url
    assert_response :success
  end

  test "should get record_payment" do
    get invoices_record_payment_url
    assert_response :success
  end

  test "should get mark_overdue" do
    get invoices_mark_overdue_url
    assert_response :success
  end
end
