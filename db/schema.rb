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

ActiveRecord::Schema[7.0].define(version: 2022_02_20_195936) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "menu_assignments", id: false, force: :cascade do |t|
    t.bigint "menu_item_id", null: false
    t.bigint "menu_id", null: false
    t.index ["menu_id", "menu_item_id"], name: "index_menu_assignments_on_menu_id_and_menu_item_id", unique: true
    t.index ["menu_item_id", "menu_id"], name: "index_menu_assignments_on_menu_item_id_and_menu_id", unique: true
  end

  create_table "menu_item_variations", force: :cascade do |t|
    t.bigint "parent_item_id", null: false
    t.bigint "child_item_id", null: false
    t.decimal "price_adjustment", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_item_id"], name: "index_menu_item_variations_on_child_item_id"
    t.index ["parent_item_id"], name: "index_menu_item_variations_on_parent_item_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.text "description"
    t.decimal "price", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "restaurant_id", null: false
    t.index ["restaurant_id", "title"], name: "index_menu_items_on_restaurant_id_and_title", unique: true
    t.index ["restaurant_id"], name: "index_menu_items_on_restaurant_id"
  end

  create_table "menus", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "restaurant_id", null: false
    t.index ["restaurant_id"], name: "index_menus_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "city", null: false
    t.string "country", null: false
    t.string "name", null: false
    t.string "phone_number", null: false
    t.string "postal_code", null: false
    t.string "region", null: false
    t.integer "status", default: 0, null: false
    t.string "street_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "menu_item_variations", "menu_items", column: "child_item_id"
  add_foreign_key "menu_item_variations", "menu_items", column: "parent_item_id"
  add_foreign_key "menu_items", "restaurants"
  add_foreign_key "menus", "restaurants"
end
