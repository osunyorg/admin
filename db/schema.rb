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

ActiveRecord::Schema.define(version: 2021_09_07_155328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "administration_qualiopi_criterions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "number"
    t.text "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "administration_qualiopi_indicators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "criterion_id", null: false
    t.integer "number"
    t.text "name"
    t.text "level_expected"
    t.text "proof"
    t.text "requirement"
    t.text "non_conformity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "glossary"
    t.index ["criterion_id"], name: "index_administration_qualiopi_indicators_on_criterion_id"
  end

  create_table "communication_website_pages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.string "title"
    t.text "description"
    t.string "slug"
    t.text "path"
    t.datetime "published_at"
    t.uuid "parent_id"
    t.integer "position", default: 0, null: false
    t.string "about_type"
    t.uuid "about_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["about_type", "about_id"], name: "index_communication_website_pages_on_about"
    t.index ["communication_website_id"], name: "index_communication_website_pages_on_communication_website_id"
    t.index ["parent_id"], name: "index_communication_website_pages_on_parent_id"
    t.index ["university_id"], name: "index_communication_website_pages_on_university_id"
  end

  create_table "communication_websites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.string "domain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "access_token"
    t.string "repository"
    t.string "about_type"
    t.uuid "about_id"
    t.index ["about_type", "about_id"], name: "index_communication_websites_on_about"
    t.index ["university_id"], name: "index_communication_websites_on_university_id"
  end

  create_table "education_programs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.index ["university_id"], name: "index_education_programs_on_university_id"
  end

  create_table "research_journal_articles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.date "published_at"
    t.uuid "university_id", null: false
    t.uuid "research_journal_id", null: false
    t.uuid "research_journal_volume_id"
    t.datetime "created_at", precision: 6, null: false
    t.date "updated_at", null: false
    t.uuid "updated_by_id"
    t.index ["research_journal_id"], name: "index_research_journal_articles_on_research_journal_id"
    t.index ["research_journal_volume_id"], name: "index_research_journal_articles_on_research_journal_volume_id"
    t.index ["university_id"], name: "index_research_journal_articles_on_university_id"
    t.index ["updated_by_id"], name: "index_research_journal_articles_on_updated_by_id"
  end

  create_table "research_journal_articles_researchers", force: :cascade do |t|
    t.uuid "researcher_id", null: false
    t.uuid "article_id", null: false
    t.index ["article_id"], name: "index_research_journal_articles_researchers_on_article_id"
    t.index ["researcher_id"], name: "index_research_journal_articles_researchers_on_researcher_id"
  end

  create_table "research_journal_volumes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "research_journal_id", null: false
    t.string "title"
    t.integer "number"
    t.datetime "published_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.index ["research_journal_id"], name: "index_research_journal_volumes_on_research_journal_id"
    t.index ["university_id"], name: "index_research_journal_volumes_on_university_id"
  end

  create_table "research_journals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "access_token"
    t.string "repository"
    t.index ["university_id"], name: "index_research_journals_on_university_id"
  end

  create_table "research_researchers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "biography"
    t.uuid "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_research_researchers_on_user_id"
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

  add_foreign_key "administration_qualiopi_indicators", "administration_qualiopi_criterions", column: "criterion_id"
  add_foreign_key "communication_website_pages", "communication_website_pages", column: "parent_id"
  add_foreign_key "communication_website_pages", "communication_websites"
  add_foreign_key "communication_website_pages", "universities"
  add_foreign_key "communication_websites", "universities"
  add_foreign_key "education_programs", "universities"
  add_foreign_key "research_journal_articles", "research_journal_volumes"
  add_foreign_key "research_journal_articles", "research_journals"
  add_foreign_key "research_journal_articles", "universities"
  add_foreign_key "research_journal_articles", "users", column: "updated_by_id"
  add_foreign_key "research_journal_articles_researchers", "research_journal_articles", column: "article_id"
  add_foreign_key "research_journal_articles_researchers", "research_researchers", column: "researcher_id"
  add_foreign_key "research_journal_volumes", "research_journals"
  add_foreign_key "research_journal_volumes", "universities"
  add_foreign_key "research_journals", "universities"
  add_foreign_key "research_researchers", "users"
  add_foreign_key "users", "universities"
end
