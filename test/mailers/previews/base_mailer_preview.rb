class BaseMailerPreview < ActionMailer::Preview

  def self.call(email, params = {})
    message = nil
    ActiveRecord::Base.transaction do
      message = super(email, params)
      raise ActiveRecord::Rollback
    end
    message
  end

  protected

  def university
    @university ||= University.create!(
      name: 'Université de test',
      identifier: 'my-university',
      sms_sender_name: 'unitest',
      default_language: Language.find_by(iso_code: 'fr'),
      is_really_a_university: true,
      languages: Language.where(iso_code: ['fr', 'en'])
    )
  end

  def visitor_user
    @visitor_user ||= university.users.create!(
      confirmed_at: Time.zone.now,
      email: 'visitor@noesya.coop',
      first_name: 'Visitor',
      last_name: 'Osuny',
      role: :visitor,
      language: Language.find_by(iso_code: 'fr'),
      password: "ThisIsMyPassword123!"
    )
  end

  def user
    @user ||= university.users.create!(
      confirmed_at: Time.zone.now,
      email: 'test@noesya.coop',
      first_name: 'Server Admin',
      last_name: 'Osuny',
      role: :server_admin,
      language: Language.find_by(iso_code: 'fr'),
      password: "ThisIsMyPassword123!"
    )
  end

  def person
    @person ||= begin
      person = user.build_person(
        email: 'test@noesya.coop',
        university: university
      )
      person.localizations.build(
        language: Language.find_by(iso_code: 'fr'),
        first_name: 'Server Admin',
        last_name: 'Osuny',
        name: 'Server Admin Osuny'
      )
      person.save!
      person
    end
  end

  def website
    @website ||= begin
      website = university.communication_websites.new(
        git_provider: :github,
        git_endpoint: ENV['TEST_GITHUB_ENDPOINT'],
        git_branch: ENV['TEST_GITHUB_BRANCH'],
        access_token: ENV['TEST_GITHUB_TOKEN'],
        repository: ENV['TEST_GITHUB_REPOSITORY'],
        default_language: Language.find_by(iso_code: 'fr'),
        default_time_zone: 'Europe/Paris',
        deuxfleurs_hosting: false,
        feature_posts: true,
        feature_agenda: true
      )
      website.localizations.build(
        { 
          language: Language.find_by(iso_code: 'fr'),
          name:' Site with github french',
          published: true,
          published_at: Time.now
        }
      )
      website.save!
      website
    end
  end

  def extranet
    @extranet ||= begin
      extranet = university.communication_extranets.new(
        host: 'extranet.osuny.test',
        feature_alumni: false,
        feature_contacts: true,
        about: nil,
        default_language: Language.find_by(iso_code: 'fr')
      )
      extranet.localizations.build(
        { 
          language: Language.find_by(iso_code: 'fr'),
          name: 'Extranet de test',
          published: true,
          published_at: Time.now,
          university: university
        }

      )
      extranet.save!
      extranet
    end
  end

  def organizations_import
    @organizations_import ||= Import.create!(
      id: SecureRandom.uuid,
      university: university,
      kind: :organizations,
      number_of_lines: 42,
      processing_errors: {},
      status: :finished,
      user: user,
      language: Language.find_by(iso_code: 'fr')
    )
  end

  def sample_emergency_message
    @sample_emergency_message ||= EmergencyMessage.create!(
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
