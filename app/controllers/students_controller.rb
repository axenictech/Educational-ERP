class StudentsController < ApplicationController

  def admission1
    
    @student = Student.new
    if Student.first.nil?
      @student.admission_no=1
    else
      @last_student=Student.last
      @student.admission_no=@last_student.admission_no.next
    end 	
    
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      redirect_to students_admission2_path(@student)
    else
      render 'admission1'
    end
  end
  def show
    @student =Student.find(params[:id])
  end

  def admission2
    @student=Student.find(params[:format])
    @guardian=@student.guardians.build

  end

  def admission2_1
    @student=Student.find(params[:format])

  end

  def admission3
    @student=Student.find(params[:format])
  end


  def edit
    @student=Student.find(params[:id])
  end
  
  def update
    @student=Student.find(params[:id])
    @student.update(student_params)
    redirect_to students_profile_path(@student)
  end

  def update_immediate_contact
    @student=Student.find(params[:id])
    @student.update(student_params)
    redirect_to students_previous_data_path(@student)
  end

  def previous_data
    @student=Student.find(params[:format])
    @previous_data=StudentPreviousData.new
  end

  def previous_data_create
    @previous_data=StudentPreviousData.create(previous_data_params)
    @student=Student.find(params[:student_previous_data][:student_id])

    if @previous_data.save
      redirect_to students_profile_path(@student)
    else
      render :template => 'students/previous_data',:object =>'@student'
      
    end
  end

  def previous_subject
    @student=Student.find(params[:format])
    @previous_subject=StudentPreviousSubjectMark.new
  end

  def previous_subject_create
    @previous_subject=StudentPreviousSubjectMark.create(params_subject)
    @student=params[:student_previous_subject_mark][:student_id]
     @previous_subjects=StudentPreviousSubjectMark.where(student_id: @student)
  end


  def search_ajax
    name=params[:search].split(" ")
    if params[:student][:status].eql? "present"
      @students=Student.where("first_name like '%#{name[0]}%' OR last_name like '%#{name[1]}%'
                            OR first_name like '%#{name[1]}%' OR last_name like '%#{name[0]}%'")
    end  
    if params[:student][:status].eql? "former"
      @students=ArchivedStudent.where("first_name like '%#{name[0]}%' OR last_name like '%#{name[1]}%'
                            OR first_name like '%#{name[1]}%' OR last_name like '%#{name[0]}%'")
    end  
  end

  def view_all
    @batches=Batch.all
  end

  def select
    @batch=Batch.find(params[:batch][:id])
    @students=@batch.students.all
  end

  def profile
    @student=Student.find(params[:format])
  end

  def archived_profile
    @student=ArchivedStudent.find(params[:format])
  end

  def advanced_search
    @courses=Course.all
    @batches=Batch.all
  end
  
  def advanced_student_search
     name=params[:student][:student_name].split(" ")
    if params[:student][:status].eql? "present"
      @students=Student.where("first_name like '#{name[0]}' OR last_name like '#{name[1]}'
                            OR first_name like '#{name[1]}' OR last_name like '#{name[0]}'")
    end  
    if params[:student][:status].eql? "former"
      @students=ArchivedStudent.where("first_name like '#{name[0]}' OR last_name like '#{name[1]}'
                            OR first_name like '#{name[1]}' OR last_name like '#{name[0]}'")
    end  
  end

  def elective
    @subject=Subject.find(params[:subject_id])
  end

  def email
    @student=Student.find(params[:format])
  end

  def remove
    @student=Student.find(params[:format])
  end
  
  def delete
    @student=Student.find(params[:format])
  end

  def destroy
    @student=Student.find(params[:id])
    @student.destroy
    redirect_to home_dashboard_path
    
  end

  def change_to_former
    @student=Student.find(params[:format])
    @archived_student=ArchivedStudent.new

  end

  def archived_student_create
    @student=Student.find(params[:format])
    @archived_student=ArchivedStudent.create(archived_student_params)
    @student.destroy
    redirect_to students_archived_profile_path(@archived_student)
  end

  def profile_pdf
    
    @student = Student.find(params[:id])
    @address = @student.address_line1 + ' ' + @student.address_line2
    # @immediate_contact = Guardian.find(@student.immediate_contact)
    
  end

  def dispguardian
     @student = Student.find(params[:format])
     @guards =@student.guardians.all
  end

  def addguardian
       @student=Student.find(params[:format])
       @guard=@student.guardians.build
  end
  
  def archived_student_guardian
     @student = ArchivedStudent.find(params[:format])
     @guards=Guardian.where(:student_id=>@student.student_id)
  end

  private
  def student_params
      params.require(:student).permit(:admission_no,:class_roll_no,:admission_date,:first_name,
                                    :middle_name, :last_name,:batch_id,:date_of_birth,:gender,:blood_group,:birth_place, 
                                    :nationality_id ,:language,:category_id,:religion,:address_line1,:address_line2,:city,
                                    :state,:pin_code,:country_id,:phone1,:phone2,:email,:immediate_contact,:status_description )
  end

  def previous_data_params
    params.require(:student_previous_data).permit(:student_id,:institution,:year,:course,:total_mark)
  end

  def params_subject
    params.require(:student_previous_subject_mark).permit(:student_id,:subject,:mark)
  end
  def archived_student_params
      params.require(:archived_student).permit(:student_id,:admission_no,:class_roll_no,:admission_date,:first_name,
                                    :middle_name, :last_name,:batch_id,:date_of_birth,:gender,:blood_group,:birth_place, 
                                    :nationality_id ,:language,:category_id,:religion,:address_line1,:address_line2,:city,
                                    :state,:pin_code,:country_id,:phone1,:phone2,:email,:immediate_contact,:status_description )
  end
end