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

ActiveRecord::Schema[7.1].define(version: 2024_07_08_120957) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "action_text_rich_texts", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.uuid "university_id"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
    t.index ["university_id"], name: "index_active_storage_blobs_on_university_id"
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "administration_locations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.text "summary"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.string "phone"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "address_additional"
    t.string "address_name"
    t.text "featured_image_alt"
    t.text "featured_image_credit"
    t.uuid "language_id", null: false
    t.uuid "original_id"
    t.index ["language_id"], name: "index_administration_locations_on_language_id"
    t.index ["original_id"], name: "index_administration_locations_on_original_id"
    t.index ["university_id"], name: "index_administration_locations_on_university_id"
  end

  create_table "administration_locations_education_programs", id: false, force: :cascade do |t|
    t.uuid "education_program_id", null: false
    t.uuid "administration_location_id", null: false
    t.index ["administration_location_id", "education_program_id"], name: "index_program_location"
    t.index ["education_program_id", "administration_location_id"], name: "index_location_program"
  end

  create_table "administration_locations_education_schools", id: false, force: :cascade do |t|
    t.uuid "education_school_id", null: false
    t.uuid "administration_location_id", null: false
    t.index ["administration_location_id", "education_school_id"], name: "index_school_location"
    t.index ["education_school_id", "administration_location_id"], name: "index_location_school"
  end

  create_table "administration_qualiopi_criterions", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.integer "number"
    t.text "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administration_qualiopi_indicators", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "criterion_id", null: false
    t.integer "number"
    t.text "name"
    t.text "level_expected"
    t.text "proof"
    t.text "requirement"
    t.text "non_conformity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "glossary"
    t.index ["criterion_id"], name: "index_administration_qualiopi_indicators_on_criterion_id"
  end

  create_table "communication_block_headings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.string "title"
    t.integer "level", default: 2
    t.uuid "parent_id"
    t.integer "position"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "migration_identifier"
    t.index ["about_type", "about_id"], name: "index_communication_block_headings_on_about"
    t.index ["parent_id"], name: "index_communication_block_headings_on_parent_id"
    t.index ["slug"], name: "index_communication_block_headings_on_slug"
    t.index ["university_id"], name: "index_communication_block_headings_on_university_id"
  end

  create_table "communication_blocks", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "about_type"
    t.uuid "about_id"
    t.integer "template_kind", default: 0, null: false
    t.jsonb "data"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "published", default: true
    t.uuid "heading_id"
    t.uuid "communication_website_id"
    t.string "migration_identifier"
    t.index ["about_type", "about_id"], name: "index_communication_website_blocks_on_about"
    t.index ["communication_website_id"], name: "index_communication_blocks_on_communication_website_id"
    t.index ["heading_id"], name: "index_communication_blocks_on_heading_id"
    t.index ["university_id"], name: "index_communication_blocks_on_university_id"
  end

  create_table "communication_extranet_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "extranet_id", null: false
    t.string "about_type"
    t.uuid "about_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["about_type", "about_id"], name: "index_communication_extranet_connections_on_object"
    t.index ["extranet_id"], name: "index_communication_extranet_connections_on_extranet_id"
    t.index ["university_id"], name: "index_communication_extranet_connections_on_university_id"
  end

