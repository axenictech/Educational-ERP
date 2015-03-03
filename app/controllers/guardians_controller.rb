# Guardians Controller
class GuardiansController < ApplicationController
  # this method is used for create guardian
  # pertiular student, find student call create method on association of
  # student.guardian ,save guardian
  def create
    @student = Student.shod(params[:student_id])
    @guardian = @student.guardians.create(guardian_params)
    temp_email = params['guardian']['email']
    downcase_email = temp_email.downcase
    @guardian.email = downcase_email
    if @guardian.save
      redirect_to admission2_1_students_path(@student)
    else
      @countries ||= Country.all
      render '/students/admission2'
    end
  end

  # this method is used for hold the student of perticular guardian
  def addguardian
    @student = Student.shod(params[:student_id])
    authorize! :read, @student
  end

  # this method is used for create guardian
  # pertiular student, find student call create method on association of
  # student.guardian ,save guardian
  def addguardian_create
    @student = Student.shod(params[:format])
    @guard = @student.guardians.create(guardian_params)
    temp_email = params['guardian']['email']
    downcase_email = temp_email.downcase
    @guard.email = downcase_email
    if @guard.save
      redirect_to dispguardian_students_path(@student)
    else
      render '/students/addguardian'
    end
  end

  # This method is used to destroy guardian,first find guardian which
  # to be destroy call destroy method on instance guardian
  def destroy
    @guard = Guardian.shod(params[:id])
    authorize! :delete, @guard
    @guard.destroy
    redirect_to students_dispguardian_path(@guard.student)
  end

  # This method used for edit guardian  details
  def edit
    @student = Student.shod(params[:student_id])
    @guard = @student.guardians.shod(params[:id])
    authorize! :update, @student
  end

  # this method used for updat guardian,first find guardian which to be update
  # call update method on instance of guardian
  def update
    @student = Student.shod(params[:student_id])
    @guard = @student.guardians.shod(params[:id])
    if @guard.update(guardian_params)
      flash[:notice] = t('guardian_update')
      redirect_to dispguardian_students_path(@guard.student)
    else
      render 'edit'
    end
  end

  private

  def guardian_params
    params.require(:guardian).permit!
  end
end
