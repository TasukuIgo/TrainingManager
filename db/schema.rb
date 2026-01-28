ActiveRecord::Schema[8.1].define(version: 2026_01_23_045650) do

  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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

  create_table "materials", force: :cascade do |t|
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "file_path", null: false
    t.string "original_filename", null: false
    t.bigint "training_id", null: false
    t.datetime "updated_at", null: false
    t.index ["training_id"], name: "index_materials_on_training_id"
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
    t.bigint "room_id"
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
    t.integer "fundely_user_id"
    t.string "name"
    t.string "real_name"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["external_user_id"], name: "index_users_on_external_user_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "created_plans", "plans"
  add_foreign_key "created_plans", "training_schedules"
  add_foreign_key "instructors", "training_schedules"
  add_foreign_key "instructors", "users"
  add_foreign_key "materials", "trainings"
  add_foreign_key "plan_participations", "plans"
  add_foreign_key "plan_participations", "users"
  add_foreign_key "training_participations", "training_schedules"
  add_foreign_key "training_participations", "users"
  add_foreign_key "training_schedules", "rooms"
  add_foreign_key "training_schedules", "trainings"
end
