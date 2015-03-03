# Placement News Controller
class PlacementNewsController < ApplicationController
  before_action :set_placement_news, only: [:edit, :update, :destroy]

  # Get all placement news
  def index
    @placement_new = PlacementNews.new
    @placement_news = PlacementNews.all
  end

  # this method used for edit placement news
  def edit
  end

  # This method used for create placementnews,
  # create placementnews instance  and pass required params
  # from private method and call save method on placementnews instance
  def create
    @placement_news = PlacementNews.all
    @placement_new = PlacementNews.new(placement_news_params)
    if @placement_new.save
      redirect_to placement_news_index_path
      flash[:notice] = t('placement_news_created')
    else
      render 'index'
    end
  end
  
  # this method used for update placementnews,first
  # find placementnews which to be update
  # call update method on instance of placementnews
  def update
    @placement_news.update(placement_news_params)
    flash[:notice] = t('placement_news_update')
  end

  # this method used for destroy placementnews,
  # first find placementnews which to be destroy
  # call destroy method on instance of placementnews
  def destroy
    @placement_news.destroy
    redirect_to placement_news_index_path
    flash[:notice] = t('placement_news_destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_placement_news
    @placement_news = PlacementNews.find(params[:id])
  end

  def placement_news_params
    params.require(:placement_news).permit(:title, :content, :islink)
  end
end
