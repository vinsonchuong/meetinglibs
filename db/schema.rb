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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130219152138) do

  create_table "events", :force => true do |t|
    t.text     "name"
    t.boolean  "archived"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "events", ["archived"], :name => "index_events_on_archived"

  create_table "hosts", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "hosts", ["event_id"], :name => "index_hosts_on_event_id"
  add_index "hosts", ["user_id"], :name => "index_hosts_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.text     "cas_user"
    t.text     "token"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "administrator"
    t.text     "first_name"
    t.text     "last_name"
    t.text     "email"
  end

  add_index "users", ["cas_user"], :name => "index_users_on_cas_user"
  add_index "users", ["token"], :name => "index_users_on_token"

  create_table "visitors", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "visitors", ["event_id"], :name => "index_visitors_on_event_id"
  add_index "visitors", ["user_id"], :name => "index_visitors_on_user_id"

end
