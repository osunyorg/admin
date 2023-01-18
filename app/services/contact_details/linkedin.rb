class ContactDetails::Linkedin < ContactDetails::Website
  ROOT = 'www.linkedin.com/in/'

  protected

  def prepare_label
    super
    @label.remove! ROOT
    @label.chomp! '/'
  end
end