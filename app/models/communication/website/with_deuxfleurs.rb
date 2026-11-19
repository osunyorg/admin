module Communication::Website::WithDeuxfleurs
  extend ActiveSupport::Concern

  included do
    after_save :deuxfleurs_setup, if: -> { hosted_with_deuxfleurs? && !deuxfleurs_setup_done? }
    after_save :deuxfleurs_golive, if: -> { hosted_with_deuxfleurs? && saved_change_to_in_production? && in_production }
  end

  # 4 options:
  # 1. no deuxfleurs hosting at all -> do nothing
  # 2. no repo, deuxfleurs hosting : we need to create both
  # 3. repo exists, deuxfleurs hosting : only create deuxfleurs hosting
  # 4. both exists, deuxfleurs hosting needs to change identifier (Waiting for API possibility)
  def deuxfleurs_setup
    Communication::Website::Deuxfleurs::SetupJob.perform_later(id)
  end

  def deuxfleurs_golive
    Communication::Website::Deuxfleurs::GoliveJob.perform_later(id)
  end

  # Appelé par Communication::Website::Deuxfleurs::SetupJob
  def deuxfleurs_setup_safely
    return unless hosted_with_deuxfleurs?
    if repository.blank?
      create_github_repository
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

  def deuxfleurs_golive_safely
    return unless hosted_with_deuxfleurs? && in_production?
    # https://www.test.com -> www.test.com
    new_identifier = URI(url).host
    should_rename = self.deuxfleurs_identifier != new_identifier

    if should_rename && !deuxfleurs.rename_bucket(self.deuxfleurs_identifier, new_identifier)
      raise "Failed to rename bucket from #{self.deuxfleurs_identifier} to #{new_identifier}"
    end
    update(deuxfleurs_identifier: new_identifier)
  end

  def deuxfleurs_destroy_bucket
    return unless hosted_with_deuxfleurs?
    deuxfleurs.empty_and_delete_bucket(deuxfleurs_identifier)
  end

  protected

  def deuxfleurs_setup_done?
    hosted_with_deuxfleurs? && repository.present? && deuxfleurs_identifier.present?
  end

  def deuxfleurs_create_bucket
    bucket_info = deuxfleurs.create_bucket(deuxfleurs_default_identifier)
    update_columns  deuxfleurs_identifier: bucket_info[:identifier],
                    deuxfleurs_access_key_id: bucket_info[:access_key_id],
                    deuxfleurs_secret_access_key: bucket_info[:secret_access_key],
                    url: "https://#{deuxfleurs_default_identifier}"
  end

  def deuxfleurs_update_github_secrets
    git_repository.update_secrets({
      "DEUXFLEURS_ACCESS_KEY" => deuxfleurs_access_key_id,
      "DEUXFLEURS_SECRET" => deuxfleurs_secret_access_key
    })
  end

  # cartographie.agit.osuny.site
  def deuxfleurs_default_identifier
    "#{original_localization.to_s.parameterize}.#{university.identifier}.osuny.site"
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
