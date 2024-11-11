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

ActiveRecord::Schema[7.0].define(version: 2024_11_11_025216) do
  create_table "address_barangays", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "city_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_address_barangays_on_city_id"
  end

  create_table "address_cities", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "province_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["province_id"], name: "index_address_cities_on_province_id"
  end

  create_table "address_provinces", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "region_id"
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_address_provinces_on_region_id"
  end

  create_table "address_regions", charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", charset: "utf8mb4", force: :cascade do |t|
    t.string "image"
    t.string "name"
    t.integer "quantity"
    t.integer "minimum_tickets"
    t.string "state"
    t.integer "batch_count"
    t.datetime "online_at"
    t.datetime "offline_at"
    t.datetime "start_at"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", charset: "utf8mb4", force: :cascade do |t|
    t.integer "genre", default: 0, null: false
    t.string "name"
    t.string "street_address"
    t.string "phone_number"
    t.text "remark"
    t.boolean "is_default", default: false, null: false
    t.bigint "user_id", null: false
    t.bigint "address_region_id", null: false
    t.bigint "address_province_id", null: false
    t.bigint "address_city_id", null: false
    t.bigint "address_barangay_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_barangay_id"], name: "index_places_on_address_barangay_id"
    t.index ["address_city_id"], name: "index_places_on_address_city_id"
    t.index ["address_province_id"], name: "index_places_on_address_province_id"
    t.index ["address_region_id"], name: "index_places_on_address_region_id"
    t.index ["user_id"], name: "index_places_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.integer "role", default: 0, null: false
    t.integer "coins"
    t.string "phone"
    t.float "total_deposit"
    t.integer "children_members"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "parent_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "places", "address_barangays"
  add_foreign_key "places", "address_cities"
  add_foreign_key "places", "address_provinces"
  add_foreign_key "places", "address_regions"
  add_foreign_key "places", "users"
end
