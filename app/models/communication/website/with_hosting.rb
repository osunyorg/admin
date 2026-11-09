module Communication::Website::WithHosting
  extend ActiveSupport::Concern

  included do
    enum :hosting, {
      undefined: 0,
      deuxfleurs: 1,
      apache: 2,
      nginx: 3,
      netlify: 4,
      nodc: 5
    },
    prefix: :hosted_with

    scope :for_hosting, ->(hosting, language = nil) { where(hosting: hosting) }
  end

  def hosting_hint
    if hosted_with_nodc?
      nodc_identifier
    elsif hosted_with_deuxfleurs?
      deuxfleurs_identifier
    end
  end

  def should_use_hugo_aliases?
    hosted_with_undefined? || hosted_with_nginx?
  end

end
