class ContactDetails::Base
  attr_accessor :url, :label

  def initialize(string)
    @string = string.to_s
    return if @string.blank?
    prepare_url
    prepare_label
  end

  def present?
    label.present? && url.present?
  end

  protected

  def prepare_url
    @url = @string.dup
  end

  def prepare_label
    @label = @string.dup
  end
end