# Create Users with different roles
tenant1 = User.find_or_create_by!(email: "tenant1@example.com") do |u|
  u.name = "Homer Simpson"
  u.password = "password"
  u.role = :tenant
end

tenant2 = User.find_or_create_by!(email: "tenant2@example.com") do |u|
  u.name = "Krusty the Clown"
  u.password = "password"
  u.role = :tenant
end

tenant3 = User.find_or_create_by!(email: "tenant3@example.com") do |u|
  u.name = "Mr. Burns"
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
  u.intended_business_purpose = "dining"
  u.picture = "https://images.unsplash.com/photo-1528698827591-e19ccd7bc23d?ixid=M3w4MjcwNjd8MHwxfHNlYXJjaHwxfHxzdG9yZWZyb250fGVufDB8fHx8MTc3Mzg2NzA4Mnww&ixlib=rb-4.1.0&w=600&h=500&fit=max&q=80"
end

Unit.find_or_create_by!(property: prop1, unit_number: "102") do |u|
  u.size = 800.0
  u.rental_rate = 1800.0
  u.classification = :tier_2
  u.status = :available
  u.intended_business_purpose = "dining"
  u.picture = "https://images.unsplash.com/photo-1571974448718-ac26a9af7d8b?ixid=M3w4MjcwNjd8MHwxfHNlYXJjaHwyfHxzdG9yZWZyb250fGVufDB8fHx8MTc3Mzg2NzA4Mnww&ixlib=rb-4.1.0&w=600&h=500&fit=max&q=80"
end

Unit.find_or_create_by!(property: prop1, unit_number: "103") do |u|
  u.size = 1500.0
  u.rental_rate = 3200.0
  u.classification = :tier_1
  u.status = :occupied
  u.intended_business_purpose = "retail"
  u.picture = "https://images.unsplash.com/photo-1464869372688-a93d806be852?ixid=M3w4MjcwNjd8MHwxfHNlYXJjaHw2fHxzdG9yZWZyb250fGVufDB8fHx8MTc3Mzg2NzA4Mnww&ixlib=rb-4.1.0&w=600&h=500&fit=max&q=80"
end

Unit.find_or_create_by!(property: prop2, unit_number: "201") do |u|
  u.size = 1000.0
  u.rental_rate = 2000.0
  u.classification = :tier_2
  u.status = :available
  u.intended_business_purpose = "office"
  u.picture = "https://images.unsplash.com/photo-1580554430120-94cfcb3adf25?ixid=M3w4MjcwNjd8MHwxfHNlYXJjaHw0fHxzdG9yZWZyb250fGVufDB8fHx8MTc3Mzg2NzA4Mnww&ixlib=rb-4.1.0&w=600&h=500&fit=max&q=80"
end

Unit.find_or_create_by!(property: prop2, unit_number: "202") do |u|
  u.size = 600.0
  u.rental_rate = 1200.0
  u.classification = :tier_3
  u.status = :available
  u.intended_business_purpose = "office"
  u.picture = "https://images.unsplash.com/photo-1515111057773-363c20156f04?ixid=M3w4MjcwNjd8MHwxfHNlYXJjaHw3fHxzdG9yZWZyb250fGVufDB8fHx8MTc3Mzg2NzA4Mnww&ixlib=rb-4.1.0&w=600&h=500&fit=max&q=80"
end

Unit.find_or_create_by!(property: prop3, unit_number: "301") do |u|
  u.size = 3000.0
  u.rental_rate = 4500.0
  u.classification = :tier_1
  u.status = :available
  u.intended_business_purpose = "retail"
  u.picture = "https://images.unsplash.com/photo-1528698827591-e19ccd7bc23d?ixid=M3w4MjcwNjd8MHwxfHNlYXJjaHwxfHxzdG9yZWZyb250fGVufDB8fHx8MTc3Mzg2NzA4Mnww&ixlib=rb-4.1.0&w=600&h=500&fit=max&q=80"
end

Unit.find_or_create_by!(property: prop3, unit_number: "302") do |u|
  u.size = 500.0
  u.rental_rate = 900.0
  u.classification = :tier_4
  u.status = :maintenance
  u.intended_business_purpose = "dining"
  u.picture = "https://images.unsplash.com/photo-1687114835860-4c22e258781f?ixid=M3w4MjcwNjd8MHwxfHNlYXJjaHw1fHxzdG9yZWZyb250fGVufDB8fHx8MTc3Mzg2NzA4Mnww&ixlib=rb-4.1.0&w=600&h=500&fit=max&q=80"
