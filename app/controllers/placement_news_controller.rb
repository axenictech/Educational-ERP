
# Placement News Controller
class PlacementNewsController < ApplicationController
  before_action :set_placement_news, only: [:edit, :update, :destroy]

  def index
    @placement_new = PlacementNews.new
    @placement_news = PlacementNews.all
  end

  def edit
  end

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

  def update
    @placement_news.update(placement_news_params)
    flash[:notice] = t('placement_news_update')
  end

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
    params.require(:placement_news).permit(:title, :content,:islink)
  end
end
