# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_03_19_173114) do
  create_table "accounts", force: :cascade do |t|
    t.decimal "balance", precision: 15, scale: 2, default: "0.0"
    t.string "payment_cycle", default: "monthly"
    t.integer "bank_transfer_number"
    t.decimal "discount_percent", default: "0.0"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "unit_id", null: false
    t.integer "availability_id", null: false
    t.datetime "scheduled_at"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["availability_id"], name: "index_appointments_on_availability_id"
    t.index ["unit_id"], name: "index_appointments_on_unit_id"
    t.index ["user_id"], name: "index_appointments_on_user_id"
  end

  create_table "availabilities", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "property_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_availabilities_on_property_id"
    t.index ["user_id"], name: "index_availabilities_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.decimal "total_charge"
    t.date "due_date"
    t.string "status"
    t.integer "lease_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "charge_type"
    t.integer "account_id", null: false
    t.decimal "electricity_charges", precision: 15, scale: 2
    t.decimal "water_charges", precision: 15, scale: 2
    t.decimal "waste_management_charges", precision: 15, scale: 2
    t.index ["account_id"], name: "index_invoices_on_account_id"
    t.index ["lease_id"], name: "index_invoices_on_lease_id"
  end

  create_table "leases", force: :cascade do |t|
    t.integer "duration"
    t.string "renewal_policy"
    t.date "start_date"
    t.date "end_date"
    t.integer "user_id", null: false
    t.integer "unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.index ["unit_id"], name: "index_leases_on_unit_id"
    t.index ["user_id"], name: "index_leases_on_user_id"
  end

  create_table "maintenance_requests", force: :cascade do |t|
    t.integer "priority"
    t.boolean "is_emergency"
    t.boolean "is_routine"
    t.boolean "tenant_caused"
    t.integer "unit_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.decimal "maintenance_cost"
    t.index ["unit_id"], name: "index_maintenance_requests_on_unit_id"
    t.index ["user_id"], name: "index_maintenance_requests_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "paid_at"
    t.string "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id", null: false
    t.index ["account_id"], name: "index_payments_on_account_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rental_applications", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "duration"
    t.string "status"
    t.integer "user_id", null: false
    t.integer "unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rejection_reason"
    t.index ["unit_id"], name: "index_rental_applications_on_unit_id"
    t.index ["user_id"], name: "index_rental_applications_on_user_id"
  end

  create_table "units", force: :cascade do |t|
    t.integer "property_id", null: false
    t.string "unit_number"
    t.decimal "size"
    t.decimal "rental_rate"
    t.integer "classification"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "intended_business_purpose"
    t.integer "utilities_id"
    t.string "picture"
    t.index ["property_id"], name: "index_units_on_property_id"
    t.index ["utilities_id"], name: "index_units_on_utilities_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "utilities", force: :cascade do |t|
    t.decimal "electricity_charges"
    t.decimal "water_charges"
    t.decimal "waste_management_charges"
    t.integer "lease_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lease_id"], name: "index_utilities_on_lease_id"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "appointments", "availabilities"
  add_foreign_key "appointments", "units"
  add_foreign_key "appointments", "users"
  add_foreign_key "availabilities", "properties"
  add_foreign_key "availabilities", "users"
  add_foreign_key "invoices", "accounts"
  add_foreign_key "invoices", "leases"
  add_foreign_key "leases", "units"
  add_foreign_key "leases", "users"
  add_foreign_key "maintenance_requests", "units"
  add_foreign_key "maintenance_requests", "users"
  add_foreign_key "payments", "accounts"
  add_foreign_key "rental_applications", "units"
  add_foreign_key "rental_applications", "users"
  add_foreign_key "units", "properties"
  add_foreign_key "units", "utilities", column: "utilities_id"
  add_foreign_key "utilities", "leases"
end
