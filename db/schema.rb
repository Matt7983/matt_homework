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

ActiveRecord::Schema[7.0].define(version: 2023_09_03_063019) do
  create_table "chapters", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.string "name", null: false
    t.integer "sequence", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_chapters_on_course_id"
  end

  create_table "courses", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "lecturer", null: false
    t.text "description"
    t.boolean "available", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "chapter_id", null: false
    t.string "name", null: false
    t.text "description"
    t.text "content", null: false
    t.integer "sequence", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_units_on_chapter_id"
  end

end
