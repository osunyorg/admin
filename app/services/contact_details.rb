class ContactDetails

  PARTS = [
    :postal_address,
    :phone_numbers,
    :emails,
    :websites,
    :social_networks
  ]

  SOCIAL_NETWORKS = [
    :facebook,
    :github,
    :instagram,
    :linkedin,
    :mastodon,
    :peertube,
    :tiktok,
    :twitter,
    :vimeo,
    :x,
    :youtube
  ]

  PHONES = [
    :phone,
    :phone_mobile,
    :phone_professional,
    :phone_personal
  ]

  def self.with_kind(kind)
    "ContactDetails::#{kind.to_s.camelize}".constantize
  end

  def self.for(kind, string)
    with_kind(kind).new(string)
  end

  def self.find_data(attribute, about, l10n, possible_prefix: nil)
    data = find_data_in_about_or_l10n(attribute, about, l10n)
    if data.nil?
      prefixed_method = "#{possible_prefix}#{attribute}"
      data = find_data_in_about_or_l10n(prefixed_method, about, l10n)
    end
    data
  end

  def self.find_social(attribute, about, l10n)
    find_data(attribute, about, l10n, possible_prefix: 'social_')
  end

  protected

  def self.find_data_in_about_or_l10n(method, about, l10n)
    return about.public_send(method) if about.respond_to?(method)
    return l10n.public_send(method) if l10n.present? && l10n.respond_to?(method)
  end
end