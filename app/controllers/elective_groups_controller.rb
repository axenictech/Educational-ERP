class ElectiveGroupsController < ApplicationController
  before_action :set_elective_group, only: [:edit, :update, :destroy]

  def new
    @batch = Batch.find params[:batch_id]
    @elective_group = @batch.elective_groups.build
    authorize! :create, @elective_group
  end

  def create
    @batch = Batch.find(params[:batch_id])
    @subjects = @batch.subjects.where(elective_group_id: nil)
    @elective_groups = @batch.elective_groups.all
    @elective_group = @batch.elective_groups.new(elective_group_params)
    @elective_group.save
    flash[:notice] = 'Elective group Created Successfully'
  end

  def edit
    authorize! :update, @elective_group
  end

  def update
    @subjects = @batch.subjects.where(elective_group_id: nil)
    @elective_groups = @batch.elective_groups.all
    @elective_group.update(elective_group_params)
    flash[:notice] = 'Elective group updated Successfully'
  end

  def destroy
    authorize! :delete, @elective_group
    @subjects = @batch.subjects.where(elective_group_id: nil)
    @elective_groups = @batch.elective_groups.all
    @elective_group.destroy
    redirect_to dashboard_home_index_path
    flash[:notice] = 'Elective group deleted Successfully'
  end

  def elective_subject
    @elective_group = ElectiveGroup.find(params[:id])
    @elective_subjects = @elective_group.subjects.all
    authorize! :read, @elective_group
  end

  private

  def set_elective_group
    @batch = Batch.find(params[:batch_id])
    @elective_group = @batch.elective_groups.find(params[:id])
  end

  def elective_group_params
    params.require(:elective_group).permit(:name)
   end
end