end

unit_101 = Unit.find_by!(property: prop1, unit_number: "101")
unit_102 = Unit.find_by!(property: prop1, unit_number: "102")
unit_103 = Unit.find_by!(property: prop1, unit_number: "103")

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

Account.find_or_create_by!(user: tenant1) do |a|
  a.balance = 0.0
  a.payment_cycle = "monthly"
  a.bank_transfer_number = 123_456_789
  a.discount_percent = 3
end

Account.find_or_create_by!(user: tenant2) do |a|
  a.balance = 1350.37
  a.payment_cycle = "monthly"
  a.bank_transfer_number = 123_456_789
  a.discount_percent = 3
end

Account.find_or_create_by!(user: tenant3) do |a|
  a.balance = 0
  a.payment_cycle = "monthly"
  a.bank_transfer_number = 123_456_789
  a.discount_percent = 0
end

RentalApplication.find_or_create_by!(
  start_date: Date.new(2026, 1, 1),
  end_date: Date.new(2026, 12, 31),
  duration: 12,
  status: "approved",
  renewal_policy: "automatic",
  user_id: tenant1.id,
  unit_id: unit_101.id
)

RentalApplication.find_or_create_by!(
  start_date: Date.new(2026, 1, 1),
  end_date: Date.new(2026, 12, 31),
  duration: 12,
  status: "approved",
  renewal_policy: "automatic",
  user_id: tenant1.id,
  unit_id: unit_102.id
)

RentalApplication.find_or_create_by!(
  start_date: Date.new(2026, 1, 1),
  end_date: Date.new(2026, 12, 31),
  duration: 12,
  status: "approved",
  renewal_policy: "automatic",
  user_id: tenant2.id,
  unit_id: unit_103.id
)

lease_homer_101 = Lease.find_or_create_by!(
  duration: 12,
  renewal_policy: "automatic",
  start_date: Date.new(2026, 1, 1),
  end_date: Date.new(2026, 12, 31),
  user_id: tenant1.id,
  unit_id: unit_101.id,
  active: true,
  tenant_signed: true,
  agent_signed: true
)

lease_homer_102 = Lease.find_or_create_by!(
  duration: 12,
  renewal_policy: "automatic",
  start_date: Date.new(2026, 1, 1),
  end_date: Date.new(2026, 12, 31),
  user_id: tenant1.id,
  unit_id: unit_102.id,
  active: false
)

lease_krusty_103 = Lease.find_or_create_by!(
  duration: 12,
  renewal_policy: "automatic",
  start_date: Date.new(2026, 1, 1),
  end_date: Date.new(2026, 12, 31),
  user_id: tenant2.id,
  unit_id: unit_103.id,
  active: true
)

Utility.find_or_create_by!(
  electricity_charges: 35,
  water_charges: 35,
  waste_management_charges: 56,
  lease_id: lease_homer_101.id
)

Utility.find_or_create_by!(
  electricity_charges: 102,
  water_charges: 53,
  waste_management_charges: 23,
  lease_id: lease_homer_102.id
)

Utility.find_or_create_by!(
  electricity_charges: 89,
  water_charges: 67,
  waste_management_charges: 45,
  lease_id: lease_krusty_103.id
)

MaintenanceRequest.find_or_create_by!(
  priority: 1,
  is_emergency: false,
  is_routine: true,
  tenant_caused: false,
  unit_id: unit_101.id,
  user_id: tenant1.id,
  status: "submitted",
  maintenance_cost: 134.21
)

MaintenanceRequest.find_or_create_by!(
  priority: 1,
  is_emergency: false,
  is_routine: true,
  tenant_caused: false,
  unit_id: unit_101.id,
  user_id: tenant1.id,
  status: "closed",
  maintenance_cost: 134.21
)

MaintenanceRequest.find_or_create_by!(
  priority: 1,
  is_emergency: true,
  is_routine: false,
  tenant_caused: true,
  unit_id: unit_102.id,
  user_id: tenant1.id,
  status: "submitted",
  maintenance_cost: 231.21
)

MaintenanceRequest.find_or_create_by!(
  priority: 4,
  is_emergency: true,
  is_routine: true,
  tenant_caused: false,
  unit_id: unit_103.id,
  user_id: tenant2.id,
  status: "submitted",
  maintenance_cost: 523.21
)

puts "Seeded database."
