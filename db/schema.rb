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

ActiveRecord::Schema.define(version: 2019_09_22_032919) do

  create_table "athletes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "line_id"
    t.string "line_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkins", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "run_id"
    t.float "distance"
    t.datetime "time"
    t.string "type"
    t.string "location"
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["run_id"], name: "index_checkins_on_run_id"
  end

  create_table "courses", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "race_id"
    t.string "title"
    t.float "distance"
    t.datetime "start"
    t.datetime "stop"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "gain"
    t.index ["race_id"], name: "index_courses_on_race_id"
  end

  create_table "direct_responses", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "tag"
    t.string "text"
    t.string "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "msg_type", default: 0
  end

  create_table "line_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "race_id"
    t.string "line_group_id"
    t.string "line_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_line_groups_on_race_id"
  end

  create_table "parameters", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "run_id"
    t.bigint "station_id"
    t.integer "total_minute"
    t.datetime "worldtime"
    t.integer "margin_minute"
    t.string "pace"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "dist"
    t.index ["run_id"], name: "index_plans_on_run_id"
    t.index ["station_id"], name: "index_plans_on_station_id"
  end

  create_table "races", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "runs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "athlete_id"
    t.string "bib"
    t.bigint "course_id"
    t.float "current_dist"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.string "station"
    t.datetime "last_online_call_timestamp"
    t.float "plan_hour"
    t.string "ct_station"
    t.datetime "ct_checkin_time"
    t.float "ct_distance"
    t.index ["athlete_id"], name: "index_runs_on_athlete_id"
    t.index ["course_id"], name: "index_runs_on_course_id"
  end

  create_table "stations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "course_id"
    t.string "code"
    t.string "shortname"
    t.string "name"
    t.float "distance"
    t.datetime "cutoff"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ascent"
    t.integer "descent"
    t.integer "chilling_trail_time_minute"
    t.index ["course_id"], name: "index_stations_on_course_id"
  end

  add_foreign_key "checkins", "runs"
  add_foreign_key "courses", "races"
  add_foreign_key "line_groups", "races"
  add_foreign_key "plans", "runs"
  add_foreign_key "plans", "stations"
  add_foreign_key "runs", "athletes"
  add_foreign_key "runs", "courses"
  add_foreign_key "stations", "courses"
end
