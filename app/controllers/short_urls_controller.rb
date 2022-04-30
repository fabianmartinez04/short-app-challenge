require 'json'
class ShortUrlsController < ApplicationController

  # Since we're working on an API, we don't have authenticity tokens
  skip_before_action :verify_authenticity_token

  # Return the top 100 most frequently accessed shortcodes.
  def index
    @urls = ShortUrl.order(click_count: :desc).limit(100)
    render json: {:urls => @urls}, status: :ok
  end

  # Register the full url within the database and Update the title column with the title of the webpage using a background Job.
  #
  # Returns a json containing the information about the ful_url that got created.
  def create
    full_url = params[:full_url]
    @short_url = ShortUrl.new(full_url: full_url)
    if @short_url.save
      # Use the id to find the record and call the background job.
      UpdateTitleJob.perform_later(@short_url.id)
      render json: @short_url, status: :created
    else
      render json: {:errors => @short_url.errors.values.flatten}, status: :bad_request
    end
  end

  def show
  end

end
