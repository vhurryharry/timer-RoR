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

ActiveRecord::Schema.define(version: 20170714171721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.integer "routine_id"
    t.integer "order", default: 1
    t.integer "times", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["routine_id"], name: "index_groups_on_routine_id"
  end

  create_table "intervals", force: :cascade do |t|
    t.integer "group_id"
    t.string "name"
    t.integer "order", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration", default: 0
    t.index ["group_id"], name: "index_intervals_on_group_id"
  end

  create_table "routines", force: :cascade do |t|
    t.string "name"
    t.text "description", default: ""
    t.string "link", default: ""
    t.integer "times", default: 1
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false
    t.index ["user_id"], name: "index_routines_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.index ["email"], name: "index_users_on_email", unique: true
  end


  create_view "routine_durations", sql_definition: <<-SQL
      SELECT routines.id AS routine_id,
      sum(((groups.times * intervals.duration) * routines.times)) AS total
     FROM ((routines
       JOIN groups ON ((routines.id = groups.routine_id)))
       JOIN intervals ON ((groups.id = intervals.group_id)))
    GROUP BY routines.id, routines.name;
  SQL
end
