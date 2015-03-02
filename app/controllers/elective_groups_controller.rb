# Elective group controller
class ElectiveGroupsController < ApplicationController
  before_action :set_elective_group, only: [:edit, :update, :destroy]

  # find Batch which we have selected
  # build association between Batch and ElectiveGroup
  def new
    @batch = Batch.shod params[:batch_id]
    @elective_group = @batch.elective_groups.build
    authorize! :create, @elective_group
  end

  # create ElectiveGroup object and pass required parameters
  # from private method elective_group_params and
  # create action is saving our ElectiveGroup to the database.
  def create
    @batch = Batch.shod(params[:batch_id])
    @subjects ||= @batch.normal_subjects
    @elective_groups ||= @batch.elective_groups
    @elective_group = @batch.elective_groups.new(elective_group_params)
    @elective_group.save
    flash[:notice] = t('elective_group_create')
  end

  # find ElectiveGroup which we want to edit and pass it to update method
  # and perform authorization
  def edit
    authorize! :update, @elective_group
  end

  # upadate method update a ElectiveGroup,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update
    @subjects ||= @batch.normal_subjects
    @elective_groups ||= @batch.elective_groups
    @elective_group.update(elective_group_params)
    flash[:notice] = t('elective_group_update')
  end

  # find ElectiveGroup which we want to destroy,
  # destroy method deleting that ElectiveGroup from the
  # database and perform authorization
  def destroy
    authorize! :delete, @elective_group
    @subjects ||= @batch.normal_subjects
    @elective_groups ||= @batch.elective_groups
    @elective_group.destroy
    flash[:notice] = t('elective_group_delete')
    redirect_to subjects_path
  end

  # find ElectiveGroup which we have selected
  # find all subject of that ElectiveGroup
  def elective_subject
    @elective_group = ElectiveGroup.shod(params[:id])
    @elective_subjects ||= @elective_group.subjects
    authorize! :read, @elective_group
  end

  private

  # find batch which we have selected
  # find elective_group of that batch
  def set_elective_group
    @batch = Batch.shod(params[:batch_id])
    @elective_group = @batch.elective_groups.shod(params[:id])
  end

  # find ElectiveGroup which we want to destroy,
  # destroy method deleting that ElectiveGroup from the
  # database and perform authorization
  def elective_group_params
    params.require(:elective_group).permit(:name)
  end
end
