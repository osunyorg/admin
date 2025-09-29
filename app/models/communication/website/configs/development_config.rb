# == Schema Information
#
# Table name: communication_websites
#
#  id                           :uuid             not null, primary key
#  about_type                   :string           indexed => [about_id]
#  access_token                 :string
#  archive_content              :boolean          default(FALSE)
#  autoupdate_theme             :boolean          default(TRUE)
#  default_time_zone            :string
#  deployment_status_badge      :text
#  deuxfleurs_hosting           :boolean          default(TRUE)
#  deuxfleurs_identifier        :string
#  deuxfleurs_secret_access_key :string
#  feature_agenda               :boolean          default(FALSE)
#  feature_alerts               :boolean          default(FALSE)
#  feature_alumni               :boolean          default(FALSE)
#  feature_hourly_publication   :boolean          default(FALSE)
#  feature_jobboard             :boolean          default(FALSE)
#  feature_portfolio            :boolean          default(FALSE)
#  feature_posts                :boolean          default(TRUE)
#  git_branch                   :string
#  git_endpoint                 :string
#  git_files_analysed_at        :datetime
#  git_provider                 :integer          default("github")
#  highlighted_in_showcase      :boolean          default(FALSE)
#  in_production                :boolean          default(FALSE)
#  in_production_at             :datetime
#  in_showcase                  :boolean          default(TRUE)
#  last_sync_at                 :datetime
#  locked_at                    :datetime
#  plausible_url                :string
#  repository                   :string
#  style                        :text
#  style_updated_at             :date
#  theme_version                :string           default("NA")
#  url                          :string
#  years_before_archive_content :integer          default(3)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  about_id                     :uuid             indexed => [about_type]
#  default_language_id          :uuid             not null, indexed
#  deuxfleurs_access_key_id     :string
#  locked_by_job_id             :uuid
#  university_id                :uuid             not null, indexed
#
# Indexes
#
#  index_communication_websites_on_about                (about_type,about_id)
#  index_communication_websites_on_default_language_id  (default_language_id)
#  index_communication_websites_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_2b6d929310  (default_language_id => languages.id)
#  fk_rails_bb6a496c08  (university_id => universities.id)
#
class Communication::Website::Configs::DevelopmentConfig < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::DevelopmentConfig'
  end

  def git_path(website)
    "config/development/config.yaml"
  end

  def template_static
    "admin/communication/websites/configs/development_config/static"
  end

end
