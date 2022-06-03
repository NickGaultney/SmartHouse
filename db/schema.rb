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

ActiveRecord::Schema.define(version: 2022_06_03_024713) do

  create_table "buttons", force: :cascade do |t|
    t.string "coordinates"
    t.string "buttonable_type"
    t.integer "buttonable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "icon_id"
    t.index ["buttonable_type", "buttonable_id"], name: "index_buttons_on_buttonable_type_and_buttonable_id"
    t.index ["icon_id"], name: "index_buttons_on_icon_id"
  end

  create_table "events", force: :cascade do |t|
    t.boolean "enabled"
    t.string "days_to_repeat"
    t.date "start_date"
    t.date "end_date"
    t.time "time"
    t.integer "frequency"
    t.string "repeat_type"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "end_time"
  end

  create_table "events_groups", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "group_id"
    t.index ["event_id"], name: "index_events_groups_on_event_id"
    t.index ["group_id"], name: "index_events_groups_on_group_id"
  end

  create_table "events_outputs", id: false, force: :cascade do |t|
    t.integer "event_id"
    t.integer "output_id"
    t.index ["event_id"], name: "index_events_outputs_on_event_id"
    t.index ["output_id"], name: "index_events_outputs_on_output_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_inputs", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "input_id"
    t.index ["group_id"], name: "index_groups_inputs_on_group_id"
    t.index ["input_id"], name: "index_groups_inputs_on_input_id"
  end

  create_table "groups_outputs", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "output_id"
    t.index ["group_id"], name: "index_groups_outputs_on_group_id"
    t.index ["output_id"], name: "index_groups_outputs_on_output_id"
  end

  create_table "icons", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inputs", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.string "switch_mode"
    t.boolean "state"
    t.string "input_type"
    t.integer "io_device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["io_device_id"], name: "index_inputs_on_io_device_id"
  end

  create_table "inputs_outputs", id: false, force: :cascade do |t|
    t.integer "input_id"
    t.integer "output_id"
    t.index ["input_id"], name: "index_inputs_outputs_on_input_id"
    t.index ["output_id"], name: "index_inputs_outputs_on_output_id"
  end

  create_table "io_devices", force: :cascade do |t|
    t.string "name"
    t.string "topic"
    t.string "ip_address"
    t.string "device_type"
    t.integer "tasmota_config_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tasmota_config_id"], name: "index_io_devices_on_tasmota_config_id"
  end

  create_table "network_devices", force: :cascade do |t|
    t.string "ip_address"
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outputs", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.boolean "state"
    t.string "output_type"
    t.integer "io_device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["io_device_id"], name: "index_outputs_on_io_device_id"
  end

  create_table "tasmota_configs", force: :cascade do |t|
    t.string "name"
    t.string "gpio"
    t.string "switch_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rules"
  end

end
