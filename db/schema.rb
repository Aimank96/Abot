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

ActiveRecord::Schema.define(version: 20170724203005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "team_id", null: false
    t.decimal "amount_paid", precision: 8, scale: 2, null: false
    t.integer "payer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "braintree_identifier"
    t.string "payer_first_name"
    t.string "payer_last_name"
    t.string "payer_address"
    t.string "payer_email"
    t.index ["payer_id"], name: "index_subscriptions_on_payer_id", unique: true
    t.index ["team_id"], name: "index_subscriptions_on_team_id", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "slack_id", null: false
    t.string "name", null: false
    t.string "bot_slack_id", null: false
    t.string "bot_access_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "direct_feedbacks_count", default: 0, null: false
    t.integer "channel_feedbacks_count", default: 0, null: false
    t.index ["slack_id"], name: "index_teams_on_slack_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "team_id", null: false
    t.string "slack_id", null: false
    t.index ["slack_id"], name: "index_users_on_slack_id", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

end
