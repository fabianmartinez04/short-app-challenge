# Imported libraries.
require 'uri'
require 'nokogiri'
require 'open-uri'

class ShortUrl < ApplicationRecord

  CHARACTERS = [*'0'..'9', *'a'..'z', *'A'..'Z'].freeze
  
  # Regular expression to validate the full URL.
  URL_REGEX = Regexp.new('\A(?:(?:http(?:s)?|ftp)://)(?:\\S+(?::(?:\\S)*)?@)?(?:(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)(?:\\.(?:[a-z0-9\u00a1-\uffff](?:-)*)*(?:[a-z0-9\u00a1-\uffff])+)*(?:\\.(?:[a-z0-9\u00a1-\uffff]){2,})(?::(?:\\d){2,5})?(?:/(?:\\S)*)?\Z')
  validates :full_url, presence: true
  validate :validate_full_url

  # Gets the id from db as a parameter and calls the function encode_id(id).
  #
  # Returns the short code in base62.
  def short_code
    return nil if id == nil
    encode_id(id)
  end

  # This algorithm encodes the id in base10 and returns a string in base62.
  def encode_id(id)
    code = ""
    length = CHARACTERS.length
    # id needs to be > 0
    while id.positive?
      code = CHARACTERS[id % length] + code
      id = id / length
    end
    code
  end

  # Updates the title attribute of the ShortUrl.
  #
  # Return an error if the url is not allowed.
  def update_title!
    begin
      tempfile = URI.open(full_url)
      #Gets the title directly from the web page.
      document = Nokogiri::HTML.parse(tempfile)
      title = document.title || ''
      update(title: title)
    rescue StandardError
      errors.add(:full_url, :invalid_url, "Unable to access url entered.")
    end
  end

  # Decodes the short code in base62 to an Integer in base10.
  #
  # Returns an Integer that is the "id" of the url.
  def self.decode_short_code(code)
    return nil if code == nil
    number = 0
    length = CHARACTERS.length
    code.to_s.each_char do |char|
      number = (number*length) + CHARACTERS.index(char)
    end
    number
  end

  # Call the decode_short_code method to convert the short code into an integer (id) and returns a ShortUrl object.
  def self.find_by_short_code(short_code)
    id = decode_short_code(short_code)
    find_by!(id: id)
  end

  # This method is almost always used to return a hash representing of the model.
  #
  # In this case, the configuration is passed through options (when need to pass optional arguments to method).
  def as_json(options={})
    super(methods: :short_code)
  end

  # This method is used to display all the attributes of the object and to fulfill the tests.
  def public_attributes
    as_json
  end

  private

  # Validates that the full url entered is correct.
  def validate_full_url
    # The =~ operator matches the regular expression against a string.
    if not full_url =~ URL_REGEX
      errors.add(:full_url, "is not a valid url")
    end
  end

end
