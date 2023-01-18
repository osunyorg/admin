class ContactDetails::Base
  attr_accessor :value, :label

  def initialize(string)
    @string = string.to_s
    return if @string.blank?
    prepare_value
    prepare_label
  end

  def present?
    value.present?
  end

  protected

  def prepare_value
    @value = @string.dup
  end

  def prepare_label
    @label = @string.dup
  end
end