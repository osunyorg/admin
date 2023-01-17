class ContactDetails::Twitter < ContactDetails::Website
  ROOT = 'twitter.com/'

  protected
  
  def prepare_label
    super
    @label.remove! ROOT
  end
end