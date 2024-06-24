module Git::Providers::Github::WithSecrets
  extend ActiveSupport::Concern

  def update_secrets(secrets)
    secrets.each do |secret_key, secret_value|
      encrypted_secret_options = encrypt_secret_value(secret_value)
      client.create_or_update_actions_secret(repository, secret_key, encrypted_secret_options)
    end
  end

  protected

  def encrypt_secret_value(value)
    encrypted_secret_value = libsodium_box.encrypt(value)
    base64_encrypted_secret_value = Base64.strict_encode64(encrypted_secret_value)
    {
      key_id: public_key_id,
      encrypted_value: base64_encrypted_secret_value
    }
  end

  def libsodium_box
    @libsodium_box ||= begin
      key = Base64.decode64(public_key_hash[:key])
      public_key = RbNaCl::PublicKey.new(key)
      RbNaCl::Boxes::Sealed.from_public_key(public_key)
    end
  end

  def public_key_id
    public_key_hash[:key_id]
  end

  def public_key_hash
    # { key_id: "...", key: "..." }
    @public_key_hash ||= client.get_actions_public_key(repository)
  end
end