module Communication::Website::WithRealmCommunication
  extend ActiveSupport::Concern

  included do
    has_many    :permalinks,
                class_name: "Communication::Website::Permalink",
                dependent: :destroy

    has_many    :communication_blocks,
                class_name: "Communication::Block",
                foreign_key: :communication_website_id
    alias       :blocks :communication_blocks
  end

  # Starting from Hugo 0.155, aliases are site-relative,
  # so we need to go one level up on multilingual sites to get the correct path.
  # More info: https://developers.osuny.org/docs/theme/architecture/aliases/
  def permalink_prefix
    return @permalink_prefix if defined?(@permalink_prefix)
    @permalink_prefix = active_languages.many? ? "/.." : ""
  end

end
