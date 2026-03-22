require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "TC-0058 - Show tenant invoices" do
    get invoices_path
    assert_response :success
    assert_includes response.body, "unpaid"
    assert_includes response.body, "Unit #{units(:one).unit_number}"
  end

  test "TC-032 - Utility charges are tracked in database" do
    utility = utilities(:one)

    utility.update!(
      electricity_charges: 11.11,
      water_charges: 22.22,
      waste_management_charges: 33.33
    )

    reloaded = utility.reload
    assert_equal 11.11, reloaded.electricity_charges
    assert_equal 22.22, reloaded.water_charges
    assert_equal 33.33, reloaded.waste_management_charges
  end

  test "TC-033 - Monthly utility bill is created" do
    utility = utilities(:one)
    electricity = 11.11
    water = 22.22
    waste = 33.33
    total = electricity + water + waste

    utility.update!(
      electricity_charges: electricity,
      water_charges: water,
      waste_management_charges: waste
    )

    lease = leases(:one)

    assert_difference -> { Invoice.where(lease: lease, charge_type: "utility").count }, +1 do
      post invoices_path, params: {
        total_charge: total,
        due_date: Date.current + 10.days,
        lease_id: lease.id,
        charge_type: "utility"
      }
    end

    follow_redirect!
    assert_response :success

    assert_includes response.body, "Utility Breakdown"
    total_amount = format("$%.2f", total.to_f)
    assert_includes response.body, total_amount
  end

  test "TC-034 - Monthly utility invoice is sent" do
    utility = utilities(:one)

    electricity = 9.99
    water = 9.99
    waste = 9.99

    utility.update!(
      electricity_charges: 9.99,
      water_charges: 9.99,
      waste_management_charges: 9.99
    )

    lease = leases(:one)
    total = electricity + water + waste

    post invoices_path, params: {
      total_charge: total,
      due_date: Date.current + 10.days,
      lease_id: lease.id,
      charge_type: "utility"
    }

    follow_redirect!
    assert_response :success

    assert_includes response.body, "New invoice generated"
    assert_includes response.body, "Utility Breakdown"
    total_amount = format("$%.2f", total.to_f)
    assert_includes response.body, total_amount
  end
end
