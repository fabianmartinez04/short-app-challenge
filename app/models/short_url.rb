class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  
  #Regular expression to validate the full URL.
  URL_REGEX = Regexp.new('\A(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?\Z')
  validates :full_url, presence: true
  validate :validate_full_url

  def short_code
  end

  def update_title!
  end

  private

  def validate_full_url
    #The =~ operator matches the regular expression against a string.
    if not full_url =~ URL_REGEX
      errors.add(:full_url, 'The digited URL is not valid, please enter a correct structure of URL.')
    end
  end

end
