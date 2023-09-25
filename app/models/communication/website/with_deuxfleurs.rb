module Communication::Website::WithDeuxfleurs
  extend ActiveSupport::Concern

  included do
    before_validation :setup_deuxfleurs_if_necessary
  end

  protected

  def deuxfleurs_setup_done?
    deuxfleurs_id.present?
  end

  def setup_deuxfleurs_if_necessary
    return if deuxfleurs_setup_done?
    self.deuxfleurs_id = deuxfleurs.create_bucket(deuxfleurs_host)
  end

  def deuxfleurs_host
    "#{university.identifier}-#{to_s.parameterize}"
  end

  def deuxfleurs
    @deuxfleurs ||= Deuxfleurs.new
  end
end