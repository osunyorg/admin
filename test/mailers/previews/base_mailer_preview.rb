class BaseMailerPreview < ActionMailer::Preview

  protected

  def university
    @university ||= University.first
  end

  def user
    @user ||= university.users.first
  end

  def website
    @website ||= university.communication_websites.first
  end

  def organizations_import
    @organizations_import ||= Import.new(
      id: SecureRandom.uuid,
      university: university,
      kind: :organizations,
      number_of_lines: 42,
      processing_errors: {},
      status: :finished,
      user: user
    )
  end

  def sample_emergency_message
    @sample_emergency_message ||= EmergencyMessage.new(
      id: SecureRandom.uuid,
      university: university,
      name: "Message d'urgence",
      content_en: "This is an emergency message.",
      content_fr: "Ceci est un message d'urgence.",
      role: 'admin',
      subject_en: "Warning",
      subject_fr: "Attention"
    )
  end

end
