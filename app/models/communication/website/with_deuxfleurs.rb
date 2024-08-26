module Communication::Website::WithDeuxfleurs
  extend ActiveSupport::Concern

  included do
    before_save :deuxfleurs_golive, if: :deuxfleurs_hosting
    after_save :deuxfleurs_setup, if: :deuxfleurs_hosting

    scope :hosted_on_deuxfleurs, -> { where(deuxfleurs_hosting: true) }
  end

  # 4 options:
  # 1. no deuxfleurs hosting at all -> do nothing
  # 2. no repo, deuxfleurs hosting : we need to create both
  # 3. repo exists, deuxfleurs hosting : only create deuxfleurs hosting
  # 4. both exists, deuxfleurs hosting needs to change identifier (Waiting for API possibility)
  def deuxfleurs_setup
    return unless deuxfleurs_hosting?
    return if deuxfleurs_setup_done?
    Communication::Website::Deuxfleurs::SetupJob.perform_later(id)
  end

  # Appelé par Communication::Website::Deuxfleurs::SetupJob
  def deuxfleurs_setup_safely
    return unless deuxfleurs_hosting?
    if repository.blank?
      deuxfleurs_create_github_repository
      sleep 10
    end
    if deuxfleurs_identifier.blank?
      deuxfleurs_create_bucket
      deuxfleurs_update_github_secrets
      sleep 10
      deuxfleurs_generate_certificate
      sleep 10
      save
    end
  end

  protected

  def deuxfleurs_setup_done?
    deuxfleurs_hosting? && repository.present? && deuxfleurs_identifier.present?
  end

  def deuxfleurs_golive
    return unless in_production_changed? && in_production
    # https://www.test.com -> www.test.com
    new_identifier = URI(url).host
    if deuxfleurs.rename_bucket(self.deuxfleurs_identifier, new_identifier)
      self.deuxfleurs_identifier = new_identifier
    else
      errors.add :url
    end
  end

  def deuxfleurs_create_bucket
    bucket_info = deuxfleurs.create_bucket(deuxfleurs_default_identifier)
    update_columns  deuxfleurs_identifier: bucket_info[:identifier],
                    deuxfleurs_access_key_id: bucket_info[:access_key_id],
                    deuxfleurs_secret_access_key: bucket_info[:secret_access_key],
                    url: deuxfleurs_default_url
  end

  def deuxfleurs_create_github_repository
    update_columns  access_token: ENV['GITHUB_ACCESS_TOKEN'],
                    repository: deuxfleurs_default_github_repository,
                    deployment_status_badge: deuxfleurs_default_badge_url
    git_repository.init_from_template(deuxfleurs_default_github_repository_name)
  end

  def deuxfleurs_update_github_secrets
    git_repository.update_secrets({
      "DEUXFLEURS_ACCESS_KEY" => deuxfleurs_access_key_id,
      "DEUXFLEURS_SECRET" => deuxfleurs_secret_access_key
    })
  end

  # cartographie.agit.osuny.site
  def deuxfleurs_default_identifier
    "#{to_s.parameterize}.#{university.identifier}.osuny.site"
  end

  # https://cartographie.agit.osuny.site
  def deuxfleurs_default_url
    "https://#{deuxfleurs_default_identifier}"
  end

  # agit-cartographie
  def deuxfleurs_default_github_repository_name
    "#{university.identifier}-#{to_s.parameterize}"
  end

  # osunyorg/agit-cartographie
  def deuxfleurs_default_github_repository
    "#{ENV['GITHUB_ORGANIZATION']}/#{deuxfleurs_default_github_repository_name}"
  end

  def deuxfleurs_default_badge_url
    "https://github.com/#{deuxfleurs_default_github_repository}/actions/workflows/deuxfleurs.yml/badge.svg"
  end

  def deuxfleurs_generate_certificate
    Faraday.get url
  rescue
    # The certificate is not there yet, it is supposed to fail
    # This first call will generate it
  end

  def deuxfleurs
    @deuxfleurs ||= Deuxfleurs.new
  end
end