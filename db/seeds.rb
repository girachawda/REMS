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
  u.picture = "https://unsplash.com/photos/photo-of-dining-table-and-chairs-inside-room-eHD8Y1Znfpk"
end

Unit.find_or_create_by!(property: prop1, unit_number: "102") do |u|
  u.size = 800.0
  u.rental_rate = 1800.0
  u.classification = :tier_2
  u.status = :available
  u.intended_business_purpose = "dining"
  u.picture = "https://unsplash.com/photos/people-sitting-on-chair-in-restaurant-p85-MG66GRY"
end

Unit.find_or_create_by!(property: prop1, unit_number: "103") do |u|
  u.size = 1500.0
  u.rental_rate = 3200.0
  u.classification = :tier_1
  u.status = :occupied
  u.intended_business_purpose = "retail"
  u.picture = "https://unsplash.com/photos/white-metal-shelf-with-food-packs-QnMeRW36-zY"
end

Unit.find_or_create_by!(property: prop2, unit_number: "201") do |u|
  u.size = 1000.0
  u.rental_rate = 2000.0
  u.classification = :tier_2
  u.status = :available
  u.intended_business_purpose = "office"
  u.picture = "https://unsplash.com/photos/man-and-woman-sitting-on-table-U2BI3GMnSSE"
end

Unit.find_or_create_by!(property: prop2, unit_number: "202") do |u|
  u.size = 600.0
  u.rental_rate = 1200.0
  u.classification = :tier_3
  u.status = :available
  u.intended_business_purpose = "office"
  u.picture = "https://unsplash.com/photos/hallway-between-glass-panel-doors-yWwob8kwOCk"
end

Unit.find_or_create_by!(property: prop3, unit_number: "301") do |u|
  u.size = 3000.0
  u.rental_rate = 4500.0
  u.classification = :tier_1
  u.status = :available
  u.intended_business_purpose = "retail"
  u.picture = "https://unsplash.com/photos/black-trike-parked-near-soter-F6-U5fGAOik"
end

Unit.find_or_create_by!(property: prop3, unit_number: "302") do |u|
  u.size = 500.0
  u.rental_rate = 900.0
  u.classification = :tier_4
  u.status = :maintenance
  u.intended_business_purpose = "dining"
  u.picture = "https://unsplash.com/photos/brown-and-gray-concrete-store-nmpW_WwwVSc"
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

Account.find_or_create_by!(
  balance: 1350.37,
  payment_cycle: "monthly",
  bank_transfer_number: 123456789,
  discount_percent: 3,
  user_id: 1,
)

Account.find_or_create_by!(
  balance: 1350.37,
  payment_cycle: "monthly",
  bank_transfer_number: 123456789,
  discount_percent: 3,
  user_id: 2,
)

Account.find_or_create_by!(
  balance: 0,
  payment_cycle: "monthly",
  bank_transfer_number: 123456789,
  discount_percent: 0,
  user_id: 3,
)

RentalApplication.find_or_create_by!(
  start_date: Date.new(2026, 01, 01),
  end_date: Date.new(2026, 12, 31),
  duration: 12,
  status: "approved",
  user_id: 1,
  unit_id: 1
)

RentalApplication.find_or_create_by!(
  start_date: Date.new(2026, 01, 01),
  end_date: Date.new(2026, 12, 31),
  duration: 12,
  status: "approved",
  user_id: 1,
  unit_id: 2
)

RentalApplication.find_or_create_by!(
  start_date: Date.new(2026, 01, 01),
  end_date: Date.new(2026, 12, 31),
  duration: 12,
  status: "approved",
  user_id: 2,
  unit_id: 3
)

Lease.find_or_create_by!(
  duration: 12,
  renewal_policy: "automatic",
  start_date: Date.new(2026, 01, 01),
  end_date: Date.new(2026, 12, 31),
  user_id: 1,
  unit_id: 1,
  active: true
  )

  Lease.find_or_create_by!(
  duration: 12,
  renewal_policy: "automatic",
  start_date: Date.new(2026, 01, 01),
  end_date: Date.new(2026, 12, 31),
  user_id: 1,
  unit_id: 2,
  active: true
  )

  Lease.find_or_create_by!(
  duration: 12,
  renewal_policy: "automatic",
  start_date: Date.new(2026, 01, 01),
  end_date: Date.new(2026, 12, 31),
  user_id: 2,
  unit_id: 3,
  active: true
  )

Utility.find_or_create_by!(
  electricity_charges: 35,
  water_charges: 35,
  waste_management_charges: 56,
  lease_id: 1,
)

Utility.find_or_create_by!(
  electricity_charges: 102,
  water_charges: 53,
  waste_management_charges: 23,
  lease_id: 2,
)

Utility.find_or_create_by!(
  electricity_charges: 89,
  water_charges: 67,
  waste_management_charges: 45,
  lease_id: 3,
)
  MaintenanceRequest.find_or_create_by!(
    priority: 1,
    is_emergency: false,
    is_routine: true,
    tenant_caused: false,
    unit_id: 1,
    user_id: 1,
    status: "submitted",
    maintenance_cost: 134.21
  )

    MaintenanceRequest.find_or_create_by!(
    priority: 1,
    is_emergency: false,
    is_routine: true,
    tenant_caused: false,
    unit_id: 1,
    user_id: 1,
    status: "closed",
    maintenance_cost: 134.21
  )

    MaintenanceRequest.find_or_create_by!(
    priority: 1,
    is_emergency: true,
    is_routine: false,
    tenant_caused: true,
    unit_id: 2,
    user_id: 1,
    status: "submitted",
    maintenance_cost: 231.21
  )

  MaintenanceRequest.find_or_create_by!(
    priority: 4,
    is_emergency: true,
    is_routine: true,
    tenant_caused: false,
    unit_id: 3,
    user_id: 2,
    status: "submitted",
    maintenance_cost: 523.21
  )

puts "Seeded database."
