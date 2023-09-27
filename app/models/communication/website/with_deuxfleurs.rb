module Communication::Website::WithDeuxfleurs
  extend ActiveSupport::Concern

  included do
    after_save :deuxfleurs_setup, if: :deuxfleurs_hosting
  end

  protected

  def deuxfleurs_setup_done?
    deuxfleurs_identifier.present?
  end

  def deuxfleurs_setup
    return if deuxfleurs_setup_done?
    deuxfleurs_create_website
    deuxfleurs_create_github_repository
  end
  handle_asynchronously :deuxfleurs_setup

  def deuxfleurs_create_website
    deuxfleurs_identifier = deuxfleurs.create_bucket(deuxfleurs_default_identifier)
    update_columns  deuxfleurs_identifier: deuxfleurs_identifier,
                    url: deuxfleurs_default_url
    deuxfleurs_first_load_to_generate_certificate
  endcd 

  def deuxfleurs_create_github_repository
    # TODO create repo at  template 
    update_columns  repository: deuxfleurs_default_github_repository,
                    deployment_status_badge: deuxfleurs_default_badge_url
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

  def deuxfleurs_first_load_to_generate_certificate
    Faraday.get url
  rescue
    # The certificate is not there yet, it is supposed to fail
    # This first call will generate it
  end
  handle_asynchronously :deuxfleurs_first_load_to_generate_certificate

  def deuxfleurs_default_url
    deuxfleurs.default_url_for(deuxfleurs_host)
  end

  def deuxfleurs
    @deuxfleurs ||= Deuxfleurs.new
  end
end