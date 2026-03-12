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
