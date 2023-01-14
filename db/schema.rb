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

ActiveRecord::Schema[7.0].define(version: 2023_01_14_124308) do
  # These are extensions that must be enabled in order to support this database
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
    t.index ["about_type", "about_id"], name: "index_communication_website_blocks_on_about"
    t.index ["university_id"], name: "index_communication_blocks_on_university_id"
  end

  create_table "communication_extranets", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "university_id", null: false
    t.string "host"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "about_type"
    t.uuid "about_id"
    t.string "registration_contact"
    t.boolean "has_sso", default: false
    t.text "sso_cert"
    t.jsonb "sso_mapping"
    t.string "sso_name_identifier_format"
    t.integer "sso_provider", default: 0
    t.string "sso_target_url"
    t.text "terms"
    t.text "privacy_policy"
    t.text "cookies_policy"
    t.string "color"
    t.string "sso_button_label"
    t.index ["about_type", "about_id"], name: "index_communication_extranets_on_about"
    t.index ["university_id"], name: "index_communication_extranets_on_university_id"
  end

  create_table "communication_website_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.string "name"
    t.text "meta_description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.uuid "parent_id"
    t.text "github_path"
    t.uuid "program_id"
    t.boolean "is_programs_root", default: false
    t.string "path"
    t.string "featured_image_alt"
    t.text "summary"
    t.text "featured_image_credit"
    t.index ["communication_website_id"], name: "idx_communication_website_post_cats_on_communication_website_id"
    t.index ["parent_id"], name: "index_communication_website_categories_on_parent_id"
    t.index ["program_id"], name: "index_communication_website_categories_on_program_id"
    t.index ["university_id"], name: "index_communication_website_categories_on_university_id"
  end

  create_table "communication_website_categories_posts", id: false, force: :cascade do |t|
    t.uuid "communication_website_post_id", null: false
    t.uuid "communication_website_category_id", null: false
    t.index ["communication_website_category_id", "communication_website_post_id"], name: "category_post"
    t.index ["communication_website_post_id", "communication_website_category_id"], name: "post_category"
  end

  create_table "communication_website_git_files", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "previous_path"
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.uuid "website_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "previous_sha"
    t.index ["about_type", "about_id"], name: "index_communication_website_github_files_on_about"
    t.index ["website_id"], name: "index_communication_website_git_files_on_website_id"
  end

  create_table "communication_website_imported_authors", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.uuid "author_id"
    t.string "name"
    t.text "description"
    t.string "slug"
    t.string "identifier"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "idx_communication_website_imported_auth_on_author"
    t.index ["university_id"], name: "idx_communication_website_imported_auth_on_university"
    t.index ["website_id"], name: "idx_communication_website_imported_auth_on_website"
  end

  create_table "communication_website_imported_categories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.uuid "category_id"
    t.string "name"
    t.text "description"
    t.string "identifier"
    t.string "slug"
    t.string "url"
    t.string "parent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "data"
    t.index ["category_id"], name: "idx_communication_website_imported_cat_on_category"
    t.index ["university_id"], name: "idx_communication_website_imported_cat_on_university"
    t.index ["website_id"], name: "idx_communication_website_imported_cat_on_website"
  end

  create_table "communication_website_imported_media", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "identifier"
    t.jsonb "data"
    t.text "file_url"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.string "filename"
    t.string "mime_type"
    t.text "variant_urls", default: [], array: true
    t.index ["university_id"], name: "index_communication_website_imported_media_on_university_id"
    t.index ["website_id"], name: "index_communication_website_imported_media_on_website_id"
  end

  create_table "communication_website_imported_pages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.uuid "page_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "content"
    t.text "path"
    t.text "url"
    t.string "identifier"
    t.text "excerpt"
    t.string "parent"
    t.text "slug"
    t.jsonb "data"
    t.uuid "featured_medium_id"
    t.index ["featured_medium_id"], name: "idx_communication_website_imported_pages_on_featured_medium_id"
    t.index ["identifier"], name: "index_communication_website_imported_pages_on_identifier"
    t.index ["page_id"], name: "index_communication_website_imported_pages_on_page_id"
    t.index ["university_id"], name: "index_communication_website_imported_pages_on_university_id"
    t.index ["website_id"], name: "index_communication_website_imported_pages_on_website_id"
  end

  create_table "communication_website_imported_posts", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.uuid "post_id"
    t.integer "status", default: 0
    t.string "title"
    t.text "excerpt"
    t.text "content"
    t.text "path"
    t.text "url"
    t.datetime "published_at", precision: nil
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "slug"
    t.jsonb "data"
    t.uuid "featured_medium_id"
    t.string "author"
    t.jsonb "categories"
    t.index ["featured_medium_id"], name: "idx_communication_website_imported_posts_on_featured_medium_id"
    t.index ["post_id"], name: "index_communication_website_imported_posts_on_post_id"
    t.index ["university_id"], name: "index_communication_website_imported_posts_on_university_id"
    t.index ["website_id"], name: "index_communication_website_imported_posts_on_website_id"
  end

  create_table "communication_website_imported_websites", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_communication_website_imported_websites_on_university_id"
    t.index ["website_id"], name: "index_communication_website_imported_websites_on_website_id"
  end

  create_table "communication_website_menu_items", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.uuid "menu_id", null: false
    t.string "title"
    t.integer "position"
    t.integer "kind", default: 0
    t.uuid "parent_id"
    t.string "about_type"
    t.uuid "about_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "url"
    t.index ["about_type", "about_id"], name: "index_communication_website_menu_items_on_about"
    t.index ["menu_id"], name: "index_communication_website_menu_items_on_menu_id"
    t.index ["parent_id"], name: "index_communication_website_menu_items_on_parent_id"
    t.index ["university_id"], name: "index_communication_website_menu_items_on_university_id"
    t.index ["website_id"], name: "index_communication_website_menu_items_on_website_id"
  end

  create_table "communication_website_menus", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.string "title"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "github_path"
    t.index ["communication_website_id"], name: "idx_comm_website_menus_on_communication_website_id"
    t.index ["university_id"], name: "index_communication_website_menus_on_university_id"
  end

  create_table "communication_website_pages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.string "title"
    t.text "meta_description"
    t.string "slug"
    t.text "path"
    t.uuid "parent_id"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.text "github_path"
    t.string "featured_image_alt"
    t.text "text"
    t.text "summary"
    t.string "breadcrumb_title"
    t.text "header_text"
    t.integer "kind"
    t.string "bodyclass"
    t.uuid "language_id"
    t.text "featured_image_credit"
    t.boolean "full_width", default: false
    t.string "type"
    t.index ["communication_website_id"], name: "index_communication_website_pages_on_communication_website_id"
    t.index ["language_id"], name: "index_communication_website_pages_on_language_id"
    t.index ["parent_id"], name: "index_communication_website_pages_on_parent_id"
    t.index ["university_id"], name: "index_communication_website_pages_on_university_id"
  end

  create_table "communication_website_permalinks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "website_id", null: false
    t.string "about_type", null: false
    t.uuid "about_id", null: false
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_current", default: true
    t.index ["about_type", "about_id"], name: "index_communication_website_permalinks_on_about"
    t.index ["university_id"], name: "index_communication_website_permalinks_on_university_id"
    t.index ["website_id"], name: "index_communication_website_permalinks_on_website_id"
  end

  create_table "communication_website_posts", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "communication_website_id", null: false
    t.string "title"
    t.text "meta_description"
    t.boolean "published", default: false
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "slug"
    t.text "github_path"
    t.uuid "author_id"
    t.boolean "pinned", default: false
    t.string "featured_image_alt"
    t.text "text"
    t.text "summary"
    t.uuid "language_id"
    t.text "featured_image_credit"
    t.index ["author_id"], name: "index_communication_website_posts_on_author_id"
    t.index ["communication_website_id"], name: "index_communication_website_posts_on_communication_website_id"
    t.index ["language_id"], name: "index_communication_website_posts_on_language_id"
    t.index ["university_id"], name: "index_communication_website_posts_on_university_id"
  end

  create_table "communication_websites", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_token"
    t.string "repository"
    t.string "about_type"
    t.uuid "about_id"
    t.integer "git_provider", default: 0
    t.string "git_endpoint"
    t.text "style"
    t.date "style_updated_at"
    t.string "plausible_url"
    t.string "git_branch"
    t.boolean "in_production", default: false
    t.uuid "default_language_id", null: false
    t.string "theme_version"
    t.index ["about_type", "about_id"], name: "index_communication_websites_on_about"
    t.index ["default_language_id"], name: "index_communication_websites_on_default_language_id"
    t.index ["university_id"], name: "index_communication_websites_on_university_id"
  end

  create_table "communication_websites_languages", id: false, force: :cascade do |t|
    t.uuid "communication_website_id", null: false
    t.uuid "language_id", null: false
    t.index ["communication_website_id", "language_id"], name: "website_language"
  end

  create_table "communication_websites_users", id: false, force: :cascade do |t|
    t.uuid "communication_website_id", null: false
    t.uuid "user_id", null: false
    t.index ["communication_website_id", "user_id"], name: "website_user"
    t.index ["user_id", "communication_website_id"], name: "user_website"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: nil
    t.datetime "locked_at", precision: nil
    t.datetime "failed_at", precision: nil
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "education_academic_years", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_education_academic_years_on_university_id"
  end

  create_table "education_academic_years_university_people", id: false, force: :cascade do |t|
    t.uuid "university_person_id", null: false
    t.uuid "education_academic_year_id", null: false
    t.index ["education_academic_year_id", "university_person_id"], name: "index_academic_year_person"
    t.index ["university_person_id", "education_academic_year_id"], name: "index_person_academic_year"
  end

  create_table "education_cohorts", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "program_id", null: false
    t.uuid "academic_year_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "school_id", null: false
    t.index ["academic_year_id"], name: "index_education_cohorts_on_academic_year_id"
    t.index ["program_id"], name: "index_education_cohorts_on_program_id"
    t.index ["school_id"], name: "index_education_cohorts_on_school_id"
    t.index ["university_id"], name: "index_education_cohorts_on_university_id"
  end

  create_table "education_cohorts_university_people", id: false, force: :cascade do |t|
    t.uuid "education_cohort_id", null: false
    t.uuid "university_person_id", null: false
    t.index ["education_cohort_id", "university_person_id"], name: "index_cohort_person"
    t.index ["university_person_id", "education_cohort_id"], name: "index_person_cohort"
  end

  create_table "education_diplomas", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.integer "level", default: 0
    t.string "slug"
    t.uuid "university_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ects"
    t.text "duration"
    t.text "summary"
    t.index ["university_id"], name: "index_education_diplomas_on_university_id"
  end

  create_table "education_programs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.integer "capacity"
    t.boolean "continuing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "parent_id"
    t.integer "position", default: 0
    t.string "slug"
    t.string "path"
    t.text "meta_description"
    t.boolean "published", default: false
    t.string "featured_image_alt"
    t.text "accessibility"
    t.text "contacts"
    t.text "duration"
    t.text "evaluation"
    t.text "objectives"
    t.text "opportunities"
    t.text "other"
    t.text "pedagogy"
    t.text "prerequisites"
    t.text "pricing"
    t.text "registration"
    t.text "content"
    t.text "results"
    t.text "presentation"
    t.text "featured_image_credit"
    t.uuid "diploma_id"
    t.string "short_name"
    t.boolean "initial"
    t.boolean "apprenticeship"
    t.string "registration_url"
    t.text "summary"
    t.index ["diploma_id"], name: "index_education_programs_on_diploma_id"
    t.index ["parent_id"], name: "index_education_programs_on_parent_id"
    t.index ["university_id"], name: "index_education_programs_on_university_id"
  end

  create_table "education_programs_schools", id: false, force: :cascade do |t|
    t.uuid "education_program_id", null: false
    t.uuid "education_school_id", null: false
    t.index ["education_program_id", "education_school_id"], name: "program_school"
    t.index ["education_school_id", "education_program_id"], name: "school_program"
  end

  create_table "education_programs_university_people", id: false, force: :cascade do |t|
    t.uuid "university_person_id", null: false
    t.uuid "education_program_id", null: false
    t.index ["education_program_id", "university_person_id"], name: "index_program_person"
    t.index ["university_person_id", "education_program_id"], name: "index_person_program"
  end

  create_table "education_programs_users", id: false, force: :cascade do |t|
    t.uuid "education_program_id", null: false
    t.uuid "user_id", null: false
    t.index ["education_program_id", "user_id"], name: "index_education_programs_users_on_program_id_and_user_id"
  end

  create_table "education_schools", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.index ["university_id"], name: "index_education_schools_on_university_id"
  end

  create_table "imports", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.integer "number_of_lines"
    t.jsonb "processing_errors"
    t.integer "kind"
    t.integer "status", default: 0
    t.uuid "university_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_imports_on_university_id"
    t.index ["user_id"], name: "index_imports_on_user_id"
  end

  create_table "languages", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "iso_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "summernote_locale"
  end

  create_table "research_documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "university_person_id", null: false
    t.string "docid"
    t.jsonb "data"
    t.string "title"
    t.string "url"
    t.string "ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hal_url"
    t.date "publication_date"
    t.string "doi"
    t.index ["university_id"], name: "index_research_documents_on_university_id"
    t.index ["university_person_id"], name: "index_research_documents_on_university_person_id"
  end

  create_table "research_journal_papers", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.datetime "published_at", precision: nil
    t.uuid "university_id", null: false
    t.uuid "research_journal_id", null: false
    t.uuid "research_journal_volume_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "updated_by_id"
    t.text "abstract"
    t.text "references"
    t.text "keywords"
    t.string "slug"
    t.boolean "published", default: false
    t.integer "position"
    t.text "text"
    t.text "meta_description"
    t.text "summary"
    t.index ["research_journal_id"], name: "index_research_journal_papers_on_research_journal_id"
    t.index ["research_journal_volume_id"], name: "index_research_journal_papers_on_research_journal_volume_id"
    t.index ["university_id"], name: "index_research_journal_papers_on_university_id"
    t.index ["updated_by_id"], name: "index_research_journal_papers_on_updated_by_id"
  end

  create_table "research_journal_papers_researchers", force: :cascade do |t|
    t.uuid "researcher_id", null: false
    t.uuid "paper_id", null: false
    t.index ["paper_id"], name: "index_research_journal_papers_researchers_on_paper_id"
    t.index ["researcher_id"], name: "index_research_journal_papers_researchers_on_researcher_id"
  end

  create_table "research_journal_volumes", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "research_journal_id", null: false
    t.string "title"
    t.integer "number"
    t.datetime "published_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "meta_description"
    t.text "keywords"
    t.string "slug"
    t.string "featured_image_alt"
    t.boolean "published", default: false
    t.text "text"
    t.text "featured_image_credit"
    t.text "summary"
    t.index ["research_journal_id"], name: "index_research_journal_volumes_on_research_journal_id"
    t.index ["university_id"], name: "index_research_journal_volumes_on_university_id"
  end

  create_table "research_journals", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "title"
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "issn"
    t.text "summary"
    t.index ["university_id"], name: "index_research_journals_on_university_id"
  end

  create_table "research_laboratories", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["university_id"], name: "index_research_laboratories_on_university_id"
  end

  create_table "research_laboratory_axes", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "research_laboratory_id", null: false
    t.string "name"
    t.text "meta_description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "short_name"
    t.text "text"
    t.index ["research_laboratory_id"], name: "index_research_laboratory_axes_on_research_laboratory_id"
    t.index ["university_id"], name: "index_research_laboratory_axes_on_university_id"
  end

  create_table "research_theses", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "research_laboratory_id", null: false
    t.uuid "author_id", null: false
    t.uuid "director_id", null: false
    t.string "title"
    t.text "abstract"
    t.date "started_at"
    t.boolean "completed", default: false
    t.date "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_research_theses_on_author_id"
    t.index ["director_id"], name: "index_research_theses_on_director_id"
    t.index ["research_laboratory_id"], name: "index_research_theses_on_research_laboratory_id"
    t.index ["university_id"], name: "index_research_theses_on_university_id"
  end

  create_table "universities", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.boolean "private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mail_from_name"
    t.string "mail_from_address"
    t.string "sms_sender_name"
    t.date "invoice_date"
    t.integer "invoice_date_yday"
    t.string "invoice_amount"
    t.boolean "has_sso", default: false
    t.integer "sso_provider", default: 0
    t.string "sso_target_url"
    t.text "sso_cert"
    t.string "sso_name_identifier_format"
    t.jsonb "sso_mapping"
    t.string "sso_button_label"
  end

  create_table "university_organizations", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "name"
    t.string "long_name"
    t.text "meta_description"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.string "url"
    t.string "phone"
    t.string "email"
    t.boolean "active", default: true
    t.string "siren"
    t.integer "kind", default: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.text "text"
    t.string "nic"
    t.text "summary"
    t.string "twitter"
    t.string "linkedin"
    t.index ["university_id"], name: "index_university_organizations_on_university_id"
  end

  create_table "university_people", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "user_id"
    t.string "last_name"
    t.string "first_name"
    t.string "slug"
    t.boolean "is_researcher"
    t.boolean "is_teacher"
    t.boolean "is_administration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_mobile"
    t.string "email"
    t.text "meta_description"
    t.boolean "habilitation", default: false
    t.boolean "tenure", default: false
    t.text "biography"
    t.string "url"
    t.string "twitter"
    t.string "linkedin"
    t.boolean "is_alumnus", default: false
    t.text "summary"
    t.boolean "is_author"
    t.string "name"
    t.integer "gender"
    t.date "birthdate"
    t.string "phone_professional"
    t.string "phone_personal"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.string "country"
    t.string "hal_person_identifier"
    t.string "hal_doc_identifier"
    t.string "hal_form_identifier"
    t.index ["university_id"], name: "index_university_people_on_university_id"
    t.index ["user_id"], name: "index_university_people_on_user_id"
  end

  create_table "university_person_experiences", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "person_id", null: false
    t.uuid "organization_id", null: false
    t.text "description"
    t.integer "from_year"
    t.integer "to_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_university_person_experiences_on_organization_id"
    t.index ["person_id"], name: "index_university_person_experiences_on_person_id"
    t.index ["university_id"], name: "index_university_person_experiences_on_university_id"
  end

  create_table "university_person_involvements", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.uuid "person_id", null: false
    t.integer "kind"
    t.string "target_type", null: false
    t.uuid "target_id", null: false
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_university_person_involvements_on_person_id"
    t.index ["target_type", "target_id"], name: "index_university_person_involvements_on_target"
    t.index ["university_id"], name: "index_university_person_involvements_on_university_id"
  end

  create_table "university_roles", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "target_type"
    t.uuid "target_id"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_type", "target_id"], name: "index_university_roles_on_target"
    t.index ["university_id"], name: "index_university_roles_on_university_id"
  end

  create_table "users", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "university_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role", default: 0
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "language_id"
    t.string "mobile_phone"
    t.integer "second_factor_attempts_count", default: 0
    t.string "encrypted_otp_secret_key"
    t.string "encrypted_otp_secret_key_iv"
    t.string "encrypted_otp_secret_key_salt"
    t.string "direct_otp"
    t.datetime "direct_otp_sent_at", precision: nil
    t.datetime "totp_timestamp", precision: nil
    t.string "session_token"
    t.string "picture_url"
    t.string "direct_otp_delivery_method"
    t.integer "admin_theme", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email", "university_id"], name: "index_users_on_email_and_university_id", unique: true
    t.index ["encrypted_otp_secret_key"], name: "index_users_on_encrypted_otp_secret_key", unique: true
    t.index ["language_id"], name: "index_users_on_language_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["university_id"], name: "index_users_on_university_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "administration_qualiopi_indicators", "administration_qualiopi_criterions", column: "criterion_id"
  add_foreign_key "communication_blocks", "universities"
  add_foreign_key "communication_extranets", "universities"
  add_foreign_key "communication_website_categories", "communication_website_categories", column: "parent_id"
  add_foreign_key "communication_website_categories", "communication_websites"
  add_foreign_key "communication_website_categories", "education_programs", column: "program_id"
  add_foreign_key "communication_website_categories", "universities"
  add_foreign_key "communication_website_git_files", "communication_websites", column: "website_id"
  add_foreign_key "communication_website_imported_authors", "communication_website_imported_websites", column: "website_id"
  add_foreign_key "communication_website_imported_authors", "universities"
  add_foreign_key "communication_website_imported_authors", "university_people", column: "author_id"
  add_foreign_key "communication_website_imported_categories", "communication_website_categories", column: "category_id"
  add_foreign_key "communication_website_imported_categories", "communication_website_imported_websites", column: "website_id"
  add_foreign_key "communication_website_imported_categories", "universities"
  add_foreign_key "communication_website_imported_media", "communication_website_imported_websites", column: "website_id"
  add_foreign_key "communication_website_imported_media", "universities"
  add_foreign_key "communication_website_imported_pages", "communication_website_imported_media", column: "featured_medium_id"
  add_foreign_key "communication_website_imported_pages", "communication_website_imported_websites", column: "website_id"
  add_foreign_key "communication_website_imported_pages", "communication_website_pages", column: "page_id"
  add_foreign_key "communication_website_imported_pages", "universities"
  add_foreign_key "communication_website_imported_posts", "communication_website_imported_media", column: "featured_medium_id"
  add_foreign_key "communication_website_imported_posts", "communication_website_imported_websites", column: "website_id"
  add_foreign_key "communication_website_imported_posts", "communication_website_posts", column: "post_id"
  add_foreign_key "communication_website_imported_posts", "universities"
  add_foreign_key "communication_website_imported_websites", "communication_websites", column: "website_id"
  add_foreign_key "communication_website_imported_websites", "universities"
  add_foreign_key "communication_website_menu_items", "communication_website_menu_items", column: "parent_id"
  add_foreign_key "communication_website_menu_items", "communication_website_menus", column: "menu_id"
  add_foreign_key "communication_website_menu_items", "communication_websites", column: "website_id"
  add_foreign_key "communication_website_menu_items", "universities"
  add_foreign_key "communication_website_menus", "communication_websites"
  add_foreign_key "communication_website_menus", "universities"
  add_foreign_key "communication_website_pages", "communication_website_pages", column: "parent_id"
  add_foreign_key "communication_website_pages", "communication_websites"
  add_foreign_key "communication_website_pages", "universities"
  add_foreign_key "communication_website_permalinks", "communication_websites", column: "website_id"
  add_foreign_key "communication_website_permalinks", "universities"
  add_foreign_key "communication_website_posts", "communication_websites"
  add_foreign_key "communication_website_posts", "universities"
  add_foreign_key "communication_website_posts", "university_people", column: "author_id"
  add_foreign_key "communication_websites", "languages", column: "default_language_id"
  add_foreign_key "communication_websites", "universities"
  add_foreign_key "education_academic_years", "universities"
  add_foreign_key "education_cohorts", "education_academic_years", column: "academic_year_id"
  add_foreign_key "education_cohorts", "education_programs", column: "program_id"
  add_foreign_key "education_cohorts", "education_schools", column: "school_id"
  add_foreign_key "education_cohorts", "universities"
  add_foreign_key "education_diplomas", "universities"
  add_foreign_key "education_programs", "education_programs", column: "parent_id"
  add_foreign_key "education_programs", "universities"
  add_foreign_key "education_schools", "universities"
  add_foreign_key "imports", "universities"
  add_foreign_key "imports", "users"
  add_foreign_key "research_documents", "universities"
  add_foreign_key "research_documents", "university_people"
  add_foreign_key "research_journal_papers", "research_journal_volumes"
  add_foreign_key "research_journal_papers", "research_journals"
  add_foreign_key "research_journal_papers", "universities"
  add_foreign_key "research_journal_papers", "users", column: "updated_by_id"
  add_foreign_key "research_journal_papers_researchers", "research_journal_papers", column: "paper_id"
  add_foreign_key "research_journal_papers_researchers", "university_people", column: "researcher_id"
  add_foreign_key "research_journal_volumes", "research_journals"
  add_foreign_key "research_journal_volumes", "universities"
  add_foreign_key "research_journals", "universities"
  add_foreign_key "research_laboratories", "universities"
  add_foreign_key "research_laboratory_axes", "research_laboratories"
  add_foreign_key "research_laboratory_axes", "universities"
  add_foreign_key "research_theses", "research_laboratories"
  add_foreign_key "research_theses", "universities"
  add_foreign_key "research_theses", "university_people", column: "author_id"
  add_foreign_key "research_theses", "university_people", column: "director_id"
  add_foreign_key "university_organizations", "universities"
  add_foreign_key "university_people", "universities"
  add_foreign_key "university_people", "users"
  add_foreign_key "university_person_experiences", "universities"
  add_foreign_key "university_person_experiences", "university_organizations", column: "organization_id"
  add_foreign_key "university_person_experiences", "university_people", column: "person_id"
  add_foreign_key "university_person_involvements", "universities"
  add_foreign_key "university_person_involvements", "university_people", column: "person_id"
  add_foreign_key "university_roles", "universities"
  add_foreign_key "users", "languages"
  add_foreign_key "users", "universities"
end
