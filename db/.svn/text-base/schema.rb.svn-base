# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 9) do

  create_table "admin_roles", :force => true do |t|
    t.string "name"
  end

  create_table "admin_roles_admin_users", :id => false, :force => true do |t|
    t.integer "admin_role_id"
    t.integer "admin_user_id"
  end

  add_index "admin_roles_admin_users", ["admin_role_id"], :name => "index_admin_roles_admin_users_on_admin_role_id"
  add_index "admin_roles_admin_users", ["admin_user_id"], :name => "index_admin_roles_admin_users_on_admin_user_id"

  create_table "admin_users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

  add_index "admin_users", ["login"], :name => "index_admin_users_on_login", :unique => true

  create_table "passwords", :force => true do |t|
    t.integer  "admin_user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_answers", :force => true do |t|
    t.integer  "question_id"
    t.string   "prompt"
    t.string   "answer_type"
    t.boolean  "archived"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_answers", ["archived"], :name => "index_question_answers_on_archived"
  add_index "question_answers", ["order"], :name => "index_question_answers_on_order"
  add_index "question_answers", ["question_id"], :name => "index_question_answers_on_question_id"

  create_table "question_sets", :force => true do |t|
    t.string   "name"
    t.integer  "survey_id"
    t.boolean  "archived"
    t.text     "instructions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "question_sets", ["archived"], :name => "index_question_sets_on_archived"
  add_index "question_sets", ["name"], :name => "index_question_sets_on_name"
  add_index "question_sets", ["survey_id"], :name => "index_question_sets_on_survey_id"

  create_table "questions", :force => true do |t|
    t.text     "prompt"
    t.integer  "question_set_id"
    t.integer  "parent_question_id"
    t.boolean  "archived"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["archived"], :name => "index_questions_on_archived"
  add_index "questions", ["question_set_id"], :name => "index_questions_on_question_set_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "survey_answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "survey_user_id"
    t.integer  "question_answer_id"
    t.string   "answer_detail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_answers", ["question_answer_id"], :name => "index_survey_answers_on_question_answer_id"
  add_index "survey_answers", ["question_id"], :name => "index_survey_answers_on_question_id"
  add_index "survey_answers", ["survey_user_id"], :name => "index_survey_answers_on_survey_user_id"

  create_table "survey_users", :force => true do |t|
    t.string   "ip_address"
    t.integer  "survey_id"
    t.boolean  "survey_agreed"
    t.boolean  "survey_complete"
    t.integer  "current_question_id"
    t.text     "questions_list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_users", ["ip_address"], :name => "index_survey_users_on_ip_address"
  add_index "survey_users", ["survey_id"], :name => "index_survey_users_on_survey_id"

  create_table "surveys", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.boolean  "archived",      :default => false
    t.integer  "respondents",   :default => 0
    t.text     "agreement"
    t.string   "disagree_link"
    t.text     "thankyou"
    t.integer  "admin_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "surveys", ["archived"], :name => "index_surveys_on_archived"
  add_index "surveys", ["name"], :name => "index_surveys_on_name"
  add_index "surveys", ["path"], :name => "index_surveys_on_path"

end
