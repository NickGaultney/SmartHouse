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

ActiveRecord::Schema.define(version: 2021_11_13_063916) do

  create_table "inputs", force: :cascade do |t|
    t.string "name"
    t.string "ip_address"
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "network_devices", force: :cascade do |t|
    t.string "ip_address"
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sensors", force: :cascade do |t|
    t.string "sensor_type"
    t.integer "gpio"
    t.integer "input_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "state"
    t.index ["input_id"], name: "index_sensors_on_input_id"
  end

  create_table "slave_switches", force: :cascade do |t|
    t.string "name"
    t.integer "switch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ip_address"
    t.string "topic"
    t.string "switch_mode"
    t.index ["switch_id"], name: "index_slave_switches_on_switch_id"
  end

  create_table "switches", force: :cascade do |t|
    t.string "name"
    t.string "topic"
    t.string "ip_address"
    t.boolean "state"
    t.string "coordinates", default: "1%,1%"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
