# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use migrations to incrementally modify your database, and
# then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_01_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classrooms", force: :cascade do |t|
    t.string "name", null: false
    t.string "building", null: false
    t.integer "capacity", null: false
    t.string "room_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building", "room_number"], name: "index_classrooms_on_building_and_room_number", unique: true
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "section_id", null: false
    t.date "enrollment_date", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_enrollments_on_section_id"
    t.index ["status"], name: "index_enrollments_on_status"
    t.index ["student_id", "section_id"], name: "index_enrollments_on_student_id_and_section_id", unique: true
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.bigint "subject_id", null: false
    t.bigint "classroom_id", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.string "days_of_week", null: false, array: true
    t.integer "duration_minutes", null: false
    t.integer "capacity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capacity"], name: "index_sections_on_capacity"
    t.index ["classroom_id"], name: "index_sections_on_classroom_id"
    t.index ["days_of_week"], name: "index_sections_on_days_of_week", using: :gin
    t.index ["end_time"], name: "index_sections_on_end_time"
    t.index ["start_time"], name: "index_sections_on_start_time"
    t.index ["subject_id"], name: "index_sections_on_subject_id"
    t.index ["teacher_id"], name: "index_sections_on_teacher_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "student_id", null: false
    t.string "major", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["student_id"], name: "index_students_on_student_id", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.text "description"
    t.integer "credits", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_subjects_on_code", unique: true
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "department", null: false
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
  end

  add_foreign_key "enrollments", "sections"
  add_foreign_key "enrollments", "students"
  add_foreign_key "sections", "classrooms"
  add_foreign_key "sections", "subjects"
  add_foreign_key "sections", "teachers"
end
