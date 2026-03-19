# Create Users with different roles
tenant1 = User.find_or_create_by!(email: "tenant1@example.com") do |u|
  u.name = "John Tenant"
  u.password = "password"
  u.role = :tenant
end

tenant2 = User.find_or_create_by!(email: "tenant2@example.com") do |u|
  u.name = "Jane Doe"
  u.password = "password"
  u.role = :tenant
end

agent1 = User.find_or_create_by!(email: "agent1@example.com") do |u|
  u.name = "Bob Agent"
  u.password = "password"
  u.role = :leasing_agent
end

agent2 = User.find_or_create_by!(email: "agent2@example.com") do |u|
  u.name = "Alice Smith"
  u.password = "password"
  u.role = :leasing_agent
end

staff = User.find_or_create_by!(email: "staff@example.com") do |u|
  u.name = "Admin Staff"
  u.password = "password"
  u.role = :administrative_staff
end

# Create Properties
prop1 = Property.find_or_create_by!(name: "Downtown Plaza") do |p|
  p.address = "123 Main St, City, ST 12345"
  p.description = "Prime retail space in the heart of downtown"
end

prop2 = Property.find_or_create_by!(name: "Suburban Mall") do |p|
  p.address = "456 Oak Ave, City, ST 12345"
  p.description = "Family-friendly shopping center with ample parking"
end

prop3 = Property.find_or_create_by!(name: "Industrial Park") do |p|
  p.address = "789 Commerce Dr, City, ST 12345"
  p.description = "Modern warehouse and office spaces"
end

# Create Units
Unit.find_or_create_by!(property: prop1, unit_number: "101") do |u|
  u.size = 1200.0
  u.rental_rate = 2500.0
  u.classification = :tier_1
  u.status = :available
end

Unit.find_or_create_by!(property: prop1, unit_number: "102") do |u|
  u.size = 800.0
  u.rental_rate = 1800.0
  u.classification = :tier_2
  u.status = :available
end

Unit.find_or_create_by!(property: prop1, unit_number: "103") do |u|
  u.size = 1500.0
  u.rental_rate = 3200.0
  u.classification = :tier_1
  u.status = :occupied
end

Unit.find_or_create_by!(property: prop2, unit_number: "201") do |u|
  u.size = 1000.0
  u.rental_rate = 2000.0
  u.classification = :tier_2
  u.status = :available
end

Unit.find_or_create_by!(property: prop2, unit_number: "202") do |u|
  u.size = 600.0
  u.rental_rate = 1200.0
  u.classification = :tier_3
  u.status = :available
end

Unit.find_or_create_by!(property: prop3, unit_number: "301") do |u|
  u.size = 3000.0
  u.rental_rate = 4500.0
  u.classification = :tier_1
  u.status = :available
end

Unit.find_or_create_by!(property: prop3, unit_number: "302") do |u|
  u.size = 500.0
  u.rental_rate = 900.0
  u.classification = :tier_4
  u.status = :maintenance
end

# Create some agent availability
start_date = Date.today
7.times do |i|
  date = start_date + i.days
  Availability.find_or_create_by!(
    user: agent1,
    property: prop1,
    start_time: date.to_time + 9.hours,
    end_time: date.to_time + 17.hours
  )

  Availability.find_or_create_by!(
    user: agent2,
    property: prop2,
    start_time: date.to_time + 10.hours,
    end_time: date.to_time + 18.hours
  )
end

puts "Seeded database with users, properties, units, and availability"

puts "Seeding leases, accounts, utilities, invoices, and payments..."

# Leases
unit_103 = Unit.find_by!(property: prop1, unit_number: "103")
unit_201 = Unit.find_by!(property: prop2, unit_number: "201")

unit_103.update!(status: :occupied)
unit_201.update!(status: :occupied)

# Leases
lease1 = Lease.find_or_create_by!(user: tenant1, unit: unit_103) do |l|
  l.duration = 12
  l.renewal_policy = "Auto-renew yearly unless terminated"
  l.start_date = Date.today.beginning_of_year
  l.end_date = Date.today.beginning_of_year + 12.months - 1.day
  l.active = true
end

lease2 = Lease.find_or_create_by!(user: tenant2, unit: unit_201) do |l|
  l.duration = 12
  l.renewal_policy = "Manual renewal required"
  l.start_date = Date.today.beginning_of_year
  l.end_date = Date.today.beginning_of_year + 12.months - 1.day
  l.active = true
end

# Accounts
account1 = Account.find_or_create_by!(user: tenant1) do |a|
  a.balance = 0.0
  a.payment_cycle = "monthly"
  a.bank_transfer_number = 111111
  a.discount_percent = 0.0
end

