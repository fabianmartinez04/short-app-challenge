require 'json'
class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  #Return the top 100 most frequently accessed shortcodes.
  def index
    @short_urls = ShortUrl.order(click_count: :desc).limit(100)
    render json: { :urls => @short_urls}, status: :ok
  end

  def create
  end

  def show
  end

end
