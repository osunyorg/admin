module Communication::Website::WithNodc
  extend ActiveSupport::Concern

  included do
    after_save :nodc_setup, if: -> { hosted_with_nodc? && !nodc_setup_done? }
    after_save :nodc_golive, if: -> { hosted_with_nodc? && saved_change_to_in_production? && in_production }
  end

  def nodc_s3_url
    return unless hosted_with_nodc? && nodc_identifier.present?
    "s3://#{nodc_identifier}?endpoint=#{Nodc::S3_ENDPOINT}&awssdk=v2&use_path_style=true&region=#{Nodc::S3_REGION}&disable_https=false"
  end

  # 4 options:
  # 1. no nodc hosting at all -> do nothing
  # 2. no repo, nodc hosting : we need to create both
  # 3. repo exists, nodc hosting : only create nodc hosting
  # 4. both exists, nodc hosting needs to change identifier (Waiting for API possibility)
  def nodc_setup
    Communication::Website::Nodc::SetupJob.perform_later(id)
  end

  def nodc_golive
    Communication::Website::Nodc::GoliveJob.perform_later(id)
  end

  # Appelé par Communication::Website::Nodc::SetupJob
  def nodc_setup_safely
    return unless hosted_with_nodc?
    if repository.blank?
      create_github_repository
      sleep 10
    end
    if nodc_identifier.blank?
      nodc_create_bucket
      nodc_update_github_secrets
      sleep 10
      nodc_generate_certificate
      sleep 10
      save
    end
  end

  def nodc_golive_safely
    return unless hosted_with_nodc? && in_production?
    # https://www.test.com -> www.test.com
    new_identifier = URI(url).host
    should_rename = self.nodc_identifier != new_identifier

    if should_rename && !nodc.rename_bucket(self.nodc_identifier, new_identifier)
      raise "Failed to rename bucket from #{self.nodc_identifier} to #{new_identifier}"
    end
    update(nodc_identifier: new_identifier)
  end

  def nodc_destroy_bucket
    return unless hosted_with_nodc?
    nodc.empty_and_delete_bucket(nodc_identifier)
  end

  protected

  def nodc_setup_done?
    hosted_with_nodc? && repository.present? && nodc_identifier.present?
  end

  def nodc_create_bucket
    bucket_info = nodc.create_bucket(nodc_default_identifier)
    update_columns  nodc_identifier: bucket_info[:identifier],
                    nodc_access_key_id: bucket_info[:access_key_id],
                    nodc_secret_access_key: bucket_info[:secret_access_key],
                    url: "https://#{nodc_default_identifier}"
  end

  def nodc_update_github_secrets
    git_repository.update_secrets({
      "NODC_ACCESS_KEY" => nodc_access_key_id,
      "NODC_SECRET" => nodc_secret_access_key
    })
  end

  # cartographie.agit.nodc.osuny.site
  def nodc_default_identifier
    "#{original_localization.to_s.parameterize}.#{university.identifier}.nodc.osuny.site"
  end

  def nodc_generate_certificate
    Faraday.get url
  rescue
    # The certificate is not there yet, it is supposed to fail
    # This first call will generate it
  end

  def nodc
    @nodc ||= Nodc.new
  end
end
