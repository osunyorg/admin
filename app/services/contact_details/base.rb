class ContactDetails::Base
  attr_accessor :url, :label

  def initialize(string)
    @string = string.to_s
    prepare_url
    prepare_label
  end

  protected

  def prepare_label
    @label = @string
  end

  def prepare_url
    @url = @string
  end
end