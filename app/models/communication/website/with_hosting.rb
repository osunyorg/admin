module Communication::Website::WithHosting
  extend ActiveSupport::Concern

  included do
    enum :hosting, {
      undefined: 0,
      deuxfleurs: 1,
      apache: 2,
      nginx: 3,
      netlify: 4
    },
    prefix: :hosted_with

    scope :for_hosting, ->(hosting, language = nil) { where(hosting: hosting) }
  end

  def should_use_hugo_aliases?
    hosted_with_undefined? || hosted_with_nginx?
  end

end
