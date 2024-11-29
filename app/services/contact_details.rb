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

  def self.find_data(variable, about, l10n, possible_prefix: nil)
    # about.linkedin
    method = "#{variable}"
    # about.social_linkedin
    prefixed_method = "#{possible_prefix}#{variable}"
    data = nil
    # Search in about
    if about.respond_to?(method)
      data = about.send(method)
    elsif about.respond_to?(prefixed_method)
      data = about.send(prefixed_method)
    end
    # Search in localization
    if l10n.present?
      if l10n.respond_to?(method)
        data = l10n.send(method)
      elsif l10n.respond_to?(prefixed_method)
        data = l10n.send(prefixed_method)
      end
    end
    data
  end

  def self.find_social(variable, about, l10n)
    find_data(variable, about, l10n, possible_prefix: 'social_')
  end
end