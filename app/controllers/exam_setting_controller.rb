# Exam controller is perform the operation for
# ranking level and class disignation
# e.g. Insert, Delete, Update, Read.
class ExamSettingController < ApplicationController
  def index
    authorize! :read, GradingLevel
  end

  # @courses object store the all records of course from database.
  # This object is used in drop down list for select particular course.
  def new
    @courses ||= Course.all
    authorize! :read, ClassDesignation
  end

  # @courses object store the all records of course from database.
  # This object is used in drop down list for select particular course.
  def newrank
    @courses ||= Course.all
    authorize! :read, RankingLevel
  end

  # This action is create the new object for save class designation
  # record in database.
  def setting
    @course = Course.shod(params[:id])
    @class_des = ClassDesignation.new
    @class_dess ||= @course.class_designations
    @class_des1 = @course.class_designations.build
    authorize! :create, @class_des
  end

  # This action is create the new object for save rank level
  # record in database.
  def settingrank
    @course = Course.shod(params[:id])
    @rank_lev = RankingLevel.new
    @rank_levels ||= @course.ranking_levels
    @rank_lev1 = @course.ranking_levels.build
    authorize! :create, @rank_lev
  end

  # This action save the class designation object in database.
  # In this action 'create_flash' action is called for saving the record.
  def create
    @course = Course.shod(params[:id])
    @class_dess ||= @course.class_designations
    @class_des1 = @course.class_designations.new(params_class)
    create_flash
  end

  # This action is subpart of the create action.
  # class designation record is saved using save method and
  # send a flash message.
  def create_flash
    if @class_des1.save
      flash[:notice] = t('create_class')
    else
      flash[:notice] = t('not_create_class')
    end
  end

  # This action save the rank level object in database.
  # In this action 'createrank_flash' subaction is called for
  # saving record.
  def createrank
    @course = Course.shod(params[:course_id])
    @rank_levels = @course.ranking_levels.order('prioriy ASC')
    @rank_lev1 = @course.ranking_levels.new(params_rank)
    @max_rank = RankingLevel.maximum('prioriy')
    @rank_lev1 = @course.max(@max_rank, @rank_lev1)
    createrank_flash
  end

  # This action is subpart of the createrank action.
  # rank level record is saved using save method and
  # send a flash message.
  def createrank_flash
    if @rank_lev1.save
      flash[:notice] = t('create_rank')
    else
      flash[:notice] = t('not_create_rank')
      render 'newrank'
    end
  end

  # This action is subpart of increase_priority and decrease_priority.
  # It store the record of ranking level by ascending order.
  def inc_dec
    @rank_levels = @course.ranking_levels.order('prioriy ASC')
    @rank_lev1 = @course.ranking_levels.find(params[:format])
  end

  # This action is perform the operation to increase the priority
  # of ranking level.
  def increase_priority
    @course = Course.find(params[:id])
    inc_dec
    selected = params[:index].to_i - 1.to_i
    @course.increase_logic(@rank_levels, selected)
    @rank_levels = @course.ranking_levels.order('prioriy ASC')
    authorize! :create, @rank_lev1
  end

  # This action is perform the operation to decrease the priority
  # of ranking level.
  def decrease_priority
    @course = Course.shod(params[:id])
    inc_dec
    selected = params[:index].to_i + 1.to_i
    @course.decrease_logic(@rank_levels, selected)
    @rank_levels = @course.ranking_levels.order('prioriy ASC')
    authorize! :create, @rank_lev1
  end

  # This action delete the selected class designation record
  # for particular course.
  # In this action another action is called i.e. 'destroy_flash'.
  def destroy
    @course = Course.shod(params[:id])
    authorize! :delete, @class_des1
    @class_dess ||= @course.class_designations
    @class_des1 = @course.class_designations.find(params[:class_des])
    destroy_flash
  end

  # This action delete the class designation record using destroy method
  # and display the flash message.
  def destroy_flash
    if @class_des1.destroy
      flash[:notice] = t('del_class')
      redirect_to new_exam_setting_path
    else
      flash[:notice] = t('not_del_class')
    end
  end

  # This action delete the selected class rank level record
  # for particular course.In this action another action is called
  # i.e. 'destroy_rank_flash'.
  def destroy_rank
    @rank_lev1 = RankingLevel.shod(params[:id])
    authorize! :delete, @ranking_levels
    @course = @rank_lev1.course
    @rank_levels = @course.ranking_levels.order('prioriy ASC')
    destroy_rank_flash(@rank_lev1)
  end

  # This action delete the rank level record using destroy method
  # and display the flash message.
  def destroy_rank_flash(rank_lev1)
    if rank_lev1.destroy
      flash[:notice] = t('del_rank')
      redirect_to newrank_exam_setting_index_path
    else
      flash[:notice] = t('not_del_rank')
      render 'newrank'
    end
  end

  # This action is used to fetch the selected class designation
  # record for edit.
  def edit
    @course = Course.shod(params[:id])
    @class_des1 = @course.class_designations.find(params[:class_des])
    authorize! :update, @class_des1
  end

  # This action update the class designation record for
  # selected course. Called the update_flash action for actual
  # updation and send flash message.
  def update
    @course = Course.shod(params[:course_id])
    @class_dess ||= @course.class_designations
    @class_des1 = @course.class_designations.shod(params[:class_des])
    update_flash
  end

  # This action is subpart of update action and used to update the record
  # in database and send flash message.
  def update_flash
    if @class_des1.update(params_class)
      flash[:notice] = t('update_class')
    else
      flash[:notice] = t('not_update_class')
    end
  end

  # This action is used to fetch the selected rank level
  # record for edit.
  def edit_rank
    @course = Course.shod(params[:id])
    @rank_lev1 = @course.ranking_levels.shod(params[:course_id])
    authorize! :update, @rank_lev1
  end

  # This action is a sub part of update_rank action
  def ranklevel
    @rank_levels = @course.ranking_levels.order('prioriy ASC')
    @rank_lev1 = @course.ranking_levels.find(params[:id])
  end

  # This action update the rank level record for
  # selected course. 'ranklevel' is action called for create
  # object e.g. @rank_levels, @rank_lev1
  def update_rank
    @course = Course.shod(params[:course_id])
    ranklevel
    if @rank_lev1.update(params_rank)
      flash[:notice] = t('update_rank')
    else
      flash[:notice] = t('not_update_rank')
    end
  end

  # @course object is is store the all course record from database for
  # display in drop down list. @class_dess object is consist the class
  # designation record for specific course.
  def select
    @course = Course.shod(params[:course][:id])
    @class_dess ||= @course.class_designations
    authorize! :read, @class_dess.first
  end

  # @course object is is store the all course record from database for
  # display in drop down list. @rank_levels object is consist the ranking
  # level record for specific course.
  def selectrank
    @course = Course.shod(params[:course][:id])
    @rank_levels = @course.ranking_levels.order('prioriy ASC')
  end

  private

  def params_class
    params.require(:class_designation).permit(:name, :marks)
  end

  private

  def params_rank
    params.require(:ranking_level).permit!
  end
end
