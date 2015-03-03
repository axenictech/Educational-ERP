# Subject Controller
class SubjectsController < ApplicationController
  before_action :set_subject, only: [:edit, :update, :destroy]

  # get all batches from database,and perform authorization
  def index
    @batches ||= Batch.includes(:course)
    authorize! :read, @batches.first
  end

  # find batch which we selected, find all subject in that batch
  def select
    @batch = Batch.shod(params[:batch][:id])
    @subjects ||= @batch.normal_subjects
    @elective_groups ||= @batch.elective_groups
    authorize! :read, @batch
  end

  # get all noramal_subjects of selected batch
  # get elective_groups of selected batch
  def subject_data
    @subjects ||= @batch.normal_subjects
    @elective_groups ||= @batch.elective_groups
  end

  # find the batch which we have selected
  def subject
    @batch = Batch.shod(params[:batch_id])
    subject_data
    authorize! :read, @batch
  end

  # find the batch which we have selected
  # build association in between batch and subject
  def new
    @batch = Batch.shod(params[:batch_id])
    @subject = @batch.subjects.build
    new2(params[:elective_group_id])
    authorize! :create, @subject
  end

  # find ElectiveGroup which we have selected
  # build association in between batch and ElectiveGroup
  def new2(eg_id)
    @elective_group = ElectiveGroup.shod(eg_id) if eg_id
    @subject = @elective_group.subjects.build if eg_id
  end

  # find batch which we have selected
  # create subject object and pass required parameters
  # from private method subject_params,
  # create action is saving our new Subject to the database.
  def create
    @batch = Batch.shod(params[:batch_id])
    subject_data
    @subject = @batch.subjects.new(subject_params)
    create2(params[:elective_group_id])
    flash[:notice] = t('subject_create')
  end

  # find ElectiveGroup which we have selected
  # create subject object and pass required parameters
  # from private method subject_params,
  # create action is saving our new Elective Subject to the database.
  def create2(eg_id)
    @elective_group = ElectiveGroup.shod eg_id if eg_id
    @subject = @elective_group.subjects.new(subject_params) if eg_id
    @elective_subjects ||= @elective_group.subjects if eg_id
    @subject.save
    @subject.update(batch_id: @batch.id) if eg_id
    flash[:notice] = t('elective_create') if eg_id
  end

  # find Subject which we want to edit and pass it to update method
  # and perform authorization
  def edit
    authorize! :update, @subject
  end

  # upadate method update a Subject,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update
    subject_data
    @elective_subjects ||= @elective_group.subjects \
    if params[:elective_group_id]
    @subject.update(subject_params)
    flash[:notice] = t('subject_update')
    flash[:notice] = t('elective_update') if params[:elective_group_id]
  end

  # find Subject which we want to destroy,
  # destroy method deleting that Subject from the
  # database and perform authorization
  def destroy
    authorize! :delete, @subject
    subject_data
    @elective_subjects ||= @elective_group.subjects \
    if params[:elective_group_id]
    destroy2
  end

  # this method is subpart of destroy method
  def destroy2
    @subject.destroy
    redirect_to subjects_path
    flash[:notice] = t('subject_delete')
    flash[:notice] = t('elective_delete') if params[:elective_group_id]
  end

  private

  # find elective group and subject
  def set_subject
    if params[:elective_group_id]
      set_subject2(params[:batch_id], params[:elective_group_id], params[:id])
    else
      set_subject3(params[:batch_id], params[:id])
    end
  end

  # find the batch which we have selected
  # find all subject
  def set_subject2(batch, elective, id)
    @batch = Batch.shod(batch)
    @elective_group = ElectiveGroup.shod(elective)
    @subject = @elective_group.subjects.shod(id)
  end

  # find the batch which we have selected
  # find all subject of that batch
  def set_subject3(batch, id)
    @batch = Batch.shod(batch)
    @subject = @batch.subjects.shod(id)
  end

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def subject_params
    params.require(:subject).permit!
  end
end
