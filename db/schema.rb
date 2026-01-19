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

ActiveRecord::Schema[8.1].define(version: 2026_01_19_022621) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "created_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "plan_id", null: false
    t.bigint "training_schedule_id", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_created_plans_on_plan_id"
    t.index ["training_schedule_id"], name: "index_created_plans_on_training_schedule_id"
  end

  create_table "instructors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "training_schedule_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["training_schedule_id"], name: "index_instructors_on_training_schedule_id"
    t.index ["user_id"], name: "index_instructors_on_user_id"
  end

  create_table "plan_participations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "plan_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["plan_id"], name: "index_plan_participations_on_plan_id"
    t.index ["user_id"], name: "index_plan_participations_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.date "end_date"
    t.string "name"
    t.string "participants"
    t.date "start_date"
    t.integer "training_count"
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "training_participations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "status"
    t.bigint "training_schedule_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["training_schedule_id"], name: "index_training_participations_on_training_schedule_id"
    t.index ["user_id"], name: "index_training_participations_on_user_id"
  end

  create_table "training_schedules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "end_time"
    t.bigint "room_id", null: false
    t.datetime "start_time"
    t.bigint "training_id", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_training_schedules_on_room_id"
    t.index ["training_id"], name: "index_training_schedules_on_training_id"
  end

  create_table "trainings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "external_user_id"
    t.string "name"
    t.string "password_digest"
    t.string "real_name"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["external_user_id"], name: "index_users_on_external_user_id", unique: true
  end

  add_foreign_key "created_plans", "plans"
  add_foreign_key "created_plans", "training_schedules"
  add_foreign_key "instructors", "training_schedules"
  add_foreign_key "instructors", "users"
  add_foreign_key "plan_participations", "plans"
  add_foreign_key "plan_participations", "users"
  add_foreign_key "training_participations", "training_schedules"
  add_foreign_key "training_participations", "users"
  add_foreign_key "training_schedules", "rooms"
  add_foreign_key "training_schedules", "trainings"
end
