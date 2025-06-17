class ContactDetails::Linkedin < ContactDetails::Base

  protected

  def prepare_value
    @value = @string.split('?')
                    .first
    @value << '/' unless @value.end_with?('/')
    @value
  end

  def prepare_label
    @label = @string.remove('https://')
                    .remove('http://')
                    .remove('www.')
                    .remove('linkedin.com/in/')
                    .remove('linkedin.com/company/')
                    .remove('@')
                    .remove('/')
                    .split('?')
                    .first
    @label = CGI.unescape @label
  end
end