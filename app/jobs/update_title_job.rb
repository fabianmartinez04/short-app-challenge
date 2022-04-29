class UpdateTitleJob < ApplicationJob
  queue_as :default

  # What this job does is update the title attribute with the shortened url,
  # calling the method inside the short_url called update_tittle!.
  # This is done in the background.
  def perform(short_url_id)
    ShortUrl.find(short_url_id).update_title!
  end
end
