# Newscasts Controller
class NewscastsController < ApplicationController
  def new
    @newscast = Newscast.new
  end

  def select
    @newscasts ||= Newscast.news(params[:newscast][:title])
  end

  def create
    @newscast = Newscast.new(newscast_params)
    @newscast.user_id = current_user.id
    if @newscast.save
      redirect_to newscast_path(@newscast), notice: t('news_add')
    else
      render 'new'
    end
  end

  def edit
    @newscast = Newscast.shod(params[:id])
  end

  def update
    @newscast = Newscast.shod(params[:id])
    if @newscast.update(newscast_params)
      redirect_to newscast_path(@newscast), notice: t('news_update')
    else
      render 'edit'
    end
  end

  def destroy
    @newscast = Newscast.shod(params[:id])
    authorize! :delete, @newscast
    @newscast.destroy
    redirect_to newscasts_path(@newscast), notice: t('news_delete')
  end

  def show
    @newscast = Newscast.shod(params[:id])
    @comment = @newscast.comments.new
    authorize! :read, @newscast
  end

  def display
    @newscasts ||= Newscast.order(created_at: :desc).includes(:user)
  end

  private

  def newscast_params
    params.require(:newscast).permit!
  end
end
