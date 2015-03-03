# Newscasts Controller
class NewscastsController < ApplicationController
  # this method is used for create new instance of newcast
  def new
    @newscast = Newscast.new
  end

  # this method used for select news cast titel by calling
  # class method news
  def select
    @newscasts ||= Newscast.news(params[:newscast][:title])
  end

  # This method used for create newscast,
  # create newscast instance  and pass required params
  # from private method and call save method on newscast instance
  def create
    @newscast = Newscast.new(newscast_params)
    @newscast.user_id = current_user.id
    if @newscast.save
      redirect_to newscast_path(@newscast), notice: t('news_add')
    else
      render 'new'
    end
  end

  # this method is used for edit news cast
  def edit
    @newscast = Newscast.shod(params[:id])
  end

  # this method used for update newscast,first find newscast which to be update
  # call update method on instance of newscast
  def update
    @newscast = Newscast.shod(params[:id])
    if @newscast.update(newscast_params)
      redirect_to newscast_path(@newscast), notice: t('news_update')
    else
      render 'edit'
    end
  end

  # this method used for destroy option,
  # first find newscast which to be destroy
  # call destroy method on instance of newscast
  def destroy
    @newscast = Newscast.shod(params[:id])
    authorize! :delete, @newscast
    @newscast.destroy
    redirect_to newscasts_path(@newscast), notice: t('news_delete')
  end

  # this method is used for display all comments on newscast
  def show
    @newscast = Newscast.shod(params[:id])
    @comment = @newscast.comments.new
    authorize! :read, @newscast
  end

  # this method used for display all newscast in desecnding order
  def display
    @newscasts ||= Newscast.order(created_at: :desc).includes(:user)
  end

  private

  def newscast_params
    params.require(:newscast).permit!
  end
end
