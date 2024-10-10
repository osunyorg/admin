class ContactDetails::Linkedin < ContactDetails::Base

  protected

  def prepare_value
    @value = @string
  end

  def prepare_label
    @label = @string.remove('https://')
                    .remove('http://')
                    .remove('www.')
                    .remove('linkedin.com/in/')
                    .remove('linkedin.com/company/')
                    .remove('@')
                    .remove('/')
  end
end