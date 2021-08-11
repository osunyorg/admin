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

ActiveRecord::Schema.define(version: 2021_08_11_102819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "features_education_programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.integer "level"
    t.integer "capacity"
    t.integer "ects"
    t.boolean "continuing"
    t.text "prerequisites"
    t.text "objectives"
    t.text "duration"
    t.text "registration"
    t.text "pedagogy"
    t.text "evaluation"
    t.text "accessibility"
    t.text "pricing"
    t.text "contacts"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["university_id"], name: "index_features_education_programs_on_university_id"
  end

  create_table "features_education_qualiopi_criterions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "number"
    t.text "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "features_education_qualiopi_indicators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "criterion_id", null: false
    t.integer "number"
    t.text "name"
    t.text "level_expected"
    t.text "proof"
    t.text "requirement"
    t.text "non_conformity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["criterion_id"], name: "index_features_education_qualiopi_indicators_on_criterion_id"
  end

  create_table "features_websites_sites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.string "domain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["university_id"], name: "index_features_websites_sites_on_university_id"
  end

  create_table "universities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.boolean "private"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email", "university_id"], name: "index_users_on_email_and_university_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["university_id"], name: "index_users_on_university_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "features_education_programs", "universities"
  add_foreign_key "features_education_qualiopi_indicators", "features_education_qualiopi_criterions", column: "criterion_id"
  add_foreign_key "features_websites_sites", "universities"
  add_foreign_key "users", "universities"
end
