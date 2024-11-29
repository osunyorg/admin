class ContactDetails
  
  SOCIAL_NETWORKS = [
    :facebook,
    :github,
    :instagram,
    :linkedin,
    :mastodon,
    :peertube,
    :tiktok,
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
end