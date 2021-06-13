# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_10_131328) do

  create_table "people", force: :cascade do |t|
    t.string "id_param"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_param"], name: "index_people_on_id_param", unique: true
  end

  create_table "person_birthdates", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "year"
    t.integer "month"
    t.integer "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_person_birthdates_on_person_id", unique: true
  end

  create_table "person_group_belongings", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "person_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_group_id"], name: "index_person_group_belongings_on_person_group_id"
    t.index ["person_id"], name: "index_person_group_belongings_on_person_id", unique: true
  end

  create_table "person_group_relations", id: false, force: :cascade do |t|
    t.integer "person_group_id", null: false
    t.integer "child_person_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_person_group_id"], name: "index_person_group_relations_on_child_person_group_id"
    t.index ["person_group_id", "child_person_group_id"], name: "index_person_group_relations_on_parent_and_child", unique: true
    t.index ["person_group_id"], name: "index_person_group_relations_on_person_group_id"
  end

  create_table "person_groups", force: :cascade do |t|
    t.string "id_param"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_param"], name: "index_person_groups_on_id_param", unique: true
  end

  create_table "person_names", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.string "disp_name", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.string "kana"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_person_names_on_person_id", unique: true
  end

  create_table "person_sexes", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "birth_sex_code", null: false
    t.integer "desired_sex_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_person_sexes_on_person_id", unique: true
  end

  create_table "top_person_groups", id: false, force: :cascade do |t|
    t.integer "person_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_group_id"], name: "index_top_person_groups_on_person_group_id", unique: true
  end

  create_table "user_accessible_top_person_groups", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "top_person_group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "top_person_group_id"], name: "index_user_accessible_top_person_groups_on_user_and_group", unique: true
    t.index ["user_id"], name: "index_user_accessible_top_person_groups_on_user_id"
  end

  create_table "user_person_mappings", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_user_person_mappings_on_person_id"
    t.index ["user_id"], name: "index_user_person_mappings_on_user_id", unique: true
  end

  create_table "user_person_relations", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_user_person_relations_on_person_id"
    t.index ["user_id", "person_id"], name: "index_user_person_relations_on_user_id_and_person_id", unique: true
    t.index ["user_id"], name: "index_user_person_relations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "id_param"
    t.index ["id_param"], name: "index_users_on_id_param", unique: true
  end

  add_foreign_key "person_birthdates", "people"
  add_foreign_key "person_group_belongings", "people"
  add_foreign_key "person_group_belongings", "person_groups"
  add_foreign_key "person_group_relations", "person_groups"
  add_foreign_key "person_group_relations", "person_groups", column: "child_person_group_id"
  add_foreign_key "person_names", "people"
  add_foreign_key "person_sexes", "people"
  add_foreign_key "top_person_groups", "person_groups"
  add_foreign_key "user_accessible_top_person_groups", "top_person_groups", primary_key: "person_group_id"
  add_foreign_key "user_accessible_top_person_groups", "users"
  add_foreign_key "user_person_mappings", "people"
  add_foreign_key "user_person_mappings", "users"
  add_foreign_key "user_person_relations", "people"
  add_foreign_key "user_person_relations", "users"
end
