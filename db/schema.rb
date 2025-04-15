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

ActiveRecord::Schema[7.1].define(version: 2025_04_15_195459) do
  create_table "empires", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.integer "credits", default: 1000
    t.integer "minerals", default: 500
    t.integer "energy", default: 200
    t.integer "food", default: 300
    t.integer "population", default: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_empires_on_user_id", unique: true
  end

  create_table "star_systems", force: :cascade do |t|
    t.string "name", null: false
    t.string "status", default: "undiscovered"
    t.string "system_type", default: "terrestrial", null: false
    t.integer "max_population", default: 1000, null: false
    t.integer "max_buildings", default: 10, null: false
    t.integer "current_population", default: 0, null: false
    t.integer "loyalty", default: 100, null: false
    t.integer "empire_id"
    t.integer "previous_owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["empire_id"], name: "index_star_systems_on_empire_id"
    t.index ["name"], name: "index_star_systems_on_name"
    t.index ["previous_owner_id"], name: "index_star_systems_on_previous_owner_id"
    t.index ["status"], name: "index_star_systems_on_status"
    t.index ["system_type"], name: "index_star_systems_on_system_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "empires", "users"
  add_foreign_key "star_systems", "empires"
  add_foreign_key "star_systems", "empires", column: "previous_owner_id"
end
