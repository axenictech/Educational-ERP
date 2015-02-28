Rails.application.routes.draw do

  root 'home#index'
  resources :placement_exams do
    collection do
      get :setting_index
      get :create_exam
      post :insert_exam
      get :insert_mark
      get :insert
      get :exam
      get :question_paper
      get :disp_time
      post :save_test
      get :apply_exam
      get :publish_result
      get :display_result
      post :qualify_student
      get :qualified_student

    end
  end
  resources :placement_news

  resources :options

  resources :qusetions

  resources :question_types
  resources :question_databases do
    collection do
      get :option
    end
  end
  resources :qusetion_types

  resources :companies

  devise_for :users, controllers: { registrations: 'registrations' }

  resources :home do
    collection do
      get :dashboard
    end
    member do
      get :user_activity
    end
  end

  resources :categories

  resources :users do
    collection do
      get :view_all
      get :select
      get :search
      get :view_all_details
    end
    member do
      get :change_password
      patch :update_password
    end
  end

  resources :general_settings do
    collection do
      get :all
      get :none
    end
  end

  resources :grading_levels do
    collection do
      get :select
    end
  end
  resources :batches do
    collection do
      get :select
      get :assign_tutor
      post :assign_tutorial
    end
    member do
      post :assign_employee
      delete :remove_employee
    end

    resources :grading_levels
  end

  resources :batch_transfers do
    collection do
      get :select
      get :assign_all
      get :remove_all
      get :student_transfer
      get :former_student
    end
    member do
      get :graduation
      get :transfer
    end
  end

  resources :elective_groups do
    member do
      get :elective_subject
    end
  end

  resources :subjects do
    collection { get :select }
  end

  resources :batches do
    member do
      get :display
    end
    resources :subjects do
      collection do
        get :subject
      end
    end
    resources :elective_groups do
      resources :subjects
    end
  end

  resources :students do
    collection do
      get :admission1
      get :admission2
      get :admission2_1
      get :admission3
      get :previous_data
      post :previous_data_create
      get :previous_subject
      post :previous_subject_create
      get :remove
      get :change_to_former
      get :delete
      get :email
      post :send_email
      get :dispguardian
      get :addguardian
      get :report
      get :reciept
      get :student_exam_report
      get :attendance_report
      get :genrate_report
      get :subject_wise_report
      get :academic_report
      get :final_report
      get :transcript_report
      get :student_final_report
      get :student_transcript_report
      get :view_all
      get :advanced_search
      get :select
      get :advanced_student_search
      post :advanced_search_result
      get :edit_immediate_contact
      patch :update_immediate_contact
      patch :update_immediatecontact
      get :search_ajax
      get :archived_report
      get :archived_student_guardian
      get :report_email
      get :archived_student_transcript_report
      post :send_report_email
      get :search
      post :adm_create
      post :archived_student_create
      post :assign_elective
      get :batch_details
      get :recent_exam_report
    end
    member do
      get :profile
      get :student_profile
      get :archived_student_profile
      get :generate_tc
      get :elective
      get :assign_all
      get :remove_all
      get :archived_profile
    end
    resources :guardians
  end

  resources :guardians do
    collection do
      post :addguardian_create
    end
  end
  resources :subjects
  resources :newscasts do
    collection do
      get :select
      get :display
    end
    resources :comments
  end

  resources :time_tables do
    collection do
      get :work_allotment
      post :work_allotment
      get :new_timetable
      get :edit_timetable
      get :update_timetable
      patch :update_timetable_values
      delete :time_table_delete
      get :select_time
      get :select
      get :time_table_pdf
      get :teachers_timetable
      get :teacher_time_table_display
      get :timetable
      get :employee_timetable
      get :select_time_employee
      get :display_institutional_time_table
      get :teacher_timetable_pdf
    end
  end

  resources :exam_reports do
    collection do
      get :report_center
      get :exam_wise_report
      get :subject_wise_report
      get :generate_exam_report
      get :select_batch
      get :choose_batch
      get :generate_subject_report
      get :grouped_exam_report
      get :generate_grouped_report
      get :archived_student_report
      get :select_course
      get :generate_archived_report
      get :exam_group_wise_report
      get :student_ranking_per_subject
      get :rank_report_batch
      get :generate_ranking_report
      get :student_ranking_per_batch
      get :generate_student_ranking_report
      get :student_ranking_per_course
      get :generate_student_ranking_report2
      get :student_ranking_per_school
      get :student_ranking_per_attendance
      get :generate_student_ranking_report3
      get :view_transcripts
      get :generate_view_transcripts
      get :ranking_level_report
      get :select_mode
      get :select_rank
      get :select_rank_mode
      get :generate_ranking_level_report
      get :combined_report
      get :combined_details
      get :all
      get :none
      get :all1
      get :none1
      get :generate_combined_report
      get :exam_wise_students_report
      get :exam_wise_consolidated_report
      get :subject_wise_students_report
      get :grouped_exam_students_report
      get :archived_students_exam_report
      get :archived_students_consolidated_report
      get :subject_wise_ranking_report
      get :batch_wise_ranking_report
      get :course_wise_ranking_report
      get :school_wise_ranking_report
      get :attendance_wise_ranking_report
      get :students_transcripts_report
    end
    member do
      get :student_exam_report
      get :student_report
      get :consolidated_report
      get :consolidated_archived_report
      get :archived_student
      get :student_view_transcripts
    end
  end

  resources :exam_setting do
    member do
      get :setting
      get :settingrank
      get :editRank
      delete :destroy_rank
      get :edit
      delete :course
      get :decrease_priority
      get :increase_priority
    end
    collection do
      get :select
      get :selectrank
      get :newrank
      post :createrank
      patch :update_rank
    end
  end

  resources :exam_groups do
    collection do
      patch :update_exam_score
      get :select
      get :connect_exam

      get :publish_exam
      get :publish_result
      get :previous_exam_data
      get :previous_exam
      get :previous_exam_group
      get :previous_exam_details
      get :previous_exam_scores
    end
    member do
      patch :exam_group_create
      get :exams
      patch :update_connect_exam
      get :assign_all
      get :remove_all
    end
  end

  resources :exams do
    collection { patch :update_exam_score }
    member { get :exam_score }
  end

  resources :class_timings do
    collection do
      get :select
    end
  end

  resources :batches do
    resources :class_timings
  end

  resources :events do
    collection do
      get :showdep
    end
  end

  resources :calender do
    collection do
      get :event_view
      get :view_events
      get :display_batch_department
      patch :update_event
    end

    member do
      get :change
    end
  end

  resources :weekdays do
    collection do
      get :select
    end
  end

  resources :time_tables

  resources :attendences do
    collection do
      get :attendence_register
      get :report
      get :select
      get :select_subject
      get :select_batch
      get :generate_report
      get :attendence_report
      post :create_attendence
    end
    member do
      get :edit_attendence
      patch :update_attendence
      delete :delete_attendence
      get :display
      get :new_attendence
    end
  end

  resources :time_table_entries do
    collection do
      get :select
      get :select_subject
      post :assign_time
      delete :delete_time
      post :create_time
    end
  end

  resources :batches do
    resources :time_table_entries
  end

  resources :exam_setting do
    collection do
      get :newrank
      get :selectrank
      post :createrank
      patch :updateRank
      get :select
    end
    member do
      delete :destroy_rank
      get :setting
      get :settingrank
      get :edit_rank
    end
  end

  resources :exam_groups do
    collection do
      get :select
      get :previous_exam_data
      get :publish_exam
      get :connect_exam
      get :publish_result
    end
    member do
      get :exams
    end

    resources :exams
  end

  resources :exams do
    member do
      get :exam_score
    end
    resources :exam_scores
  end

  resources :online_exam_groups

  resources :exam_reports do
    collection do
      get :report_center
      get :exam_wise_report
      get :select_batch
      get :generate_exam_report
      get :subject_wise_report
      get :choose_batch
      get :generate_subject_report
      get :subject_wise_students_report
      get :grouped_exam_report
      get :generate_grouped_report
      get :archived_student_report
      get :select_course
      get :generate_archived_report
      get :archived_students_consolidated_report
      get :exam_group_wise_report
      get :archived_students_exam_report
    end
    member do
      get :archived_student
      get :consolidated_archived_report
    end
  end

  resources :courses do
    resources :exam_setting
  end

  resources :setting do
    collection do
      get :course_batch
    end
  end

  resources :courses do
    collection do
      post :create_batch_group
    end
    member do
      get :grouped_batches
      get :edit_batch_group
      patch :update_batch_group
      delete :delete_batch_group
      get :assign_all
      get :remove_all
    end
    resources :batches
  end

  resources :employees do
    collection do
      get :settings
      get :new_category
      post :add_category
      get :new_department
      post :add_department
      get :new_position
      post :add_position
      get :new_bank_field
      post :add_bank_field
      get :new_payroll_category
      post :add_payroll_category
      get :new_grade
      post :add_grade
      get :employee_management
      get :subject_assignment
      get :assign_subject
      get :assign_subject_disp
      get :list_emp
      get :admission1
      get :admission2
      patch :admission2_create
      get :admission3
      post :admission3_create
      get :edit_privilege
      get :admission4
      post :update_privilege
      get :search
      get :change_reporting_manager
      get :profile
      get :genral_profile
      get :personal_profile
      get :address_profile
      get :contact_profile
      get :bank_info
      get :edit_profile
      get :edit_personal_profile
      get :edit_address_profile
      get :edit_contact_profile
      get :edit_bank_info
      get :personal_profile_pdf
      get :address_profile_pdf
      get :contact_profile_pdf
      get :bank_info_pdf
      get :employee_profile
      get :remove
      get :change_to_former
      get :delete_employee
      get :archived_employee_profile
      get :genral_profile_archived
      get :personal_profile_archived
      get :address_profile_archived
      get :contact_profile_archived
      get :bank_info_archived
      patch :update_profile
      patch :update_edit_profile
      patch :update_edit_address_profile
      patch :update_edit_contact_profile
      patch :update_bank_details
      post :create_archived_employee
      get :emp_payroll
      get :search_employee
      get :search_emp
      get :advance_search
      get :viewall_emp
      get :allemp
      post :advance_search_result_pdf
      get :advance_search_emp
      get :department_payslip
      get :select_month
      post :view_payslip
      get :view_employee_payslip
      get :employee_individual_payslip_pdf
      get :payslip
      get :select_employee_department
      post :department_employee_list
      get :monthly_payslip
      post :create_monthly_payslip
      post :create_payslip_category
      get :payroll_category
      post :add_payroll_categorys
      get :one_click_payslip
      post :one_click_payslip_generate
      get :payslip_revert
      post :one_click_payslip_revert
      post :emp_search_result_pdf
      get :employee_structure
      get :emp_payslip
      post :view_payslip_profile

    end
    member do
      get :edit_category
      patch :update_category
      delete :destroy_category
      get :edit_department
      patch :update_department
      delete :destroy_department
      get :edit_position
      patch :update_position
      delete :destroy_position
      get :edit_bank_field
      patch :update_bank_field
      delete :destroy_bank_field
      get :edit_payroll_category
      patch :update_payroll_category
      delete :destroy_payroll_category
      get :active_payroll_category
      get :inactive_payroll_category
      get :edit_grade
      patch :update_grade
      delete :destroy_grade
      delete :remove_employee
      post :assign_employee
      get :update_reporting_manager_name
      patch :update_reporting_manager
      get :emp_payslip
    end
  end

  resources :employee_attendances do
    collection do
      get :new_leave_type
      get :attendance_report
      get :attendence_register
      get :manual_reset
      post :add_leave_type
      get :select
      get :select_report
      get :leave_reset_all
      get :employee_leave_reset_by_employee
      get :employee_leave_reset_by_department
      get :update_employee_leave_reset_all
      get :assign_all
      get :remove_all
      get :update_department_leave_reset
      post :search
      get :search_emp
      get :leave_reset_settings
      get :select_department
    end
    member do
      get :edit_leave_type
      patch :update_leave_type
      delete :destroy_leave_type
      get :report_info
      get :attendance_report_pdf
      get :employee_leave_detail
      get :employee_wise_leave_reset
      get :edit_attendance
      patch :update_att
      delete :destroy_attendance
      get :new_attendance
      get :display
    end
  end
  resources :finance do
    collection do
      get :fees
      get :transaction_category
      get :transactions
      get :donation
      get :automatic_transaction
      get :payslip
      get :asset_liability
      get :master_fees
      get :fee_collection
      get :fees_submission
      get :fees_structure
      get :fees_defaulters
      get :new_expense
      get :new_income
      get :transaction_report
      get :compare_report
      get :view_monthly_payslip
      get :approve_monthly_payslip
      get :liability
      get :asset
      get :new_asset
      get :view_asset
      post :create_asset
      get :asset_list
      get :new_liability
      post :create_liability
      get :view_liability
      get :liability_list
      post :view_payslip
      get :employee_monthly_payslip
      get :view_employee_payslip
      get :approve_salary
      get :approve
      get :new_automatic_transaction
      post :create_automatic_transaction
      get :donors
      post :create_donation
      get :view_expense
      post :expense_list
      post :create_expense
      get :finance
      get :finance_expense_report
      post :create_income
      get :view_income
      post :income_list
      get :finance_income_report
      post :transactions_list
      get :finance_transaction_report
      get :income_details
      get :expense_details
      post :transactions_comparison
      get :new_transaction_category
      post :create_transaction_category
      get :batch_choice
      get :collection_choice
      get :select_all
      get :select_none
      get :new_master_category
      get :new_fees_particular
      get :new_fee_discount
      get :assign_batch
      get :remove_batch
      post :create_master_category
      get :category_batch
      post :create_fees_particular
      get :fee_discounts
      get :fee_category
      get :discount_view
      get :new_fee_collection
      get :fee_collection_view
      post :create_fee_collection
      get :view_fee_collection
      get :fees_submission_batch
      get :fees_submission_student
      get :fee_collection_date
      get :student_fees
      get :student_fee_receipt
      post :pay_fee
      get :fees_collection_student
      get :search_student
      get :student_fees_submission
      get :fee_collection_structure
      get :student_fees_structure
      get :fee_structure
      get :fees_defaulters_list
      get :defaulter_students
      get :pay_fees_defaulters
      get :fees_list
      get :admission_no
      get :category
      get :employee_payslip
      get :student_search
      post :pay_fine
      post :create_fee_discount
      get :discount_type
      get :student_fees_details
    end
    member do
      get :each_asset_view
      get :edit_asset
      patch :update_asset
      delete :delete_asset
      get :each_liability_view
      get :edit_liability
      patch :update_liability
      delete :delete_liability
      get :edit_automatic_transaction
      patch :update_automatic_transaction
      delete :delete_automatic_transaction
      get :donation_receipt
      get :finance_donation_receipt
      get :edit_donation
      patch :update_donation
      delete :delete_donation
      get :edit_expense
      patch :update_expense
      delete :delete_expense
      get :edit_income
      patch :update_income
      delete :delete_income
      get :edit_transaction_category
      patch :update_transaction_category
      delete :delete_transaction_category
      get :edit_master_category
      patch :update_master_category
      delete :delete_master_category
      get :master_category_particular
      get :new_particular_fee
      get :edit_particular_fee
      patch :update_particular_fee
      delete :delete_particular_fee
      post :create_particular_fee
      get :edit_fee_discount
      patch :update_fee_discount
      delete :delete_fee_discount
      get :edit_fee_collection
      patch :update_fee_collection
      delete :delete_fee_collection
      get :collection_details_view
      get :admission_no
      get :student_category
    end
  end
end