account2 = Account.find_or_create_by!(user: tenant2) do |a|
  a.balance = 0.0
  a.payment_cycle = "quarterly"
  a.bank_transfer_number = 222222
  a.discount_percent = 10.0
end

# Reset balances so re-seeding doesn't keep stacking if records already exist
account1.update!(balance: 0.0)
account2.update!(balance: 0.0)

# Utility records
utility1 = Utility.find_or_create_by!(lease: lease1) do |u|
  u.electricity_charges = 85.50
  u.water_charges = 32.25
  u.waste_management_charges = 18.75
end

utility2 = Utility.find_or_create_by!(lease: lease2) do |u|
  u.electricity_charges = 120.10
  u.water_charges = 44.80
  u.waste_management_charges = 25.40
end

utility_total_1 = utility1.electricity_charges.to_f + utility1.water_charges.to_f + utility1.waste_management_charges.to_f
utility_total_2 = utility2.electricity_charges.to_f + utility2.water_charges.to_f + utility2.waste_management_charges.to_f

# Rent calculations
rent1 = unit_103.rental_rate.to_f
rent2 = unit_201.rental_rate.to_f

rent_invoice_total_1 = account1.automatic_payment_amount(rent1).to_f
rent_invoice_total_2 = account2.automatic_payment_amount(rent2).to_f


# Invoices

# Tenant 1 - monthly rent invoice for current month
invoice1_rent_current = Invoice.find_or_create_by!(
  lease: lease1,
  account: account1,
  charge_type: "rent",
  due_date: Date.today.beginning_of_month + 5.days
) do |i|
  i.total_charge = rent_invoice_total_1
  i.status = "unpaid"
end

# Tenant 1 - previous month's overdue rent invoice
invoice1_rent_overdue = Invoice.find_or_create_by!(
  lease: lease1,
  account: account1,
  charge_type: "rent",
  due_date: 1.month.ago.beginning_of_month + 5.days
) do |i|
  i.total_charge = rent_invoice_total_1
  i.status = "overdue"
end

# Tenant 1 - monthly utility invoice
invoice1_utility = Invoice.find_or_create_by!(
  lease: lease1,
  account: account1,
  charge_type: "utility",
  due_date: Date.today.end_of_month
) do |i|
  i.total_charge = utility_total_1
  i.status = "unpaid"
end

# Tenant 2 - quarterly rent invoice with discount
invoice2_rent = Invoice.find_or_create_by!(
  lease: lease2,
  account: account2,
  charge_type: "rent",
  due_date: Date.today.beginning_of_quarter + 7.days
) do |i|
  i.total_charge = rent_invoice_total_2
  i.status = "unpaid"
end

# Tenant 2 - utility invoice, paid
invoice2_utility = Invoice.find_or_create_by!(
  lease: lease2,
  account: account2,
  charge_type: "utility",
  due_date: Date.today.end_of_month
) do |i|
  i.total_charge = utility_total_2
  i.status = "paid"
end

# Optional maintenance invoice example
invoice1_maintenance = Invoice.find_or_create_by!(
  lease: lease1,
  account: account1,
  charge_type: "maintenance",
  due_date: Date.today - 3.days
) do |i|
  i.total_charge = 95.00
  i.status = "overdue"
end

# Recalculate balances from invoices
account1_balance =
  account1.invoices.sum { |inv| inv.total_charge.to_f } -
  account1.payments.sum { |p| p.amount.to_f }

account2_balance =
  account2.invoices.sum { |inv| inv.total_charge.to_f } -
  account2.payments.sum { |p| p.amount.to_f }

account1.update!(balance: account1_balance)
account2.update!(balance: account2_balance)

# Payments
# Tenant 1 partial payment toward overall balance
payment1 = Payment.find_or_create_by!(
  account: account1,
  amount: 1000.00,
  paid_at: Date.today - 2.days,
  method: "bank_transfer"
)

# Tenant 2 paid utility bill
payment2 = Payment.find_or_create_by!(
  account: account2,
  amount: utility_total_2,
  paid_at: Date.today - 1.day,
  method: "credit_card"
)

# Recalculate balances after payments
account1_balance =
  account1.invoices.sum { |inv| inv.total_charge.to_f } -
  account1.payments.sum { |p| p.amount.to_f }

account2_balance =
  account2.invoices.sum { |inv| inv.total_charge.to_f } -
  account2.payments.sum { |p| p.amount.to_f }

account1.update!(balance: account1_balance)
account2.update!(balance: account2_balance)

puts "Finished seeding invoicing data."
puts "Tenant 1 account balance: #{account1.reload.balance}"
puts "Tenant 2 account balance: #{account2.reload.balance}"
puts "Tenant 1 overdue invoices: #{account1.invoices.where(status: 'overdue').count}"
puts "Tenant 2 paid invoices: #{account2.invoices.where(status: 'paid').count}"