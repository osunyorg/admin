module University::WithSso
  extend ActiveSupport::Concern

  included do
    enum sso_provider: { saml: 0, oauth2: 10 }, _prefix: :with_sso_via
  end

  # Setter to serialize data as JSON
  def sso_mapping=(value)
    if value.empty?
      value = nil
    else
      value = JSON.parse value if value.is_a? String
    end
    super(value)
  end

end
