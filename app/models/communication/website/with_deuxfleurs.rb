module Communication::Website::WithDeuxfleurs
  extend ActiveSupport::Concern

  included do
    after_save :deuxfleurs_setup, if: :deuxfleurs_hosting
  end

  protected

  # 4 options:
  # 1. no deuxfleurs hosting at all -> do nothing
  # 2. no repo, deuxfleurs hosting : we need to create both
  # 3. repo exists, deuxfleurs hosting : only create deuxfleurs hosting
  # 4. both exists, deuxfleurs hosting needs to change identifier (Waiting for API possibility)
  def deuxfleurs_setup
    return unless deuxfleurs_hosting?
    if repository.blank?
      deuxfleurs_create_github_repository
    end
    if deuxfleurs_identifier.blank?
      deuxfleurs_create_bucket
      deuxfleurs_generate_certificate
      sleep 30
      save
    end
  end
  handle_asynchronously :deuxfleurs_setup

  def deuxfleurs_create_bucket
    deuxfleurs_identifier = deuxfleurs.create_bucket(deuxfleurs_default_identifier)
    update_columns  deuxfleurs_identifier: deuxfleurs_identifier,
                    url: deuxfleurs_default_url
  end

  def deuxfleurs_create_github_repository
    update_columns  access_token: ENV['GITHUB_ACCESS_TOKEN'],
                    repository: deuxfleurs_default_github_repository,
                    deployment_status_badge: deuxfleurs_default_badge_url
    git_repository.init_from_template(deuxfleurs_default_identifier)
  end

  def deuxfleurs_default_identifier
    "#{university.identifier}-#{to_s.parameterize}"
  end

  def deuxfleurs_default_github_repository
    "noesya/#{deuxfleurs_default_identifier}"
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

  def deuxfleurs_default_url
    deuxfleurs.default_url_for(deuxfleurs_default_identifier)
  end

  def deuxfleurs
    @deuxfleurs ||= Deuxfleurs.new
  end
end