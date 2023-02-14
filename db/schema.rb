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

ActiveRecord::Schema[7.0].define(version: 2023_02_14_012131) do
  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "private_api_key"
  end

  create_table "computers", force: :cascade do |t|
    t.string "name"
    t.string "cpu"
    t.string "operating_system"
    t.string "make"
    t.string "model"
    t.string "serial_number"
    t.string "key"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manufacturer"
    t.string "mb_serial_number"
    t.text "notes"
    t.datetime "last_contacted_at"
    t.index ["account_id"], name: "index_computers_on_account_id"
    t.index ["key"], name: "index_computers_on_key"
  end

  create_table "domains", force: :cascade do |t|
    t.string "name"
    t.datetime "expires_on"
    t.datetime "billed_on"
    t.text "notes"
    t.boolean "web_hosting", default: false, null: false
    t.integer "hosting_fee_cents", default: 0, null: false
    t.string "hosting_fee_currency", default: "USD", null: false
    t.boolean "email_hosting", default: false, null: false
    t.boolean "registration", default: false, null: false
    t.integer "registration_fee_cents", default: 0, null: false
    t.string "registration_fee_currency", default: "USD", null: false
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_domains_on_account_id"
  end

  create_table "job_events", force: :cascade do |t|
    t.text "notes"
    t.integer "job_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_events_on_job_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "action"
    t.datetime "execute_after"
    t.integer "computer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.integer "days_to_recur"
    t.integer "status"
    t.index ["computer_id"], name: "index_jobs_on_computer_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "unifi_sites", force: :cascade do |t|
    t.string "name"
    t.integer "hosting_fee_cents", default: 0, null: false
    t.string "hosting_fee_currency", default: "USD", null: false
    t.datetime "billed_on"
    t.text "notes"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_unifi_sites_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "confirmed_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "computers", "accounts"
  add_foreign_key "domains", "accounts"
  add_foreign_key "job_events", "jobs"
  add_foreign_key "jobs", "computers"
  add_foreign_key "unifi_sites", "accounts"
end
