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

ActiveRecord::Schema[7.1].define(version: 2025_06_09_222521) do
  create_table "cards", force: :cascade do |t|
    t.string "suit"
    t.string "card"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stockings", force: :cascade do |t|
    t.integer "card_id", null: false
    t.string "rental_status"
    t.datetime "time_rented_out"
    t.integer "user_id_rented_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_stockings_on_card_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "transaction_type"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "stockings", "cards"
end
