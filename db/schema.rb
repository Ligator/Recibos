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

ActiveRecord::Schema.define(version: 20160701134602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "payments", force: :cascade do |t|
    t.integer  "user_transaction_id"
    t.datetime "programmed_date"
    t.datetime "done_date"
    t.decimal  "amount"
    t.boolean  "confirm_payer"
    t.boolean  "confirm_payee"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "transaction_id"
  end

  add_index "payments", ["transaction_id"], name: "index_payments_on_transaction_id", using: :btree
  add_index "payments", ["user_transaction_id"], name: "index_payments_on_user_transaction_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.date     "date"
    t.decimal  "amount"
    t.text     "description"
    t.string   "image"
    t.integer  "payer_id"
    t.integer  "payee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "confirm_payee", default: false
    t.boolean  "confirm_payer", default: false
    t.boolean  "seen_by_payer", default: false
    t.boolean  "seen_by_payee", default: false
    t.decimal  "interest",      default: 0.0
    t.string   "name"
    t.string   "period"
  end

  create_table "user_transactions", force: :cascade do |t|
    t.integer  "transaction_id"
    t.integer  "users_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "authentication_token"
    t.string   "avatar"
    t.string   "name"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "payments", "transactions"
  add_foreign_key "payments", "user_transactions"
end
