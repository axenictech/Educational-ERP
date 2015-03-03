# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20_150_122_072_350_078) do

  create_table 'apply_leaves', force: :cascade do |t|
    t.integer 'employee_id',             limit: 4
    t.integer 'employee_leave_types_id', limit: 4
    t.boolean 'is_half_day',             limit: 1
    t.date 'start_date'
    t.date 'end_date'
    t.string 'reason',                  limit: 255
    t.boolean 'approved',                limit: 1,   default: false
    t.boolean 'viewed_by_manager',       limit: 1,   default: false
    t.string 'manager_remark',          limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'apply_leaves', ['employee_id'], name: 'index_apply_leaves_on_employee_id', using: :btree
  add_index 'apply_leaves', ['employee_leave_types_id'], name: 'index_apply_leaves_on_employee_leave_types_id', using: :btree

  create_table 'archived_employees', force: :cascade do |t|
    t.integer 'employee_category_id',   limit: 4
    t.string 'employee_number',        limit: 255
    t.date 'joining_date'
    t.string 'first_name',             limit: 255
    t.string 'middle_name',            limit: 255
    t.string 'last_name',              limit: 255
    t.boolean 'gender',                 limit: 1
    t.string 'job_title',              limit: 255
    t.integer 'employee_position_id',   limit: 4
    t.integer 'employee_department_id', limit: 4
    t.integer 'reporting_manager_id',   limit: 4
    t.integer 'employee_grade_id',      limit: 4
    t.string 'qualification',          limit: 255
    t.text 'experience_detail',      limit: 65_535
    t.integer 'experience_year',        limit: 4
    t.integer 'experience_month',       limit: 4
    t.boolean 'status',                 limit: 1
    t.string 'status_description',     limit: 255
    t.date 'date_of_birth'
    t.string 'marital_status',         limit: 255
    t.integer 'children_count',         limit: 4
    t.string 'father_name',            limit: 255
    t.string 'mother_name',            limit: 255
    t.string 'husband_name',           limit: 255
    t.string 'blood_group',            limit: 255
    t.integer 'nationality_id',         limit: 4
    t.string 'home_address_line1',     limit: 255
    t.string 'home_address_line2',     limit: 255
    t.string 'home_city',              limit: 255
    t.string 'home_state',             limit: 255
    t.integer 'home_country_id',        limit: 4
    t.string 'home_pin_code',          limit: 255
    t.string 'office_address_line1',   limit: 255
    t.string 'office_address_line2',   limit: 255
    t.string 'office_city',            limit: 255
    t.string 'office_state',           limit: 255
    t.integer 'office_country_id',      limit: 4
    t.string 'office_pin_code',        limit: 255
    t.string 'office_phone1',          limit: 255
    t.string 'office_phone2',          limit: 255
    t.string 'mobile_phone',           limit: 255
    t.string 'home_phone',             limit: 255
    t.string 'email',                  limit: 255
    t.string 'fax',                    limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer 'country_id',             limit: 4
    t.integer 'former_id',              limit: 4
    t.string 'image_file_name',        limit: 255
    t.string 'image_content_type',     limit: 255
    t.integer 'image_file_size',        limit: 4
    t.datetime 'image_updated_at'
  end

  add_index 'archived_employees', ['country_id'], name: 'index_archived_employees_on_country_id', using: :btree
  add_index 'archived_employees', ['employee_department_id'], name: 'index_archived_employees_on_employee_department_id', using: :btree
  add_index 'archived_employees', ['employee_grade_id'], name: 'index_archived_employees_on_employee_grade_id', using: :btree
  add_index 'archived_employees', ['employee_position_id'], name: 'index_archived_employees_on_employee_position_id', using: :btree

  create_table 'archived_students', force: :cascade do |t|
    t.integer 'student_id',         limit: 4
    t.string 'admission_no',       limit: 255
    t.string 'class_roll_no',      limit: 255
    t.date 'admission_date'
    t.string 'first_name',         limit: 255
    t.string 'middle_name',        limit: 255
    t.string 'last_name',          limit: 255
    t.integer 'batch_id',           limit: 4
    t.date 'date_of_birth'
    t.string 'gender',             limit: 255
    t.string 'blood_group',        limit: 255
    t.string 'birth_place',        limit: 255
    t.integer 'nationality_id',     limit: 4
    t.string 'language',           limit: 255
    t.string 'religion',           limit: 255
    t.integer 'category_id',        limit: 4
    t.string 'address_line1',      limit: 255
    t.string 'address_line2',      limit: 255
    t.string 'city',               limit: 255
    t.string 'state',              limit: 255
    t.string 'pin_code',           limit: 255
    t.integer 'country_id',         limit: 4
    t.string 'phone1',             limit: 255
    t.string 'phone2',             limit: 255
    t.string 'email',              limit: 255
    t.integer 'immediate_contact',  limit: 4
    t.boolean 'is_sms_enabled',     limit: 1,   default: true
    t.string 'status_description', limit: 255
    t.boolean 'is_active',          limit: 1,   default: true
    t.boolean 'is_deleted',         limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'image_file_name',    limit: 255
    t.string 'image_content_type', limit: 255
    t.integer 'image_file_size',    limit: 4
    t.datetime 'image_updated_at'
  end

  add_index 'archived_students', ['batch_id'], name: 'index_archived_students_on_batch_id', using: :btree
  add_index 'archived_students', ['category_id'], name: 'index_archived_students_on_category_id', using: :btree

  create_table 'assets', force: :cascade do |t|
    t.string 'title',       limit: 255
    t.text 'description', limit: 65_535
    t.decimal 'amount',                    precision: 10
    t.boolean 'is_inactive', limit: 1,                    default: false
    t.boolean 'is_deleted',  limit: 1,                    default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'attendences', force: :cascade do |t|
    t.integer 'student_id',          limit: 4
    t.integer 'time_table_entry_id', limit: 4
    t.boolean 'forenoon',            limit: 1,   default: false
    t.boolean 'afternoon',           limit: 1,   default: false
    t.string 'reason',              limit: 255
    t.date 'month_date'
    t.integer 'batch_id',            limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'attendences', ['batch_id'], name: 'index_attendences_on_batch_id', using: :btree
  add_index 'attendences', ['student_id'], name: 'index_attendences_on_student_id', using: :btree
  add_index 'attendences', ['time_table_entry_id'], name: 'index_attendences_on_time_table_entry_id', using: :btree

  create_table 'bank_fields', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.boolean 'status',     limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'batch_events', force: :cascade do |t|
    t.integer 'batch_id',   limit: 4
    t.integer 'event_id',   limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'batch_events', ['batch_id'], name: 'index_batch_events_on_batch_id', using: :btree
  add_index 'batch_events', ['event_id'], name: 'index_batch_events_on_event_id', using: :btree

  create_table 'batch_fee_collection_discounts', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'batch_groups', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.integer 'course_id',  limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'batch_groups', ['course_id'], name: 'index_batch_groups_on_course_id', using: :btree

  create_table 'batches', force: :cascade do |t|
    t.string 'name',        limit: 255
    t.integer 'course_id',   limit: 4
    t.string 'employee_id', limit: 255
    t.datetime 'start_date'
    t.datetime 'end_date'
    t.boolean 'is_active',   limit: 1,   default: true
    t.boolean 'is_deleted',  limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'batches', ['course_id'], name: 'index_batches_on_course_id', using: :btree

  create_table 'batches_finance_fee_categories', force: :cascade do |t|
    t.integer 'finance_fee_category_id', limit: 4
    t.integer 'batch_id',                limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'batches_finance_fee_categories', ['batch_id'], name: 'index_batches_finance_fee_categories_on_batch_id', using: :btree
  add_index 'batches_finance_fee_categories', ['finance_fee_category_id'], name: 'index_batches_finance_fee_categories_on_finance_fee_category_id', using: :btree

  create_table 'batches_online_exams', force: :cascade do |t|
    t.integer 'online_exam_id', limit: 4
    t.integer 'batch_id',       limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'batches_online_exams', ['batch_id'], name: 'index_batches_online_exams_on_batch_id', using: :btree
  add_index 'batches_online_exams', ['online_exam_id'], name: 'index_batches_online_exams_on_online_exam_id', using: :btree

  create_table 'categories', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'class_designations', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.decimal 'cgpa',                   precision: 10
    t.decimal 'marks',                  precision: 10
    t.integer 'course_id',  limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'class_designations', ['course_id'], name: 'index_class_designations_on_course_id', using: :btree

  create_table 'class_timings', force: :cascade do |t|
    t.integer 'batch_id',   limit: 4
    t.string 'name',       limit: 255
    t.time 'start_time'
    t.time 'end_time'
    t.boolean 'is_break',   limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'class_timings', ['batch_id'], name: 'index_class_timings_on_batch_id', using: :btree

  create_table 'comments', force: :cascade do |t|
    t.text 'statement',   limit: 65_535
    t.integer 'newscast_id', limit: 4
    t.integer 'user_id',     limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'comments', ['newscast_id'], name: 'index_comments_on_newscast_id', using: :btree
  add_index 'comments', ['user_id'], name: 'index_comments_on_user_id', using: :btree

  create_table 'companies', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.string 'criteria',   limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'countries', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'courses', force: :cascade do |t|
    t.string 'course_name',  limit: 255
    t.string 'code',         limit: 255
    t.string 'section_name', limit: 255
    t.string 'grading_type', limit: 255
    t.boolean 'is_deleted',   limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'elective_groups', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.integer 'batch_id',   limit: 4
    t.boolean 'is_deleted', limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'elective_groups', ['batch_id'], name: 'index_elective_groups_on_batch_id', using: :btree

  create_table 'employee_attendances', force: :cascade do |t|
    t.date 'attendance_date'
    t.integer 'employee_id',            limit: 4
    t.integer 'employee_leave_type_id', limit: 4
    t.string 'reason',                 limit: 255
    t.boolean 'is_half_day',            limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'employee_attendances', ['employee_id'], name: 'index_employee_attendances_on_employee_id', using: :btree
  add_index 'employee_attendances', ['employee_leave_type_id'], name: 'index_employee_attendances_on_employee_leave_type_id', using: :btree

  create_table 'employee_bank_details', force: :cascade do |t|
    t.integer 'employee_id',   limit: 4
    t.integer 'bank_field_id', limit: 4
    t.string 'bank_info',     limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'employee_bank_details', ['bank_field_id'], name: 'index_employee_bank_details_on_bank_field_id', using: :btree
  add_index 'employee_bank_details', ['employee_id'], name: 'index_employee_bank_details_on_employee_id', using: :btree

  create_table 'employee_categories', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.string 'prefix',     limit: 255
    t.boolean 'status',     limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'employee_department_events', force: :cascade do |t|
    t.integer 'event_id',               limit: 4
    t.integer 'employee_department_id', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'employee_department_events', ['employee_department_id'], name: 'index_employee_department_events_on_employee_department_id', using: :btree
  add_index 'employee_department_events', ['event_id'], name: 'index_employee_department_events_on_event_id', using: :btree

  create_table 'employee_departments', force: :cascade do |t|
    t.string 'code',       limit: 255
    t.string 'name',       limit: 255
    t.boolean 'status',     limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'employee_grades', force: :cascade do |t|
    t.string 'name',           limit: 255
    t.integer 'priority',       limit: 4
    t.boolean 'status',         limit: 1
    t.integer 'max_hours_day',  limit: 4
    t.integer 'max_hours_week', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'employee_leave_types', force: :cascade do |t|
    t.string 'name',                 limit: 255
    t.string 'code',                 limit: 255
    t.boolean 'status',               limit: 1
    t.string 'max_leave_count',      limit: 255
    t.boolean 'enable_carry_forward', limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'employee_leaves', force: :cascade do |t|
    t.integer 'employee_id',            limit: 4
    t.integer 'employee_leave_type_id', limit: 4
    t.decimal 'leave_count',                      precision: 10
    t.decimal 'leave_taken',                      precision: 10, scale: 2
    t.date 'reset_date'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'employee_leaves', ['employee_id'], name: 'index_employee_leaves_on_employee_id', using: :btree
  add_index 'employee_leaves', ['employee_leave_type_id'], name: 'index_employee_leaves_on_employee_leave_type_id', using: :btree

  create_table 'employee_positions', force: :cascade do |t|
    t.string 'name',                 limit: 255
    t.integer 'employee_category_id', limit: 4
    t.boolean 'status',               limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'employee_positions', ['employee_category_id'], name: 'index_employee_positions_on_employee_category_id', using: :btree

  create_table 'employee_salary_structures', force: :cascade do |t|
    t.integer 'employee_id',         limit: 4
    t.integer 'payroll_category_id', limit: 4
    t.string 'amount',              limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'employee_salary_structures', ['employee_id'], name: 'index_employee_salary_structures_on_employee_id', using: :btree
  add_index 'employee_salary_structures', ['payroll_category_id'], name: 'index_employee_salary_structures_on_payroll_category_id', using: :btree

  create_table 'employee_salery_structures', force: :cascade do |t|
    t.integer 'employee_id',         limit: 4
    t.integer 'payroll_category_id', limit: 4
    t.string 'amount',              limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.date 'salary_date'
  end

  add_index 'employee_salery_structures', ['employee_id'], name: 'index_employee_salery_structures_on_employee_id', using: :btree
  add_index 'employee_salery_structures', ['payroll_category_id'], name: 'index_employee_salery_structures_on_payroll_category_id', using: :btree

  create_table 'employee_subjects', force: :cascade do |t|
    t.integer 'employee_id', limit: 4
    t.integer 'subject_id',  limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'employee_subjects', ['employee_id'], name: 'index_employee_subjects_on_employee_id', using: :btree
  add_index 'employee_subjects', ['subject_id'], name: 'index_employee_subjects_on_subject_id', using: :btree

  create_table 'employees', force: :cascade do |t|
    t.integer 'employee_category_id',   limit: 4
    t.string 'employee_number',        limit: 255
    t.date 'joining_date'
    t.binary 'first_name',             limit: 65_535
    t.string 'middle_name',            limit: 255
    t.string 'last_name',              limit: 255
    t.string 'gender',                 limit: 255
    t.string 'job_title',              limit: 255
    t.integer 'employee_position_id',   limit: 4
    t.integer 'employee_department_id', limit: 4
    t.integer 'reporting_manager_id',   limit: 4
    t.integer 'employee_grade_id',      limit: 4
    t.string 'qualification',          limit: 255
    t.text 'experience_detail',      limit: 65_535
    t.integer 'experience_year',        limit: 4
    t.integer 'experience_month',       limit: 4
    t.boolean 'status',                 limit: 1
    t.string 'status_description',     limit: 255
    t.date 'date_of_birth'
    t.string 'marital_status',         limit: 255
    t.integer 'children_count',         limit: 4
    t.string 'father_name',            limit: 255
    t.string 'mother_name',            limit: 255
    t.string 'husband_name',           limit: 255
    t.string 'blood_group',            limit: 255
    t.integer 'country_id',             limit: 4
    t.string 'home_address_line1',     limit: 255
    t.string 'home_address_line2',     limit: 255
    t.string 'home_city',              limit: 255
    t.string 'home_state',             limit: 255
    t.integer 'home_country_id',        limit: 4
    t.string 'home_pin_code',          limit: 255
    t.string 'office_address_line1',   limit: 255
    t.string 'office_address_line2',   limit: 255
    t.string 'office_city',            limit: 255
    t.string 'office_state',           limit: 255
    t.integer 'office_country_id',      limit: 4
    t.string 'office_pin_code',        limit: 255
    t.string 'office_phone1',          limit: 255
    t.string 'office_phone2',          limit: 255
    t.string 'mobile_phone',           limit: 255
    t.string 'home_phone',             limit: 255
    t.string 'email',                  limit: 255
    t.string 'fax',                    limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'image_file_name',        limit: 255
    t.string 'image_content_type',     limit: 255
    t.integer 'image_file_size',        limit: 4
    t.datetime 'image_updated_at'
  end

  add_index 'employees', ['country_id'], name: 'index_employees_on_country_id', using: :btree
  add_index 'employees', ['employee_category_id'], name: 'index_employees_on_employee_category_id', using: :btree
  add_index 'employees', ['employee_department_id'], name: 'index_employees_on_employee_department_id', using: :btree
  add_index 'employees', ['employee_grade_id'], name: 'index_employees_on_employee_grade_id', using: :btree
  add_index 'employees', ['employee_position_id'], name: 'index_employees_on_employee_position_id', using: :btree

  create_table 'events', force: :cascade do |t|
    t.string 'title',       limit: 255
    t.string 'description', limit: 255
    t.datetime 'start_date'
    t.datetime 'end_date'
    t.boolean 'is_common',   limit: 1,   default: false
    t.boolean 'is_holiday',  limit: 1,   default: false
    t.boolean 'is_exam',     limit: 1,   default: false
    t.boolean 'is_due',      limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'exam_groups', force: :cascade do |t|
    t.string 'name',             limit: 255
    t.integer 'batch_id',         limit: 4
    t.string 'exam_type',        limit: 255
    t.boolean 'is_published',     limit: 1,   default: false
    t.boolean 'result_published', limit: 1,   default: false
    t.date 'exam_date'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'exam_groups', ['batch_id'], name: 'index_exam_groups_on_batch_id', using: :btree

  create_table 'exam_scores', force: :cascade do |t|
    t.integer 'student_id',       limit: 4
    t.integer 'exam_id',          limit: 4
    t.decimal 'marks',                        precision: 10
    t.integer 'grading_level_id', limit: 4
    t.string 'remarks',          limit: 255
    t.boolean 'is_failed',        limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'exam_scores', ['exam_id'], name: 'index_exam_scores_on_exam_id', using: :btree
  add_index 'exam_scores', ['grading_level_id'], name: 'index_exam_scores_on_grading_level_id', using: :btree
  add_index 'exam_scores', ['student_id'], name: 'index_exam_scores_on_student_id', using: :btree

  create_table 'exams', force: :cascade do |t|
    t.integer 'exam_group_id',    limit: 4
    t.integer 'subject_id',       limit: 4
    t.string 'start_time',       limit: 255
    t.string 'end_time',         limit: 255
    t.integer 'maximum_marks',    limit: 4
    t.integer 'minimum_marks',    limit: 4
    t.integer 'grading_level_id', limit: 4
    t.integer 'weightage',        limit: 4,   default: 0
    t.integer 'event_id',         limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'exams', ['event_id'], name: 'index_exams_on_event_id', using: :btree
  add_index 'exams', ['exam_group_id'], name: 'index_exams_on_exam_group_id', using: :btree
  add_index 'exams', ['grading_level_id'], name: 'index_exams_on_grading_level_id', using: :btree
  add_index 'exams', ['subject_id'], name: 'index_exams_on_subject_id', using: :btree

  create_table 'fee_collection_discounts', force: :cascade do |t|
    t.string 'type',                      limit: 255
    t.string 'name',                      limit: 255
    t.decimal 'discount',                              precision: 10
    t.integer 'finance_fee_collection_id', limit: 4
    t.integer 'category_id',               limit: 4
    t.string 'admission_no',              limit: 255
    t.integer 'batch_id',                  limit: 4
    t.boolean 'is_deleted',                limit: 1,                  default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'fee_collection_discounts', ['batch_id'], name: 'index_fee_collection_discounts_on_batch_id', using: :btree
  add_index 'fee_collection_discounts', ['category_id'], name: 'index_fee_collection_discounts_on_category_id', using: :btree
  add_index 'fee_collection_discounts', ['finance_fee_collection_id'], name: 'index_fee_collection_discounts_on_finance_fee_collection_id', using: :btree

  create_table 'fee_collection_discounts_students', force: :cascade do |t|
    t.integer 'student_id',                                  limit: 4
    t.integer 'fee_collection_discount_id',                  limit: 4
    t.integer "[{:index=>true, :name=>\"discount_id\"}]_id", limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'fee_collection_discounts_students', ['student_id'], name: 'index_fee_collection_discounts_students_on_student_id', using: :btree

  create_table 'fee_collection_particulars', force: :cascade do |t|
    t.string 'name',                      limit: 255
    t.text 'description',               limit: 65_535
    t.decimal 'amount',                                  precision: 10
    t.integer 'finance_fee_collection_id', limit: 4
    t.integer 'category_id',               limit: 4
    t.string 'admission_no',              limit: 255
    t.integer 'batch_id',                  limit: 4
    t.boolean 'is_deleted',                limit: 1,                    default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'fee_collection_particulars', ['batch_id'], name: 'index_fee_collection_particulars_on_batch_id', using: :btree
  add_index 'fee_collection_particulars', ['category_id'], name: 'index_fee_collection_particulars_on_category_id', using: :btree
  add_index 'fee_collection_particulars', ['finance_fee_collection_id'], name: 'index_fee_collection_particulars_on_finance_fee_collection_id', using: :btree

  create_table 'fee_collection_particulars_students', force: :cascade do |t|
    t.integer 'student_id',                                    limit: 4
    t.integer 'fee_collection_particular_id',                  limit: 4
    t.integer "[{:index=>true, :name=>\"particular_id\"}]_id", limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'fee_collection_particulars_students', ['student_id'], name: 'index_fee_collection_particulars_students_on_student_id', using: :btree

  create_table 'fee_discounts', force: :cascade do |t|
    t.string 'type',                    limit: 255
    t.string 'name',                    limit: 255
    t.decimal 'discount',                            precision: 10
    t.integer 'finance_fee_category_id', limit: 4
    t.integer 'category_id',             limit: 4
    t.string 'admission_no',            limit: 255
    t.integer 'batch_id',                limit: 4
    t.boolean 'is_deleted',              limit: 1,                  default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'fee_discounts', ['batch_id'], name: 'index_fee_discounts_on_batch_id', using: :btree
  add_index 'fee_discounts', ['category_id'], name: 'index_fee_discounts_on_category_id', using: :btree
  add_index 'fee_discounts', ['finance_fee_category_id'], name: 'index_fee_discounts_on_finance_fee_category_id', using: :btree

  create_table 'finance_donations', force: :cascade do |t|
    t.string 'donor',                  limit: 255
    t.string 'description',            limit: 255
    t.decimal 'amount',                             precision: 10
    t.date 'transaction_date'
    t.integer 'finance_transaction_id', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'finance_donations', ['finance_transaction_id'], name: 'index_finance_donations_on_finance_transaction_id', using: :btree

  create_table 'finance_fee_categories', force: :cascade do |t|
    t.string 'name',        limit: 255
    t.text 'description', limit: 65_535
    t.boolean 'is_deleted',  limit: 1,     default: false
    t.boolean 'is_master',   limit: 1,     default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'finance_fee_collections', force: :cascade do |t|
    t.string 'name',                    limit: 255
    t.date 'start_date'
    t.date 'end_date'
    t.date 'due_date'
    t.integer 'finance_fee_category_id', limit: 4
    t.integer 'batch_id',                limit: 4
    t.boolean 'is_deleted',              limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'finance_fee_collections', ['batch_id'], name: 'index_finance_fee_collections_on_batch_id', using: :btree
  add_index 'finance_fee_collections', ['finance_fee_category_id'], name: 'index_finance_fee_collections_on_finance_fee_category_id', using: :btree

  create_table 'finance_fee_particulars', force: :cascade do |t|
    t.string 'name',                    limit: 255
    t.text 'description',             limit: 65_535
    t.decimal 'amount',                                precision: 10
    t.integer 'finance_fee_category_id', limit: 4
    t.integer 'category_id',             limit: 4
    t.string 'admission_no',            limit: 255
    t.integer 'batch_id',                limit: 4
    t.boolean 'is_deleted',              limit: 1,                    default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'finance_fee_particulars', ['batch_id'], name: 'index_finance_fee_particulars_on_batch_id', using: :btree
  add_index 'finance_fee_particulars', ['category_id'], name: 'index_finance_fee_particulars_on_category_id', using: :btree
  add_index 'finance_fee_particulars', ['finance_fee_category_id'], name: 'index_finance_fee_particulars_on_finance_fee_category_id', using: :btree

  create_table 'finance_fee_structure_elements', force: :cascade do |t|
    t.decimal 'amount',                        precision: 10
    t.string 'label',             limit: 255
    t.integer 'batch_id',          limit: 4
    t.integer 'category_id',       limit: 4
    t.integer 'student_id',        limit: 4
    t.integer 'guardian_id',       limit: 4
    t.integer 'fee_collection_id', limit: 4
    t.boolean 'is_deleted',        limit: 1,                  default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'finance_fee_structure_elements', ['batch_id'], name: 'index_finance_fee_structure_elements_on_batch_id', using: :btree
  add_index 'finance_fee_structure_elements', ['category_id'], name: 'index_finance_fee_structure_elements_on_category_id', using: :btree
  add_index 'finance_fee_structure_elements', ['fee_collection_id'], name: 'index_finance_fee_structure_elements_on_fee_collection_id', using: :btree
  add_index 'finance_fee_structure_elements', ['guardian_id'], name: 'index_finance_fee_structure_elements_on_guardian_id', using: :btree
  add_index 'finance_fee_structure_elements', ['student_id'], name: 'index_finance_fee_structure_elements_on_student_id', using: :btree

  create_table 'finance_fees', force: :cascade do |t|
    t.integer 'finance_fee_collection_id', limit: 4
    t.integer 'student_id',                limit: 4
    t.string 'receipt_no',                limit: 255
    t.boolean 'is_paid',                   limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'finance_fees', ['finance_fee_collection_id'], name: 'index_finance_fees_on_finance_fee_collection_id', using: :btree
  add_index 'finance_fees', ['student_id'], name: 'index_finance_fees_on_student_id', using: :btree

  create_table 'finance_fines', force: :cascade do |t|
    t.integer 'finance_fee_id', limit: 4
    t.date 'fine_date'
    t.decimal 'fine',                     precision: 10
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'finance_fines', ['finance_fee_id'], name: 'index_finance_fines_on_finance_fee_id', using: :btree

  create_table 'finance_transaction_categories', force: :cascade do |t|
    t.string 'name',        limit: 255
    t.string 'description', limit: 255
    t.boolean 'is_income',   limit: 1
    t.boolean 'is_deleted',  limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'finance_transaction_triggers', force: :cascade do |t|
    t.string 'title',       limit: 255
    t.string 'description', limit: 255
    t.decimal 'percentage',              precision: 10
    t.integer 'category_id', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'finance_transaction_triggers', ['category_id'], name: 'index_finance_transaction_triggers_on_category_id', using: :btree

  create_table 'finance_transactions', force: :cascade do |t|
    t.string 'title',                           limit: 255
    t.string 'description',                     limit: 255
    t.decimal 'amount',                                      precision: 10
    t.date 'transaction_date'
    t.boolean 'fine_included',                   limit: 1,                  default: false
    t.integer 'student_id',                      limit: 4
    t.integer 'finance_fee_id',                  limit: 4
    t.integer 'finance_transaction_category_id', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'finance_transactions', ['finance_fee_id'], name: 'index_finance_transactions_on_finance_fee_id', using: :btree
  add_index 'finance_transactions', ['finance_transaction_category_id'], name: 'index_finance_transactions_on_finance_transaction_category_id', using: :btree
  add_index 'finance_transactions', ['student_id'], name: 'index_finance_transactions_on_student_id', using: :btree

  create_table 'general_settings', force: :cascade do |t|
    t.string 'school_or_college_name',            limit: 255
    t.string 'school_or_college_address',         limit: 255
    t.string 'school_or_college_phone_no',        limit: 255
    t.date 'finance_start_year_date'
    t.date 'finance_end_year_date'
    t.string 'language',                          limit: 255
    t.string 'time_zone',                         limit: 255
    t.string 'country',                           limit: 255
    t.string 'include_grading_system',            limit: 255
    t.integer 'addmission_number_auto_increament', limit: 4
    t.integer 'employee_number_auto_increament',   limit: 4
    t.string 'enable_news_comment_moderation',    limit: 255
    t.string 'image_file_name',                   limit: 255
    t.string 'image_content_type',                limit: 255
    t.integer 'image_file_size',                   limit: 4
    t.datetime 'image_updated_at'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'grading_levels', force: :cascade do |t|
    t.string 'name',        limit: 255
    t.integer 'batch_id',    limit: 4
    t.integer 'min_score',   limit: 4
    t.string 'description', limit: 255
    t.integer 'order',       limit: 4
    t.boolean 'is_deleted',  limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'grading_levels', ['batch_id'], name: 'index_grading_levels_on_batch_id', using: :btree

  create_table 'group_batches', force: :cascade do |t|
    t.integer 'batch_group_id', limit: 4
    t.integer 'batch_id',       limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'group_batches', ['batch_group_id'], name: 'index_group_batches_on_batch_group_id', using: :btree
  add_index 'group_batches', ['batch_id'], name: 'index_group_batches_on_batch_id', using: :btree

  create_table 'grouped_exam_reports', force: :cascade do |t|
    t.integer 'batch_id',      limit: 4
    t.integer 'student_id',    limit: 4
    t.integer 'exam_group_id', limit: 4
    t.decimal 'marks',                     precision: 10
    t.string 'score_type',    limit: 255
    t.integer 'subject_id',    limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'grouped_exam_reports', ['batch_id'], name: 'index_grouped_exam_reports_on_batch_id', using: :btree
  add_index 'grouped_exam_reports', ['exam_group_id'], name: 'index_grouped_exam_reports_on_exam_group_id', using: :btree
  add_index 'grouped_exam_reports', ['student_id'], name: 'index_grouped_exam_reports_on_student_id', using: :btree
  add_index 'grouped_exam_reports', ['subject_id'], name: 'index_grouped_exam_reports_on_subject_id', using: :btree

  create_table 'guardians', force: :cascade do |t|
    t.integer 'student_id',           limit: 4
    t.string 'first_name',           limit: 255
    t.string 'last_name',            limit: 255
    t.string 'relation',             limit: 255
    t.string 'email',                limit: 255
    t.string 'office_phone1',        limit: 255
    t.string 'office_phone2',        limit: 255
    t.string 'mobile_phone',         limit: 255
    t.string 'office_address_line1', limit: 255
    t.string 'office_address_line2', limit: 255
    t.string 'city',                 limit: 255
    t.string 'state',                limit: 255
    t.integer 'country_id',           limit: 4
    t.date 'dob'
    t.string 'occupation',           limit: 255
    t.string 'income',               limit: 255
    t.string 'education',            limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'guardians', ['country_id'], name: 'index_guardians_on_country_id', using: :btree
  add_index 'guardians', ['student_id'], name: 'index_guardians_on_student_id', using: :btree

  create_table 'individual_payslip_categories', force: :cascade do |t|
    t.integer 'employee_id',         limit: 4
    t.date 'salary_date'
    t.string 'name',                limit: 255
    t.string 'amount',              limit: 255
    t.boolean 'is_deduction',        limit: 1
    t.boolean 'include_every_month', limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'individual_payslip_categories', ['employee_id'], name: 'index_individual_payslip_categories_on_employee_id', using: :btree

  create_table 'languages', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'liabilities', force: :cascade do |t|
    t.string 'title',       limit: 255
    t.text 'description', limit: 65_535
    t.decimal 'amount',                    precision: 10
    t.boolean 'is_solved',   limit: 1,                    default: false
    t.boolean 'is_deleted',  limit: 1,                    default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'monthly_payslips', force: :cascade do |t|
    t.date 'salary_date'
    t.integer 'employee_id',         limit: 4
    t.integer 'payroll_category_id', limit: 4
    t.string 'amount',              limit: 255
    t.boolean 'is_approved',         limit: 1,   default: false, null: false
    t.integer 'approver_id',         limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'monthly_payslips', ['approver_id'], name: 'index_monthly_payslips_on_approver_id', using: :btree
  add_index 'monthly_payslips', ['employee_id'], name: 'index_monthly_payslips_on_employee_id', using: :btree
  add_index 'monthly_payslips', ['payroll_category_id'], name: 'index_monthly_payslips_on_payroll_category_id', using: :btree

  create_table 'newscasts', force: :cascade do |t|
    t.string 'title',      limit: 255
    t.text 'content',    limit: 65_535
    t.integer 'user_id',    limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'newscasts', ['user_id'], name: 'index_newscasts_on_user_id', using: :btree

  create_table 'online_exam_questions', force: :cascade do |t|
    t.integer 'online_exam_id', limit: 4
    t.string 'question',       limit: 255
    t.integer 'marks',          limit: 4
    t.integer 'is_answer',      limit: 4
    t.string 'option_group',   limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'online_exam_questions', ['online_exam_id'], name: 'index_online_exam_questions_on_online_exam_id', using: :btree

  create_table 'online_exams', force: :cascade do |t|
    t.string 'name',                limit: 255
    t.datetime 'start_date'
    t.datetime 'end_date'
    t.time 'maximum_time'
    t.decimal 'percentage',                      precision: 10
    t.integer 'option_per_question', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'options', force: :cascade do |t|
    t.string 'option',               limit: 255
    t.boolean 'is_answer',            limit: 1
    t.integer 'question_database_id', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'options', ['question_database_id'], name: 'index_options_on_question_database_id', using: :btree

  create_table 'payroll_categories', force: :cascade do |t|
    t.string 'name',                limit: 255
    t.float 'percentage',          limit: 24
    t.integer 'payroll_category_id', limit: 4
    t.boolean 'is_deduction',        limit: 1
    t.boolean 'status',              limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'payroll_categories', ['payroll_category_id'], name: 'index_payroll_categories_on_payroll_category_id', using: :btree

  create_table 'placement_exams', force: :cascade do |t|
    t.string 'question_count', limit: 255
    t.time 'timeperiod'
    t.date 'start_date'
    t.date 'end_date'
    t.integer 'company_id',     limit: 4
  end

  add_index 'placement_exams', ['company_id'], name: 'index_placement_exams_on_company_id', using: :btree

  create_table 'placement_news', force: :cascade do |t|
    t.string 'title',      limit: 255
    t.string 'content',    limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.boolean 'islink',     limit: 1
  end

  create_table 'privilege_tags', force: :cascade do |t|
    t.string 'name_tag',   limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'privilege_users', force: :cascade do |t|
    t.integer 'privilege_id',     limit: 4
    t.integer 'user_id',          limit: 4
    t.integer 'privilege_tag_id', limit: 4
    t.datetime 'created_at',                 null: false
    t.datetime 'updated_at',                 null: false
  end

  add_index 'privilege_users', ['privilege_id'], name: 'index_privilege_users_on_privilege_id', using: :btree
  add_index 'privilege_users', ['privilege_tag_id'], name: 'index_privilege_users_on_privilege_tag_id', using: :btree
  add_index 'privilege_users', ['user_id'], name: 'index_privilege_users_on_user_id', using: :btree

  create_table 'privileges', force: :cascade do |t|
    t.string 'name',             limit: 255
    t.integer 'privilege_tag_id', limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'privileges', ['privilege_tag_id'], name: 'index_privileges_on_privilege_tag_id', using: :btree

  create_table 'question_databases', force: :cascade do |t|
    t.integer 'question_type_id', limit: 4
    t.string 'question',         limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer 'no_of_option',     limit: 4
  end

  add_index 'question_databases', ['question_type_id'], name: 'index_question_databases_on_question_type_id', using: :btree

  create_table 'question_types', force: :cascade do |t|
    t.string 'que_type',   limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'qusetion_types', force: :cascade do |t|
    t.string 'que_type',   limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'qusetions', force: :cascade do |t|
    t.string 'question',         limit: 255
    t.integer 'question_type_id', limit: 4
    t.integer 'question_count',   limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'qusetions', ['question_type_id'], name: 'index_qusetions_on_question_type_id', using: :btree

  create_table 'ranking_levels', force: :cascade do |t|
    t.string 'name',               limit: 255
    t.decimal 'gpa',                            precision: 10
    t.decimal 'marks',                          precision: 10
    t.integer 'subject_count',      limit: 4
    t.integer 'prioriy',            limit: 4
    t.boolean 'full_course',        limit: 1
    t.integer 'course_id',          limit: 4
    t.string 'subject_limit_type', limit: 255
    t.string 'marks_limit_type',   limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'ranking_levels', ['course_id'], name: 'index_ranking_levels_on_course_id', using: :btree

  create_table 'results', force: :cascade do |t|
    t.string 'name',       limit: 255
    t.float 'percentage', limit: 24
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'student_answer_sheets', force: :cascade do |t|
    t.integer 'student_exams_id',      limit: 4
    t.integer 'question_databases_id', limit: 4
    t.integer 'options_id',            limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'student_answer_sheets', ['options_id'], name: 'index_student_answer_sheets_on_options_id', using: :btree
  add_index 'student_answer_sheets', ['question_databases_id'], name: 'index_student_answer_sheets_on_question_databases_id', using: :btree
  add_index 'student_answer_sheets', ['student_exams_id'], name: 'index_student_answer_sheets_on_student_exams_id', using: :btree

  create_table 'student_category_fee_collection_discounts', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'student_category_fee_discounts', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'student_exams', force: :cascade do |t|
    t.integer 'placement_exams_id', limit: 4
    t.integer 'students_id',        limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'student_exams', ['placement_exams_id'], name: 'index_student_exams_on_placement_exams_id', using: :btree
  add_index 'student_exams', ['students_id'], name: 'index_student_exams_on_students_id', using: :btree

  create_table 'student_fee_collection_discounts', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'student_fee_discounts', force: :cascade do |t|
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'student_informations', force: :cascade do |t|
    t.string 'year',       limit: 255
    t.decimal 'marks',                  precision: 10
    t.integer 'student_id', limit: 4
    t.integer 'batch_id',   limit: 4
    t.datetime 'created_at',                            null: false
    t.datetime 'updated_at',                            null: false
  end

  add_index 'student_informations', ['batch_id'], name: 'index_student_informations_on_batch_id', using: :btree
  add_index 'student_informations', ['student_id'], name: 'index_student_informations_on_student_id', using: :btree

  create_table 'student_logs', force: :cascade do |t|
    t.decimal 'mark',                    precision: 10
    t.integer 'maximum_marks', limit: 4
    t.integer 'student_id',    limit: 4
    t.integer 'subject_id',    limit: 4
    t.integer 'exam_group_id', limit: 4
    t.integer 'batch_id',      limit: 4
    t.datetime 'created_at',                             null: false
    t.datetime 'updated_at',                             null: false
  end

  add_index 'student_logs', ['batch_id'], name: 'index_student_logs_on_batch_id', using: :btree
  add_index 'student_logs', ['exam_group_id'], name: 'index_student_logs_on_exam_group_id', using: :btree
  add_index 'student_logs', ['student_id'], name: 'index_student_logs_on_student_id', using: :btree
  add_index 'student_logs', ['subject_id'], name: 'index_student_logs_on_subject_id', using: :btree

  create_table 'student_previous_data', force: :cascade do |t|
    t.integer 'student_id',  limit: 4
    t.string 'institution', limit: 255
    t.string 'year',        limit: 255
    t.string 'course',      limit: 255
    t.string 'total_mark',  limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'student_previous_data', ['student_id'], name: 'index_student_previous_data_on_student_id', using: :btree

  create_table 'student_previous_subject_marks', force: :cascade do |t|
    t.integer 'student_id', limit: 4
    t.string 'subject',    limit: 255
    t.string 'mark',       limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'student_previous_subject_marks', ['student_id'], name: 'index_student_previous_subject_marks_on_student_id', using: :btree

  create_table 'student_scores', force: :cascade do |t|
    t.integer 'placement_exams_id', limit: 4
    t.float 'score',              limit: 24
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer 'student_id',         limit: 4
    t.boolean 'is_qualify',         limit: 1
  end

  add_index 'student_scores', ['placement_exams_id'], name: 'index_student_scores_on_placement_exams_id', using: :btree
  add_index 'student_scores', ['student_id'], name: 'index_student_scores_on_student_id', using: :btree

  create_table 'student_subjects', force: :cascade do |t|
    t.integer 'student_id', limit: 4
    t.integer 'subject_id', limit: 4
    t.integer 'batch_id',   limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'student_subjects', ['batch_id'], name: 'index_student_subjects_on_batch_id', using: :btree
  add_index 'student_subjects', ['student_id'], name: 'index_student_subjects_on_student_id', using: :btree
  add_index 'student_subjects', ['subject_id'], name: 'index_student_subjects_on_subject_id', using: :btree

  create_table 'students', force: :cascade do |t|
    t.string 'admission_no',       limit: 255
    t.string 'class_roll_no',      limit: 255
    t.date 'admission_date'
    t.string 'first_name',         limit: 255
    t.string 'middle_name',        limit: 255
    t.string 'last_name',          limit: 255
    t.integer 'batch_id',           limit: 4
    t.date 'date_of_birth'
    t.string 'gender',             limit: 255
    t.string 'blood_group',        limit: 255
    t.string 'birth_place',        limit: 255
    t.integer 'nationality_id',     limit: 4
    t.string 'language',           limit: 255
    t.string 'religion',           limit: 255
    t.integer 'category_id',        limit: 4
    t.string 'address_line1',      limit: 255
    t.string 'address_line2',      limit: 255
    t.string 'city',               limit: 255
    t.string 'state',              limit: 255
    t.string 'pin_code',           limit: 255
    t.integer 'country_id',         limit: 4
    t.string 'phone1',             limit: 255
    t.string 'phone2',             limit: 255
    t.string 'email',              limit: 255
    t.integer 'immediate_contact',  limit: 4
    t.boolean 'is_sms_enabled',     limit: 1,   default: true
    t.string 'status_description', limit: 255
    t.boolean 'is_active',          limit: 1,   default: true
    t.boolean 'is_deleted',         limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'image_file_name',    limit: 255
    t.string 'image_content_type', limit: 255
    t.integer 'image_file_size',    limit: 4
    t.datetime 'image_updated_at'
  end

  add_index 'students', ['batch_id'], name: 'index_students_on_batch_id', using: :btree
  add_index 'students', ['category_id'], name: 'index_students_on_category_id', using: :btree

  create_table 'subjects', force: :cascade do |t|
    t.string 'name',               limit: 255
    t.string 'code',               limit: 255
    t.integer 'batch_id',           limit: 4
    t.boolean 'no_exams',           limit: 1,   default: false
    t.integer 'max_weekly_classes', limit: 4
    t.integer 'elective_group_id',  limit: 4
    t.boolean 'is_deleted',         limit: 1,   default: false
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'subjects', ['batch_id'], name: 'index_subjects_on_batch_id', using: :btree
  add_index 'subjects', ['elective_group_id'], name: 'index_subjects_on_elective_group_id', using: :btree

  create_table 'time_table_entries', force: :cascade do |t|
    t.integer 'batch_id',        limit: 4
    t.integer 'weekday_id',      limit: 4
    t.integer 'class_timing_id', limit: 4
    t.integer 'subject_id',      limit: 4
    t.integer 'employee_id',     limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer 'time_table_id',   limit: 4
  end

  add_index 'time_table_entries', ['batch_id'], name: 'index_time_table_entries_on_batch_id', using: :btree
  add_index 'time_table_entries', ['class_timing_id'], name: 'index_time_table_entries_on_class_timing_id', using: :btree
  add_index 'time_table_entries', ['employee_id'], name: 'index_time_table_entries_on_employee_id', using: :btree
  add_index 'time_table_entries', ['subject_id'], name: 'index_time_table_entries_on_subject_id', using: :btree
  add_index 'time_table_entries', ['time_table_id'], name: 'index_time_table_entries_on_time_table_id', using: :btree
  add_index 'time_table_entries', ['weekday_id'], name: 'index_time_table_entries_on_weekday_id', using: :btree

  create_table 'time_tables', force: :cascade do |t|
    t.date 'start_date'
    t.date 'end_date'
    t.boolean 'is_active',  limit: 1
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'user_activities', force: :cascade do |t|
    t.integer 'user_id',    limit: 4
    t.string 'modelname',  limit: 255
    t.integer 'model_id',   limit: 4
    t.string 'action',     limit: 255
    t.datetime 'created_at',             null: false
    t.datetime 'updated_at',             null: false
  end

  add_index 'user_activities', ['user_id'], name: 'index_user_activities_on_user_id', using: :btree

  create_table 'user_privileges', force: :cascade do |t|
    t.integer 'user_id',      limit: 4
    t.integer 'privilege_id', limit: 4
    t.datetime 'created_at',             null: false
    t.datetime 'updated_at',             null: false
  end

  add_index 'user_privileges', ['privilege_id'], name: 'index_user_privileges_on_privilege_id', using: :btree
  add_index 'user_privileges', ['user_id'], name: 'index_user_privileges_on_user_id', using: :btree

  create_table 'users', force: :cascade do |t|
    t.string 'username',               limit: 255
    t.string 'first_name',             limit: 255
    t.string 'last_name',              limit: 255
    t.string 'role',                   limit: 255
    t.string 'student_id',             limit: 255
    t.string 'employee_id',            limit: 255
    t.string 'email',                  limit: 255, default: '', null: false
    t.string 'encrypted_password',     limit: 255, default: '', null: false
    t.integer 'general_setting_id',     limit: 4
    t.string 'reset_password_token',   limit: 255
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count',          limit: 4,   default: 0,  null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string 'current_sign_in_ip',     limit: 255
    t.string 'last_sign_in_ip',        limit: 255
    t.string 'confirmation_token',     limit: 255
    t.datetime 'confirmed_at'
    t.datetime 'confirmation_sent_at'
    t.string 'unconfirmed_email',      limit: 255
    t.integer 'failed_attempts',        limit: 4,   default: 0,  null: false
    t.string 'unlock_token',           limit: 255
    t.datetime 'locked_at'
    t.string 'authentication_token',   limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'users', ['authentication_token'], name: 'index_users_on_authentication_token', unique: true, using: :btree
  add_index 'users', ['confirmation_token'], name: 'index_users_on_confirmation_token', unique: true, using: :btree
  add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
  add_index 'users', ['general_setting_id'], name: 'index_users_on_general_setting_id', using: :btree
  add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
  add_index 'users', ['unlock_token'], name: 'index_users_on_unlock_token', unique: true, using: :btree

  create_table 'weekdays', force: :cascade do |t|
    t.integer 'batch_id',    limit: 4
    t.string 'weekday',     limit: 255
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.integer 'day_of_week', limit: 4
  end

  add_index 'weekdays', ['batch_id'], name: 'index_weekdays_on_batch_id', using: :btree

  create_table 'weightages', force: :cascade do |t|
    t.integer 'percentage',        limit: 4
    t.integer 'placement_exam_id', limit: 4
    t.integer 'question_type_id',  limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'weightages', ['placement_exam_id'], name: 'index_weightages_on_placement_exam_id', using: :btree
  add_index 'weightages', ['question_type_id'], name: 'index_weightages_on_question_type_id', using: :btree

  create_table 'weights', force: :cascade do |t|
    t.integer 'percentage',       limit: 4
    t.integer 'PlacementExam_id', limit: 4
    t.integer 'QuestionType_id',  limit: 4
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'weights', ['PlacementExam_id'], name: 'index_weights_on_PlacementExam_id', using: :btree
  add_index 'weights', ['QuestionType_id'], name: 'index_weights_on_QuestionType_id', using: :btree

  add_foreign_key 'privilege_users', 'privilege_tags'
  add_foreign_key 'privilege_users', 'privileges'
  add_foreign_key 'privilege_users', 'users'
  add_foreign_key 'student_informations', 'batches'
  add_foreign_key 'student_informations', 'students'
  add_foreign_key 'student_logs', 'batches'
  add_foreign_key 'student_logs', 'exam_groups'
  add_foreign_key 'student_logs', 'students'
  add_foreign_key 'student_logs', 'subjects'
  add_foreign_key 'user_privileges', 'privileges'
  add_foreign_key 'user_privileges', 'users'
end
