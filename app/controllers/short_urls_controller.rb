require 'json'
class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # Return the top 100 most frequently accessed shortcodes.
  def index
    @urls = ShortUrl.order(click_count: :desc).limit(100)
    render json: {:urls => @urls}, status: :ok
  end

  # Register the full url within the database.
  #
  # Returns a json containing the information about the ful_url that got created.
  def create
    full_url = params[:full_url]
    @short_url = ShortUrl.create(full_url: full_url)
    render json: @short_url, status: :created
  end

  def show
  end

end
