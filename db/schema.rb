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

ActiveRecord::Schema.define(version: 2020_08_06_023926) do

  create_table "categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "group_id"
    t.string "name"
    t.integer "depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.text "description"
    t.index ["group_id"], name: "index_categories_on_group_id"
  end

  create_table "examples", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "ling_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.integer "creator_id"
    t.index ["group_id"], name: "index_examples_on_group_id"
    t.index ["ling_id"], name: "index_examples_on_ling_id"
  end

  create_table "examples_lings_properties", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "example_id"
    t.integer "lings_property_id"
    t.integer "creator_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_examples_lings_properties_on_group_id"
  end

  create_table "forum_groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.boolean "state", default: true
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forums", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "state", default: true
    t.integer "topics_count", default: 0
    t.integer "posts_count", default: 0
    t.integer "position", default: 0
    t.integer "forum_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ling0_name", default: "Ling"
    t.string "ling1_name", default: "Linglet"
    t.string "property_name", default: "Property"
    t.string "category_name", default: "Category"
    t.string "lings_property_name", default: "Value"
    t.string "example_name", default: "Example"
    t.string "examples_lings_property_name", default: "Example Value"
    t.integer "depth_maximum", default: 1
    t.string "privacy", default: "public"
    t.text "example_fields"
    t.text "ling_fields"
    t.string "display_style", default: "table"
  end

  create_table "lings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", collation: "utf8_unicode_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "depth"
    t.integer "parent_id"
    t.integer "group_id"
    t.integer "creator_id"
    t.index ["group_id"], name: "index_lings_on_group_id"
  end

  create_table "lings_properties", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "ling_id"
    t.integer "property_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.integer "creator_id"
    t.string "property_value"
    t.string "sureness"
    t.index ["group_id"], name: "index_lings_properties_on_group_id"
    t.index ["ling_id", "property_id"], name: "index_lings_properties_on_ling_id_and_property_id"
    t.index ["property_value"], name: "index_lings_properties_on_property_value"
  end

  create_table "memberships", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "member_id"
    t.integer "group_id"
    t.string "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.index ["group_id"], name: "index_memberships_on_group_id"
  end

  create_table "memberships_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "membership_id"
    t.integer "role_id"
    t.index ["membership_id", "role_id"], name: "index_memberships_roles_on_membership_id_and_role_id"
  end

  create_table "posts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "body"
    t.integer "forum_id"
    t.integer "topic_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.integer "category_id"
    t.integer "creator_id"
    t.text "description", limit: 16777215
    t.index ["group_id"], name: "index_properties_on_group_id"
  end

  create_table "roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.integer "resource_id"
    t.string "resource_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "searches", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name", null: false
    t.integer "creator_id", null: false
    t.integer "group_id", null: false
    t.text "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "result_groups", limit: 16777215
    t.index ["creator_id", "group_id"], name: "index_searches_on_creator_id_and_group_id"
  end

  create_table "stored_values", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key"
    t.string "value", limit: 10000
    t.integer "storable_id"
    t.string "storable_type"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_stored_values_on_group_id"
  end

  create_table "teams", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.text "information"
    t.integer "primary_author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.integer "hits", default: 0
    t.boolean "sticky", default: false
    t.boolean "locked", default: false
    t.integer "posts_count"
    t.integer "forum_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", collation: "utf8mb4_unicode_ci"
    t.string "access_level"
    t.integer "topics_count", default: 0
    t.integer "posts_count", default: 0
    t.string "website", default: ""
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
