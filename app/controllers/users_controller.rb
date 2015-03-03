# Users Controller
class UsersController < ApplicationController
  def index
    authorize! :read, User
  end
  
  # create new object of User
  # this method is used when user Sign_up for system
  def new
    @user = User.new
    authorize! :create, @user
  end
  
  # create User object and pass required parameters
  # from private method user_params and
  # create action is saving our new User to the database.
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:user] = t('user_create')
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
    @user = User.shod(params[:id])
    @student = @user.student
    @employee = User.where(role: 'Employee').take
    authorize! :read, @user
  end

  def search
    @users ||= User.search_user(params[:search])
    authorize! :read, @user
  end

  def edit
    @user = User.shod(params[:id])
    authorize! :update, @user
  end

  def update
    @user = User.shod(params[:id])
    if @user.update(user_params)
      flash[:notice] = t('user_update')
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def change_password
    @user = User.shod(params[:id])
    authorize! :update, @user
  end

  def update_password
    @user = User.shod(params[:id])
    if @user.update(user_params)
      flash[:notice] = t('pass_change')
      redirect_to user_path(@user)
    else
      render 'change_password'
    end
  end

  def select
    @users ||= User.role_wise_users(params[:user][:role])
    authorize! :read, @user
  end

  def destroy
    @user = User.shod(params[:id])
    authorize! :delete, @user
    @user.destroy
    flash[:user_delete] = t('user_delete')
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit!
  end
end
