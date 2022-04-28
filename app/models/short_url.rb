class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  
  #Regular expression to validate the full URL.
  URL_REGEX = Regexp.new('\A(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?\Z')
  validates :full_url, presence: true
  validate :validate_full_url

  #Gets the id from db as a parameter and calls the function encode_id(id).
  #Returns the short code in base62.
  def short_code
    return nil if id == nil
    encode_id(id)
  end

  #This algorithm encodes the id in base10 and returns a string in base62.
  def encode_id(id)
    code = ""
    length = CHARACTERS.length

    #id needs to be > 0
    while id.positive?
      code = CHARACTERS[id % length] + code
      id = id / length
    end
    code

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
