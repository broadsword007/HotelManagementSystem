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

ActiveRecord::Schema.define(version: 20180428140531) do

  create_table "bookings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.date     "from"
    t.date     "to"
    t.boolean  "hasCheckedOut"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["room_id"], name: "index_bookings_on_room_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.string   "content"
    t.integer  "user_id"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "hotels", force: :cascade do |t|
    t.string   "name"
    t.string   "slogan"
    t.string   "location"
    t.string   "hotel_pic_path"
    t.string   "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "room_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "rate"
    t.string   "category_pic_path"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "number"
    t.boolean  "isAvailable"
    t.string   "description"
    t.integer  "room_category_id"
    t.string   "price"
    t.integer  "user_id"
    t.float    "rating"
    t.string   "room_pic_path"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["room_category_id"], name: "index_rooms_on_room_category_id"
    t.index ["user_id"], name: "index_rooms_on_user_id"
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
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "profile_pic"
    t.string   "firstname"
    t.string   "lastname"
    t.date     "dob"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
