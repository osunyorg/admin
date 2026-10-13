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
              dependent: :destroy
    accepts_nested_attributes_for :variables,
                                  reject_if: -> (attributes) { attributes['id'].blank? && attributes['value'].blank? }

    validates :kelmscott_sync_method, presence: true, if: :kelmscott_active?

    after_save :clean_kelmscott_variables
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
