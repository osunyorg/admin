class ContactDetails
  def self.with_kind(kind)
    "ContactDetails::#{kind.to_s.camelize}".constantize
  end

  def self.for(kind, string)
    with_kind(kind).new(string)
  end
end