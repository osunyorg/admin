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
              inverse_of: :website,
              autosave: true,
              dependent: :destroy

    validates :kelmscott_sync_method, presence: true, if: :kelmscott_active?

    before_validation :assign_kelmscott_variables
    after_save :clean_kelmscott_variables, if: :saved_change_to_kelmscott_sync_method?
  end

  def kelmscott_publish
    return unless kelmscott_publishable?
    Communication::Website::Kelmscott::PublishJob.perform_later(id)
  end

  def kelmscott_publish_safely
    return unless kelmscott_publishable?
    response = Kelmscott.new(self).publish
    raise "Kelmscott refused to publish #{kelmscott_path}: #{response.status} #{response.body}" unless response.status == 202
  end

  # Identifiant de l'université et nom du dépôt : osunydev/rennes-ici -> /rennes-staging/rennes-ici
  def kelmscott_path
    "/#{university.identifier}/#{repository.split('/').last}"
  end

  # https://kelmscott.osuny.org/rennes-staging/rennes-ici
  def kelmscott_url
    "#{ENV['KELMSCOTT_URL']}#{kelmscott_path}"
  end

  # https://kelmscott.osuny.org/rennes-staging/rennes-ici/badge.svg
  def kelmscott_badge_url
    "#{kelmscott_url}/badge.svg"
  end

  def kelmscott_variable(key)
    variables.detect { |variable| variable.key == key } || variables.build(key: key)
  end

  # Valeurs du formulaire, par méthode puis par nom de variable. Les blocs des autres méthodes, masqués,
  # sont envoyés aussi, et certaines variables sont communes à plusieurs méthodes (AWS_*) :
  # seules les valeurs de la méthode choisie sont gardées, à l'enregistrement.
  attr_writer :kelmscott_variables

  protected

  # Un champ vide supprime la variable, sauf un secret déjà enregistré : il n'est jamais renvoyé au formulaire.
  def assign_kelmscott_variables
    return if @kelmscott_variables.nil?
    @kelmscott_variables.to_h.fetch(kelmscott_sync_method.to_s, {}).each do |key, value|
      variable = kelmscott_variable(key)
      if value.present?
        variable.value = value
      elsif variable.new_record? || !variable.secret?
        variable.mark_for_destruction
      end
    end
    @kelmscott_variables = nil
  end

  def kelmscott_publishable?
    kelmscott_active? && repository.present?
  end

  # Les variables dépendent du type de synchronisation :
  # celles qui ne correspondent plus au type choisi sont supprimées.
  def clean_kelmscott_variables
    keys = Communication::Website::Variable::KEYS_BY_SYNC_METHOD.fetch(kelmscott_sync_method.to_s, [])
    variables.where.not(key: keys).destroy_all
  end

end
