class StaticPagesController < ApplicationController
  def home
    # @micropost = current_user.microposts.build if logged_in?
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def help; end

  def about; end

  def contact; end
end
