module Communication::Website::WithKelmscott
  extend ActiveSupport::Concern

  included do
    enum :kelmscott_sync_method, {
      sftp: 10,
      dxfl: 20,
      rsync: 30,
      s3: 40
    },
    prefix: :kelmscott_synced_with

    has_many  :variables,
              class_name: 'Communication::Website::Variable',
              foreign_key: :communication_website_id,
              inverse_of: :communication_website,
              dependent: :destroy
    accepts_nested_attributes_for :variables,
                                  reject_if: -> (attributes) { attributes['id'].blank? && attributes['value'].blank? }

    validates :kelmscott_sync_method, presence: true, if: :kelmscott_active?

    after_save :clean_kelmscott_variables, if: :saved_change_to_kelmscott_sync_method?
  end

  def kelmscott_publish
    return unless kelmscott_active?
    Communication::Website::Kelmscott::PublishJob.perform_later(id)
  end

  def kelmscott_publish_safely
    return unless kelmscott_active? && repository.present?
    response = Kelmscott.new(self).publish
    raise "Kelmscott refused to publish #{repository}: #{response.status} #{response.body}" unless response.status == 202
  end

  # https://kelmscott.osuny.org/noesya/noesya-www
  def kelmscott_url
    "#{ENV['KELMSCOTT_URL']}/#{repository}"
  end

  # https://kelmscott.osuny.org/noesya/noesya-www/badge.svg
  def kelmscott_badge_url
    "#{kelmscott_url}/badge.svg"
  end

  def kelmscott_variable(key)
    variables.detect { |variable| variable.key == key } || variables.build(key: key)
  end

  protected

  # Les variables dépendent du type de synchronisation :
  # celles qui ne correspondent plus au type choisi sont supprimées.
  def clean_kelmscott_variables
    keys = Communication::Website::Variable.keys_for(kelmscott_sync_method)
    variables.where.not(key: keys).destroy_all
  end

end
