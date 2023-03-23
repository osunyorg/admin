class Doi
  PREFIX = 'https://dx.doi.org/'.freeze

  def self.url(doi)
    return nil if doi.blank?
    return doi if PREFIX.in?(doi)
    "#{PREFIX}#{doi}"
  end

end