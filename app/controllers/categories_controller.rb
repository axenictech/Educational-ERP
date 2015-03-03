# Categories Controller
class CategoriesController < ApplicationController
  before_filter :find_category, only: [:edit, :update, :destroy]

  # create object of Category
  # get all category from database for display
  # and perform authorization
  def index
    @category = Category.new
    @categorys ||= Category.all
    authorize! :create, @category
  end

  # create Category object and pass required parameters
  # from private method category_params and
  # create action is saving our new Category to the database.
  def create
    @categorys ||= Category.all
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = t('category_create')
      redirect_to categories_path
    else
      render 'index'
    end
  end

  # find Category which we want to edit and pass it to update method
  # and perform authorization
  def edit
    authorize! :update, @category
  end

  # upadate method update a Category,
  # and it accepts a hash containing the attributes that you want to update.
  # and perform authorization
  def update
    @category.update(category_params)
    flash[:notice] = t('category_update')
  end

  # find Category which we want to destroy,
  # destroy method deleting that Category from the
  # database and perform authorization
  def destroy
    authorize! :delete, @category
    @category.destroy
    flash[:notice] = t('category_delete')
    redirect_to categories_path
  end

  private

  # find the category
  def find_category
    @category = Category.shod(params[:id])
  end

  # this private methods tell us exactly which parameters are allowed
  # into our controller actions.
  def category_params
    params.require(:category).permit(:name)
  end
end
