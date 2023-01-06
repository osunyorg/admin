class ActiveStorageKeyConverter
  def self.convert(legacy_signed_id)
    # Try to find blob with the un-modified legacy_signed_id
    blob = ActiveStorage::Blob.find_signed!(legacy_signed_id)
    legacy_signed_id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    #
    key_generator = ActiveSupport::KeyGenerator.new(
      Rails.application.secrets.secret_key_base,
      iterations: 1000,
      hash_digest_class: OpenSSL::Digest::SHA1
    )
    key_generator = ActiveSupport::CachingKeyGenerator.new(key_generator)
    secret = key_generator.generate_key("ActiveStorage")
    verifier = ActiveSupport::MessageVerifier.new(secret)

    ActiveStorage::Blob.find_by_id(verifier.verify(legacy_signed_id, purpose: :blob_id)).try(:signed_id)
  end
end
