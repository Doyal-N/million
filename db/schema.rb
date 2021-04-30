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

ActiveRecord::Schema.define(version: 2016_06_17_130542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_questions", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.integer "question_id", null: false
    t.integer "a"
    t.integer "b"
    t.integer "c"
    t.integer "d"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "help_hash"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "finished_at"
    t.integer "current_level", default: 0, null: false
    t.boolean "is_failed"
    t.integer "prize", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "fifty_fifty_used", default: false, null: false
    t.boolean "audience_help_used", default: false, null: false
    t.boolean "friend_call_used", default: false, null: false
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.integer "level", null: false
    t.text "text", null: false
    t.string "answer1", null: false
    t.string "answer2"
    t.string "answer3"
    t.string "answer4"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["level"], name: "index_questions_on_level"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.boolean "is_admin", default: false, null: false
    t.integer "balance", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "game_questions", "games"
  add_foreign_key "game_questions", "questions"
  add_foreign_key "games", "users"
end
