# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150206193702) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "bugs", force: true do |t|
    t.string   "title"
    t.text     "details"
    t.string   "bugster"
    t.string   "email"
    t.integer  "org"
    t.string   "status",     default: "Reported"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.string   "push_date",  default: "TBA"
    t.string   "task_id"
  end

  add_index "bugs", ["org"], name: "index_bugs_on_org", using: :btree
  add_index "bugs", ["status"], name: "index_bugs_on_status", using: :btree

  create_table "comments", force: true do |t|
    t.string   "user_name"
    t.text     "body"
    t.integer  "bug_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "request_id"
    t.string   "story_id"
  end

  add_index "comments", ["request_id"], name: "index_comments_on_request_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "bug_id"
    t.integer  "request_id"
  end

  add_index "images", ["request_id"], name: "index_images_on_request_id", using: :btree

  create_table "requests", force: true do |t|
    t.string   "title"
    t.text     "details"
    t.string   "email"
    t.integer  "user_id"
    t.integer  "org"
    t.string   "status",     default: "Requested"
    t.string   "category"
    t.string   "push_date",  default: "TBA"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "task_id"
  end

  add_index "requests", ["org"], name: "index_requests_on_org", using: :btree
  add_index "requests", ["user_id"], name: "index_requests_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "auth_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "org"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
