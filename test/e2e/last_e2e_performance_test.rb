require "test_helper"
require "securerandom"
require "benchmark"

class LastE2ePerformanceTest < ActionDispatch::IntegrationTest
  def login_as(user)
    post login_path, params: { email: user.email, password: "password" }
  end

  def elapsed_seconds
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
  ensure
    ended = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    @__elapsed_seconds = ended - started
  end

  def elapsed
    @__elapsed_seconds || 0.0
  end

  test "TC-040 - Add, Update, View Property Inventory" do
    admin = users(:two)
    login_as(admin)

    unit_template = units(:one)
    new_unit_number = "PERF-#{SecureRandom.hex(4)}"

    assert_difference("Unit.count", +1) do
      post property_units_path(properties(:one)), params: {
        unit: {
          property_id: unit_template.property_id,
          unit_number: new_unit_number,
          size: unit_template.size,
          rental_rate: unit_template.rental_rate,
          classification: unit_template.classification,
          status: unit_template.status,
          intended_business_purpose: unit_template.intended_business_purpose,
          picture: unit_template.picture
        }
      }
    end

    get properties_path
    assert_response :success
    assert_includes response.body, "Unit #{new_unit_number} - #{properties(:one).name}"

    created_unit = Unit.order(:id).last
    patch property_unit_path(properties(:one), created_unit), params: {
      unit: {
        property_id: created_unit.property_id,
        unit_number: created_unit.unit_number,
        size: created_unit.size,
        rental_rate: created_unit.rental_rate + 1,
        classification: created_unit.classification,
        status: created_unit.status,
        intended_business_purpose: created_unit.intended_business_purpose
      }
    }
    assert_response :redirect
  end

  test "TC-041 - Search with filter and view results" do
    tenant = users(:one)
    login_as(tenant)

    get properties_path, params: { name: "Test" }
    assert_response :success
    assert_includes response.body, "Results"
    assert_includes response.body, "Unit #{units(:one).unit_number} - #{properties(:one).name}"
  end

  test "TC-042 - Input availability and book appointment" do
    agent = users(:two)
    login_as(agent)

    start_time = Time.current + 1.day
    end_time = start_time + 2.hours

    assert_difference("Availability.count", +1) do
      post availabilities_path, params: {
        availability: {
          property_id: properties(:one).id,
          start_time: start_time,
          end_time: end_time
        }
      }
    end

    availability = Availability.order(:id).last
    unit = units(:one)
    scheduled_at = start_time + 1.hour

    tenant = users(:one)
    login_as(tenant)

    assert_difference("Appointment.count", +1) do
      post appointments_path, params: {
        appointment: {
          unit_id: unit.id,
          availability_id: availability.id,
          scheduled_at: scheduled_at
        }
      }
    end

    get appointments_path
    assert_response :success
    assert_includes response.body, "Pending"
  end

  test "TC-043 - Lease agreement flow (smoke)" do
    application = rental_applications(:one)

    staff = users(:two)
    login_as(staff)
    assert_difference("Lease.count", +1) do
      patch approve_lease_application_path(application)
    end
    assert_response :redirect

    created_lease = Lease.order(:id).last
    assert_equal application.duration, created_lease.duration
    assert_equal application.start_date, created_lease.start_date
    assert_equal application.end_date, created_lease.end_date
  end

  test "TC-044 - Lease invoicing flow" do
    tenant = users(:one)
    login_as(tenant)
    account = tenant.reload.account
    overdue_invoice = invoices(:overdue_unpaid_rent_invoice)
    overdue_invoice.update_column(:account_id, account.id)

    get account_path(account)
    assert_response :success
    assert_includes response.body, "Outstanding invoices have passed the due date. Please pay as soon as possible."
    assert_equal "overdue", overdue_invoice.reload.status

    assert_difference("Payment.count", +1) do
      Payment.create!(
        account: account,
        amount: 1000,
        method: "card",
        paid_at: Time.current
      )
    end

    patch record_payment_invoice_path(overdue_invoice)
    assert_response :redirect
    assert_equal "paid", overdue_invoice.reload.status

    get account_path(account)
    assert_response :success

    staff = users(:two)
    lease = leases(:expired_automatic_lease)
    login_as(staff)

    original_end_date = lease.end_date
    get lease_agreement_path(lease)
    assert_response :success
    lease.reload
    assert_equal true, lease.active
    assert_operator lease.end_date, :>, original_end_date
  end

  test "TC-045 - Utility flow" do
    tenant = users(:one)
    login_as(tenant)

    lease = leases(:one)
    account = tenant.account
    utility = utilities(:one)
    total = utility.electricity_charges.to_f + utility.water_charges.to_f + utility.waste_management_charges.to_f

    assert_difference -> { Invoice.where(lease: lease, charge_type: "utility").count }, +1 do
      post invoices_path, params: {
        total_charge: total,
        due_date: Date.current + 30.days,
        lease_id: lease.id,
        charge_type: "utility"
      }
    end

    follow_redirect!
    assert_response :success
    assert_includes response.body, "Utility Breakdown"

    invoice = Invoice.order(:id).last
    assert_difference("Payment.count", +1) do
      post payments_path, params: { amount: invoice.total_charge, method: "card" }
    end

    get payments_path
    assert_response :success
    assert_includes response.body, "Card"
  end

  test "TC-046 - Maintenance flow" do
    tenant = users(:one)
    request = maintenance_requests(:one)
    account = tenant.account

    login_as(tenant)

    staff = users(:two)
    login_as(staff)

    assert_difference -> { Invoice.where(account: account, charge_type: "maintenance").count }, +1 do
      patch mark_tenant_caused_maintenance_request_path(request)
    end

    assert_response :redirect
    assert_equal true, request.reload.tenant_caused
  end

  test "TC-047 - Page load speed" do
    admin = users(:two)
    login_as(admin)

    elapsed_seconds do
      get properties_path
    end
    assert_operator elapsed, :<, 3.0

    elapsed_seconds do
      get appointments_path
    end
    assert_operator elapsed, :<, 3.0
  end

  # I was hoping to actually write/read concurrently in this test, but SQLite (what Ruby/Rails uses locally) doesn’t support it. 
  # So even if I split this into multiple processes, it will still run them in order. 
  # This just does 3 sequential booking and agreement creations as fast as possible and asserts time is under 3 seconds.
  test "TC-067 - Load testing" do
    availability = availabilities(:one)
    unit = units(:one)
    tenants = [users(:one), users(:cycle_monthly_user), users(:tracking_user)]
    agents = [users(:two), users(:agent_three), users(:agent_four)]
    applications = [
      rental_applications(:one),
      rental_applications(:two),
      rental_applications(:three)
    ]

    appointments_before = Appointment.count
    leases_before = Lease.count

    elapsed_seconds do
      3.times do |i|
        post login_path, params: { email: tenants[i].email, password: "password" }
        post appointments_path, params: {
          appointment: {
            unit_id: unit.id,
            availability_id: availability.id,
            scheduled_at: availability.start_time + ((i + 1) * 15).minutes
          }
        }
      end

      3.times do |i|
        post login_path, params: { email: agents[i].email, password: "password" }
        patch approve_lease_application_path(applications[i])
      end
    end

    assert_equal appointments_before + 3, Appointment.count
    assert_equal leases_before + 3, Lease.count
    assert_operator elapsed, :<, 3.0
  end

  test "TC-0068 - User login speed" do
    admin = users(:two)
    elapsed_seconds do
      login_as(admin)
    end
    assert_operator elapsed, :<, 3.0
    follow_redirect!
    assert_response :success
  end

  test "TC-0069 - Payment processing speed" do
    tenant = users(:one)
    login_as(tenant)

    account = tenant.account
    invoice = invoices(:upcoming_unpaid_rent_invoice)

    amount = invoice.total_charge.to_f.nonzero?

    elapsed_seconds do
      post payments_path, params: { amount: amount, method: "card" }
    end

    assert_operator elapsed, :<, 15.0
    assert_response :redirect
  end

  test "TC-0070 - Database load" do
    property = properties(:one)

    rows = 1000.times.map do |i|
      {
        property_id: property.id,
        unit_number: "LOAD-#{i}",
        size: 1000.0,
        rental_rate: 2000.0,
        classification: 0,
        status: 0,
        intended_business_purpose: "dining",
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    elapsed_seconds do
      Unit.insert_all(rows)
    end

    assert_operator elapsed, :<, 10.0
  end
end

