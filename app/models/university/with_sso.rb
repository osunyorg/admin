module University::WithSso
  extend ActiveSupport::Concern

  included do
    enum sso_provider: { saml: 0 }, _prefix: :with_sso_via

    validates :sso_cert, :sso_name_identifier_format, :sso_target_url, presence: true, if: :has_sso?

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
